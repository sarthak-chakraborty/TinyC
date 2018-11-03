
%{
	#include <stdio.h>
	#include <string.h>
	#include "ass5_16CS30044_translator.h"
	extern int yylex();
	extern int ln;
	void yyerror(const char *s);
	extern etype TYPE;
%}

%code requires{
			#include "ass5_16CS30044_translator.h"
		}

/** BISON Declarations */

%union {
	int intval;
	float floatval;
	char* strval;
	int instr;
	sym* symp;
	symType* st;
	statement* stat;
	expr* exp;
	lint* li;
	unary* UNA;
	char uop;
}

%token AUTO_K
%token ENUM_K
%token RESTRICT_K
%token UNSIGNED_K
%token BREAK_K
%token EXTERN_K
%token RETURN_K
%token VOID_K
%token CASE_K
%token FLOAT_K
%token SHORT_K
%token VOLATILE_K
%token CHAR_K
%token FOR_K
%token SIGNED_K
%token WHILE_K
%token CONST_K
%token GOTO_K
%token SIZEOF_K
%token _BOOL_K
%token CONTINUE_K
%token IF_K
%token STATIC_K
%token _COMPLEX_K
%token DEFAULT_K
%token INLINE_K
%token STRUCT_K
%token DO_K
%token INT_K
%token SWITCH_K
%token DOUBLE_K
%token LONG_K
%token TYPEDEF_K
%token ELSE_K
%token REGISTER_K
%token UNION_K
%token _IMAGINARY_K
%token <symp> ID
%token <intval> INT_CONST
%token <strval> FLOAT_CONST
%token <strval> ENUM_CONST
%token <cha> CHAR_CONST
%token <strval> STRING_CONST
%token LEFT_SQUARE_BRACKET
%token RIGHT_SQUARE_BRACKET
%token LEFT_ROUND_BRACKET
%token RIGHT_ROUND_BRACKET
%token LEFT_CURLY_BRACKET
%token RIGHT_CURLY_BRACKET
%token DOT
%token ARROW
%token INCREMENT
%token DECREMENT
%token AND
%token ASTERISK
%token PLUS
%token MINUS
%token TILDA
%token NOT
%token FORWARD_SLASH
%token PERCENT
%token LEFT_SHIFT
%token RIGHT_SHIFT
%token LESS_THAN
%token GREATER_THAN
%token LESS_THAN_EQUAL_TO
%token GREATER_THAN_EQUAL_TO
%token EQUAL_TO
%token NOT_EQUAL_TO
%token XOR_SIGN
%token OR
%token LOGICAL_AND
%token LOGICAL_OR
%token QUESTION_MARK
%token COLON
%token SEMI_COLON
%token ELLIPSIS
%token ASSIGNED
%token ASTERISK_EQUAL_TO
%token SLASH_EQUAL_TO
%token PERCENT_EQUAL_TO
%token PLUS_EQUAL_TO
%token MINUS_EQUAL_TO
%token LEFT_SHIFT_EQUAL_TO
%token RIGHT_SHIFT_EQUAL_TO
%token AND_EQUAL_TO
%token XOR_EQUAL_TO
%token OR_EQUAL_TO
%token COMMA
%token HASH
%token SINGLE_LINE_COMMENT
%token MULTI_LINE_COMMENT

%start translation_unit

%type <intval> argument_expression_list
%type <st> pointer
%type <uop> unary_operator
%type <symp> CONSTANT
%type <symp> initializer
%type <symp> declarator
%type <symp> direct_declarator
%type <symp> init_declarator
%type <exp> expression
%type <exp> primary_expression
%type <exp> additive_expression
%type <exp> multiplicative_expression
%type <exp> shift_expression
%type <exp> relational_expression
%type <exp> equality_expression
%type <exp> AND_expression
%type <exp> exclusive_OR_expression
%type <exp> inclusive_OR_expression
%type <exp> logical_AND_expression
%type <exp> logical_OR_expression
%type <exp> conditional_expression
%type <exp> assignment_expression
%type <exp> expression_statement		
%type <UNA> postfix_expression
%type <UNA> unary_expression
%type <UNA> cast_expression
%type <stat> statement
%type <stat> labeled_statement
%type <stat> compound_statement
%type <stat> selection_statement
%type <stat> iteration_statement
%type <stat> jump_statement
%type <stat> block_item
%type <stat> block_item_list
%type <instr> M
%type <exp> N
%%


M : %empty
	{
		$$ = nextinstr();
	}
	;

N : %empty
	{
		$$  = new expr();
		$$->nextlist = makelist(nextinstr());
		emit(GOTO,"");
	}
	;

CST : %empty
	{
		if (currsym->nest)
		{
			changeTable(currsym ->nest);
			emit(LABEL, table->tname);
		}
		else {
			changeTable(new symtab(""));
		}
	}
	;



/* *********EXPRESIION************ */
primary_expression: ID
					{
						$$ = new expr();
						$$->isbool = false;
						$$->symp = $1;
					}
					| CONSTANT
					{
						$$ = new expr();
						$$->symp = $1;
					}
					| STRING_CONST
					{
						$$ = new expr();
						$$->symp = gentemp(PTR, $1);
						$$->symp->initialize($1);
						$$->symp->type->ptr = new symType(CHAR);
					}
					| LEFT_ROUND_BRACKET expression RIGHT_ROUND_BRACKET
					{
						$$ = $2;
					}
					;
		
CONSTANT: INT_CONST
		  {
				$$ = gentemp(INT, number2string($1));
				emit(EQUAL, $$->name, $1);
		  }
		  | FLOAT_CONST
		  {
				$$ = gentemp(DOUBLE, *new string($1));
				emit(EQUAL, $$->name, *new string($1));
	   	  }
		  | ENUM_CONST{

		  }
		  | CHAR_CONST
		  {
				$$ = gentemp(CHAR);
				emit(EQUAL, $$->name, "c");
		  }
		  ;
		
postfix_expression: primary_expression
					{
						$$ = new unary();
						$$->loc = $$->symp;
						$$->symp = $1->symp;
						$$->type = $1->symp->type;
					}
					| postfix_expression LEFT_SQUARE_BRACKET expression RIGHT_SQUARE_BRACKET
					{
						$$ = new unary();
						$$->loc = gentemp(INT);
						$$->symp = $1->symp;
						$$->type = $1->type->ptr;
				
						if($1->cat !=ARR){
							emit(MULT, $$->loc->name, $3->symp->name, number2string(sizeOfType($$->type)));
						}
						else{
							sym* t = gentemp(INT);
							emit(MULT, t->name, $3->symp->name, number2string(sizeOfType($$->type)));
							emit (ADD, $$->loc->name, $1->loc->name, t->name);
						}

						$$->cat = ARR;
					}
					| postfix_expression LEFT_ROUND_BRACKET argument_expression_list RIGHT_ROUND_BRACKET
					{
						$$ = new unary();
						$$->symp = gentemp($1->type->cat);
						emit(CALL, $$->symp->name, $1->symp->name, tostr($3));
					}
					| postfix_expression LEFT_ROUND_BRACKET RIGHT_ROUND_BRACKET
					| postfix_expression DOT ID
					| postfix_expression ARROW ID
					| postfix_expression INCREMENT
					{
						$$ = new unary();
						$$->symp = gentemp($1->symp->type->cat);
						emit (EQUAL, $$->symp->name, $1->symp->name);
						emit (ADD, $1->symp->name, $1->symp->name, "1");
					}
					| postfix_expression DECREMENT
					{
						$$ = new unary();
						$$->symp = gentemp($1->symp->type->cat);
						emit (EQUAL, $$->symp->name, $1->symp->name);
						emit (SUB, $1->symp->name, $1->symp->name, "1");
					}
					| LEFT_ROUND_BRACKET type_name RIGHT_ROUND_BRACKET LEFT_CURLY_BRACKET initializer_list RIGHT_CURLY_BRACKET
					{
						$$ = new unary();
						$$->loc = gentemp(INT, "0");
						$$->symp = gentemp(INT, "0");
					}
					| LEFT_ROUND_BRACKET type_name RIGHT_ROUND_BRACKET LEFT_CURLY_BRACKET initializer_list COMMA RIGHT_CURLY_BRACKET
					{
						$$ = new unary();
						$$->loc = gentemp(INT, "0");
						$$->symp = gentemp(INT, "0");
					}
					;
		
argument_expression_list: assignment_expression
							{
								emit (PARAM, $1->symp->name);
								$$ = 1;
							}
							| argument_expression_list COMMA assignment_expression
							{
								emit (PARAM, $3->symp->name);
								$$ = $1+1;
							}
							;
		
unary_expression:	postfix_expression
					{
						$$ = $1;
					}
					| INCREMENT unary_expression
					{
						emit (ADD, $2->symp->name, $2->symp->name, "1");
						$$ = $2;
					}
					| DECREMENT unary_expression
					{
						emit (SUB, $2->symp->name, $2->symp->name, "1");
						$$ = $2;
					}
					| unary_operator cast_expression
					{
						$$ = new unary();
						if($1 == '&'){
							$$->symp = gentemp(PTR);
							$$->symp->type->ptr = $2->symp->type; 
							emit (ADDRESS, $$->symp->name, $2->symp->name);
						}
						else if($1 == '*'){
							$$->cat = PTR;
							$$->loc = gentemp ($2->symp->type->ptr);
							emit (PTRR, $$->loc->name, $2->symp->name);
							$$->symp = $2->symp;
						}
						else if($1 == '+'){
							$$ = $2;
						}
						else if($1 == '-'){
							$$->symp = gentemp($2->symp->type->cat);
							emit (UMINUS, $$->symp->name, $2->symp->name);
						}
						else if($1 == '~'){
							$$->symp = gentemp($2->symp->type->cat);
							emit (BNOT, $$->symp->name, $2->symp->name);
						}
						else if($1 == '!'){
							$$->symp = gentemp($2->symp->type->cat);
							emit (LNOT, $$->symp->name, $2->symp->name);
						}
					}
					| SIZEOF_K unary_expression
					{
						$$ = $2;
					}
					| SIZEOF_K LEFT_ROUND_BRACKET type_name RIGHT_ROUND_BRACKET
					{
						$$->symp = gentemp(INT, tostr(sizeOfType(new symType(TYPE))));
					}
					;
		
unary_operator: AND
				{
					$$ = '&';
				}
				| ASTERISK
				{
					$$ = '*';
				}
				| PLUS
				{
					$$ = '+';
				}
				| MINUS
				{
					$$ = '-';
				}
				| TILDA
				{
					$$ = '~';
				}
				| NOT
				{
					$$ = '!';
				}
				;
		
cast_expression: 	unary_expression
					{
						$$ = $1;
					}
					| LEFT_ROUND_BRACKET type_name RIGHT_ROUND_BRACKET cast_expression
					{
						$$ = $4;
					}
					;
		
multiplicative_expression:	cast_expression
							{
								$$ = new expr();
								if($1->cat==ARR){
									$$->symp = gentemp($1->loc->type);
									emit(ARRR, $$->symp->name, $1->symp->name, $1->loc->name);
								}
								else if($1->cat==PTR){
									$$->symp = $1->loc;
								}
								else{
									$$->symp = $1->symp;
								}
							}
							| multiplicative_expression ASTERISK cast_expression
							{
								if (typecheck ($1->symp, $3->symp) ) {
									$$ = new expr();
									$$->symp = gentemp($1->symp->type->cat);
									emit (MULT, $$->symp->name, $1->symp->name, $3->symp->name);
								}
								else cout << "Error in type compatibility !"<< endl;
							}
							| multiplicative_expression FORWARD_SLASH cast_expression
							{
								if (typecheck ($1->symp, $3->symp) ) {
									$$ = new expr();
									$$->symp = gentemp($1->symp->type->cat);
									emit (DIVIDE, $$->symp->name, $1->symp->name, $3->symp->name);
								}
								else cout << "Error in type compatibility !"<< endl;
							}
							| multiplicative_expression PERCENT cast_expression
							{
									if (typecheck ($1->symp, $3->symp) ) {
										$$ = new expr();
										$$->symp = gentemp($1->symp->type->cat);
										emit (MODOP, $$->symp->name, $1->symp->name, $3->symp->name);
									}
									else cout << "Error in type compatibility !"<< endl;
							}
							;
		
additive_expression:	multiplicative_expression
						{
							$$ = $1;
						}
						| additive_expression PLUS multiplicative_expression
						{
							if (typecheck($1->symp, $3->symp)) {
								$$ = new expr();
								$$->symp = gentemp($1->symp->type->cat);
								emit (ADD, $$->symp->name, $1->symp->name, $3->symp->name);
							}
							else cout << "Error in type compatibility !"<< endl;
						}
						| additive_expression MINUS multiplicative_expression
						{
							if (typecheck($1->symp, $3->symp)) {
								$$ = new expr();
								$$->symp = gentemp($1->symp->type->cat);
								emit (SUB, $$->symp->name, $1->symp->name, $3->symp->name);
							}
							else cout << "Error in type compatibility !"<< endl;
						}
						;
		
shift_expression: 	additive_expression
					{
						$$ = $1;
					}
					| shift_expression LEFT_SHIFT additive_expression
					{
						if ($3->symp->type->cat == INT) {
							$$ = new expr();
							$$->symp = gentemp (INT);
							emit (LEFTOP, $$->symp->name, $1->symp->name, $3->symp->name);
						}
						else cout << "Error in type compatibility !"<< endl;
					}
					| shift_expression RIGHT_SHIFT additive_expression
					{
						if ($3->symp->type->cat == INT) {
							$$ = new expr();
							$$->symp = gentemp (INT);
							emit (RIGHTOP, $$->symp->name, $1->symp->name, $3->symp->name);
						}
						else cout << "Error in type compatibility !"<< endl;
					}
					;
		
relational_expression: 	shift_expression
						{
							$$ = $1;
						}
						| relational_expression LESS_THAN shift_expression
						{
							if (typecheck ($1->symp, $3->symp) ) {
								$$ = new expr();
								$$->isbool = true;

								$$->truelist = makelist (nextinstr());
								$$->falselist = makelist (nextinstr()+1);
								emit(LT, "", $1->symp->name, $3->symp->name);
								emit (GOTO, "");
							}
							else cout << "Error in type compatibility !"<< endl;
						}
						| relational_expression GREATER_THAN shift_expression
						{
							if (typecheck ($1->symp, $3->symp) ) {
								// New bool
								$$ = new expr();
								$$->isbool = true;

								$$->truelist = makelist (nextinstr());
								$$->falselist = makelist (nextinstr()+1);
								emit(GT, "", $1->symp->name, $3->symp->name);
								emit (GOTO, "");
							}
							else cout << "Error in type compatibility !"<< endl;
						}
						| relational_expression LESS_THAN_EQUAL_TO shift_expression
						{
							if (typecheck ($1->symp, $3->symp) ) {
								// New bool
								$$ = new expr();
								$$->isbool = true;

								$$->truelist = makelist (nextinstr());
								$$->falselist = makelist (nextinstr()+1);
								emit(LE, "", $1->symp->name, $3->symp->name);
								emit (GOTO, "");
							}
							else cout << "Error in type compatibility !"<< endl;
						}
						| relational_expression GREATER_THAN_EQUAL_TO shift_expression
						{
							if (typecheck ($1->symp, $3->symp) ) {
								// New bool
								$$ = new expr();
								$$->isbool = true;

								$$->truelist = makelist (nextinstr());
								$$->falselist = makelist (nextinstr()+1);
								emit(GE, "", $1->symp->name, $3->symp->name);
								emit (GOTO, "");
							}
							else cout << "Error in type compatibility !"<< endl;
						}
						;
		
equality_expression: 	relational_expression
						{
							$$ = $1;
						}
						| equality_expression EQUAL_TO relational_expression
						{
							if (typecheck ($1->symp, $3->symp) ) {
								convfrombool($1);
								convfrombool($3);
								
								$$ = new expr();
								$$->isbool = true;
								
								$$->truelist = makelist (nextinstr());
								$$->falselist = makelist (nextinstr()+1);
								emit (EQOP, "", $1->symp->name, $3->symp->name);
								emit (GOTO, "");
							}
							else cout << "Error in type compatibility !"<< endl;
						}
						| equality_expression NOT_EQUAL_TO relational_expression
						{
							if (typecheck ($1->symp, $3->symp) ) {
								convfrombool($1);
								convfrombool($3);
								
								$$ = new expr();
								$$->isbool = true;
								
								$$->truelist = makelist (nextinstr());
								$$->falselist = makelist (nextinstr()+1);
								emit (NEOP, "", $1->symp->name, $3->symp->name);
								emit (GOTO, "");
							}
							else cout << "Error in type compatibility !"<< endl;
						}
						;
		
AND_expression: equality_expression
				{
					$$ = $1;
				}
				| AND_expression AND equality_expression
				{
					if (typecheck ($1->symp, $3->symp) ) {
						$$ = new expr();
						$$->isbool = false;

						$$->symp = gentemp (INT);
						emit (BAND, $$->symp->name, $1->symp->name, $3->symp->name);
					}
					else cout << "Error in type compatibility !"<< endl;
				}
				;
		
exclusive_OR_expression
		: AND_expression
			{
				$$ = $1;
			}
		| exclusive_OR_expression XOR_SIGN AND_expression
			{
				if (typecheck ($1->symp, $3->symp) ) {
					convfrombool ($1);
					convfrombool ($3);

					$$ = new expr();
					$$->isbool = false;

					$$->symp = gentemp (INT);
					emit (XOR, $$->symp->name, $1->symp->name, $3->symp->name);
				}
				else cout << "Error in type compatibility !"<< endl;
			}
		;
		
inclusive_OR_expression
		: exclusive_OR_expression
			{
				$$ = $1;
			}
		| inclusive_OR_expression OR exclusive_OR_expression
			{
				if (typecheck ($1->symp, $3->symp) ) {
					convfrombool ($1);
					convfrombool ($3);

					$$ = new expr();
					$$->isbool = false;

					$$->symp = gentemp (INT);
					emit (INOR, $$->symp->name, $1->symp->name, $3->symp->name);
				}
				else cout << "Error in type compatibility !"<< endl;
			}
		;
		
logical_AND_expression
		: inclusive_OR_expression
			{
				$$ = $1;
			}
		| logical_AND_expression N LOGICAL_AND M inclusive_OR_expression
			{
				conv2bool($5);

				backpatch($2->nextlist, nextinstr());
				conv2bool($1);

				$$ = new expr();
				$$->isbool = true;

				backpatch($1->truelist, $4);
				$$->truelist = $5->truelist;
				$$->falselist = merge($1->falselist, $5->falselist);
			}
		;
		
logical_OR_expression
		: logical_AND_expression
			{
				$$ = $1;
			}
		| logical_OR_expression N LOGICAL_OR M logical_AND_expression
			{
				conv2bool($5);

				backpatch($2->nextlist, nextinstr());
				conv2bool($1);

				$$ = new expr();
				$$->isbool = true;

				backpatch ($$->falselist, $4);
				$$->truelist = merge ($1->truelist, $5->truelist);
				$$->falselist = $5->falselist;
			}
		;
	
conditional_expression
		: logical_OR_expression
			{
				$$ = $1;
			}
		| logical_OR_expression N QUESTION_MARK M expression N COLON M conditional_expression
			{
				$$->symp = gentemp();
				$$->symp->update($5->symp->type);
				emit(EQUAL, $$->symp->name, $9->symp->name);
				lint l = makelist(nextinstr());
				emit (GOTO, "");

				backpatch($6->nextlist, nextinstr());
				emit(EQUAL, $$->symp->name, $5->symp->name);
				lint m = makelist(nextinstr());
				l = merge (l, m);
				emit (GOTO, "");

				backpatch($2->nextlist, nextinstr());
				conv2bool ($1);
				backpatch ($1->truelist, $4);
				backpatch ($1->falselist, $8);
				backpatch (l, nextinstr());
			}
		;
		
assignment_expression
		: conditional_expression
			{
				$$ = $1;
			}
		| unary_expression assignment_operator assignment_expression
			{
				switch ($1->cat) {
					case ARR:
						$3->symp = conv($3->symp, $1->type->cat);
						emit(ARRL, $1->symp->name, $1->loc->name, $3->symp->name);	
						break;
					case PTR:
						emit(PTRL, $1->symp->name, $3->symp->name);	
						break;
					default:
						$3->symp = conv($3->symp, $1->symp->type->cat);
						emit(EQUAL, $1->symp->name, $3->symp->name);
						break;
				}
				$$ = $3;
			}
		;
		
assignment_operator
		: ASSIGNED
		| ASTERISK_EQUAL_TO
		| SLASH_EQUAL_TO
		| PERCENT_EQUAL_TO
		| PLUS_EQUAL_TO
		| MINUS_EQUAL_TO
		| LEFT_SHIFT_EQUAL_TO
		| RIGHT_SHIFT_EQUAL_TO
		| AND_EQUAL_TO
		| XOR_EQUAL_TO
		| OR_EQUAL_TO
		;
		
expression
		: assignment_expression
			{
				$$ = $1;
			}
		| expression COMMA assignment_expression 
			{}
		;
		
constant_expression
		: conditional_expression
			{}
		;
		
		


/* *********DECLARATIONS************ */
declaration
		: declaration_specifiers init_declarator_list SEMI_COLON
			{}
		| declaration_specifiers  SEMI_COLON
			{}
		;
		
declaration_specifiers
		: storage_class_specifier declaration_specifiers
		| storage_class_specifier
		| type_specifier declaration_specifiers
		| type_specifier
		| type_qualifier declaration_specifiers
		| type_qualifier
		| function_specifier declaration_specifiers
		| function_specifier
			{}
		;
		
init_declarator_list
		: init_declarator
		| init_declarator_list COMMA init_declarator
			{}
		;
		
init_declarator
		: declarator
			{
				$$ = $1;
			}
		| declarator ASSIGNED initializer
			{
				if ($3->init!="") 
					$1->initialize($3->init);
				emit (EQUAL, $1->name, $3->name);
			}
		;
		
storage_class_specifier
		: EXTERN_K
		| STATIC_K
		| AUTO_K
		| REGISTER_K
			{}
		;
		
type_specifier
		: VOID_K
			{
				TYPE = VOID;
			}
		| CHAR_K
			{
				TYPE = CHAR;
			}
		| SHORT_K
		| INT_K
			{
				TYPE = INT;
			}
		| LONG_K
		| FLOAT_K
		| DOUBLE_K
			{
				TYPE = DOUBLE;
			}
		| SIGNED_K
		| UNSIGNED_K
		| _BOOL_K
		| _COMPLEX_K
		| _IMAGINARY_K
		| enum_specifier
			{}
		;
		
specifier_qualifier_list
		: type_specifier specifier_qualifier_list
		| type_specifier
		| type_qualifier specifier_qualifier_list
		| type_qualifier
			{}
		;
		
enum_specifier
		: ENUM_K ID LEFT_CURLY_BRACKET enumerator_list RIGHT_CURLY_BRACKET
		| ENUM_K LEFT_CURLY_BRACKET enumerator_list RIGHT_CURLY_BRACKET
		| ENUM_K ID LEFT_CURLY_BRACKET enumerator_list COMMA RIGHT_CURLY_BRACKET
		| ENUM_K LEFT_CURLY_BRACKET enumerator_list COMMA RIGHT_CURLY_BRACKET
		| ENUM_K ID
			{}
		;
		
enumerator_list
		: enumerator
		| enumerator_list COMMA enumerator
			{}
		;
		
enumerator
		: ENUM_CONST
		| ENUM_CONST ASSIGNED constant_expression
			{}
		;
		
type_qualifier
		: CONST_K
		| RESTRICT_K
		| VOLATILE_K
			{}
		;
		
function_specifier
		: INLINE_K
			{}
		;
		
declarator
		: pointer direct_declarator
			{
				symType * t = $1;
				while (t->ptr)
					t = t->ptr;
				t->ptr = $2->type;
				$$ = $2->update($1);
			}
		| direct_declarator
		;
		
direct_declarator
		: ID
			{
				$$ = $1->update(TYPE);
				currsym = $$;
			}
		| LEFT_ROUND_BRACKET declarator RIGHT_ROUND_BRACKET
			{
				$$ = $2;
			}
		| direct_declarator LEFT_SQUARE_BRACKET type_qualifier_list assignment_expression RIGHT_SQUARE_BRACKET
		| direct_declarator LEFT_SQUARE_BRACKET type_qualifier_list RIGHT_SQUARE_BRACKET
		| direct_declarator LEFT_SQUARE_BRACKET assignment_expression RIGHT_SQUARE_BRACKET
			{
				symType* t = $1 -> type;
				symType* prev = NULL;
				while (t->cat == ARR) {
					prev = t;
					t = t->ptr;
				}
				if (prev==NULL) {
					int x = atoi($3->symp->init.c_str());
					symType* s = new symType(ARR, $1->type, x);
					int y = sizeOfType(s);
					$$ = $1->update(s);
				}
				else {
					prev->ptr =  new symType(ARR, t, atoi($3->symp->init.c_str()));
					$$ = $1->update ($1->type);
				}
			}
		| direct_declarator LEFT_SQUARE_BRACKET RIGHT_SQUARE_BRACKET
			{
				symType * t = $1 -> type;
				symType * prev = NULL;
				while (t->cat == ARR) {
					prev = t;
					t = t->ptr;
				}
				if (prev==NULL) {
					symType* s = new symType(ARR, $1->type, 0);
					int y = sizeOfType(s);
					$$ = $1->update(s);
				}
				else {
					prev->ptr =  new symType(ARR, t, 0);
					$$ = $1->update ($1->type);
				}
			}
		| direct_declarator LEFT_SQUARE_BRACKET STATIC_K type_qualifier_list assignment_expression RIGHT_SQUARE_BRACKET
		| direct_declarator LEFT_SQUARE_BRACKET STATIC_K assignment_expression RIGHT_SQUARE_BRACKET
		| direct_declarator LEFT_SQUARE_BRACKET type_qualifier_list ASTERISK RIGHT_SQUARE_BRACKET
		| direct_declarator LEFT_SQUARE_BRACKET ASTERISK RIGHT_SQUARE_BRACKET
		| direct_declarator LEFT_ROUND_BRACKET CST parameter_type_list RIGHT_ROUND_BRACKET
			{
				table->tname = $1->name;

				if ($1->type->cat !=VOID) {
					sym *s = table->lookup("retVal");
					s->update($1->type);		
				}

				$1 = $1->linkst(table);

				table->parent = globalTable;
				changeTable (globalTable);
			
				currsym = $$;
			}
		| direct_declarator LEFT_ROUND_BRACKET identifier_list RIGHT_ROUND_BRACKET
		| direct_declarator LEFT_ROUND_BRACKET CST RIGHT_ROUND_BRACKET
			{
				table->tname = $1->name;

				if ($1->type->cat !=VOID) {
					sym *s = table->lookup("retVal");
					s->update($1->type);
				}
				
				$1 = $1->linkst(table);
			
				table->parent = globalTable;
				changeTable (globalTable);
			
				currsym = $$;
			}
		;
		
pointer
		: ASTERISK type_qualifier_list
			{}
		| ASTERISK
			{
				$$ = new symType(PTR);
			}
		| ASTERISK type_qualifier_list pointer
			{}
		| ASTERISK pointer
			{
				$$ = new symType(PTR, $2);
			}
		;
		
type_qualifier_list
		: type_qualifier
		| type_qualifier_list type_qualifier
		;
		
parameter_type_list
		: parameter_list
		| parameter_list COMMA ELLIPSIS
		{}
		;
		
parameter_list
		: parameter_declaration
		| parameter_list COMMA parameter_declaration
			{			}
		;
		
parameter_declaration
		: declaration_specifiers declarator
			{
				$2->category = "param";
			}
		| declaration_specifiers
			{}
		;
		
identifier_list
		: ID
		| identifier_list COMMA ID
			{}
		;
		
type_name
		: specifier_qualifier_list
			{}
		;
		
initializer
		: assignment_expression
			{
				$$ = $1->symp;
			}
		| LEFT_CURLY_BRACKET initializer_list RIGHT_CURLY_BRACKET
			{}
		| LEFT_CURLY_BRACKET initializer_list COMMA RIGHT_CURLY_BRACKET
			{}
		;
		
initializer_list
		: designation initializer
		| initializer
		| initializer_list COMMA designation initializer
		| initializer_list COMMA initializer
		;
		
designation
		: designator_list ASSIGNED
			{}
		;
		
designator_list
		: designator
		| designator_list designator
			{}
		;
		
designator
		: LEFT_SQUARE_BRACKET constant_expression RIGHT_SQUARE_BRACKET
		| DOT ID
			{}
		;
		
		


/* *********STATEMENTS************ */
statement
		: labeled_statement
		| compound_statement
			{
				$$ = $1;
			}
		| expression_statement
			{
				$$ = new statement();
				$$->nextlist = $1->nextlist;
			}
		| selection_statement
			{
				$$ = $1;
			}
		| iteration_statement
			{
				$$ = $1;
			}
		| jump_statement
			{
				$$ = $1;
			}
		| SINGLE_LINE_COMMENT
			{;}
		| MULTI_LINE_COMMENT
			{;}
		;
		
labeled_statement
		: ID COLON statement
			{
				$$ = new statement();
			}
		| CASE_K constant_expression COLON statement
			{
				$$ = new statement();
			}
		| DEFAULT_K COLON statement
			{
				$$ = new statement();
			}
		;
		
compound_statement
		: LEFT_CURLY_BRACKET block_item_list RIGHT_CURLY_BRACKET
			{	$$ = $2; }
		| LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET
			{	$$ = new statement();}
		;
	
block_item_list
		: block_item
			{$$ = $1;	}
		| block_item_list M block_item
			{
				$$ = $3;
		backpatch ($1->nextlist, $2);
			}
		;
		
block_item
		: declaration
			{$$ = new statement();}
		| statement
			{$$ = $1;}
		;
		
expression_statement
		: expression SEMI_COLON
			{$$ = $1;}
		| SEMI_COLON
			{$$ = new expr();}
		;
	
selection_statement
		: IF_K LEFT_ROUND_BRACKET expression N RIGHT_ROUND_BRACKET M statement N
			{
				backpatch ($4->nextlist, nextinstr());
				conv2bool($3);
				$$ = new statement();
				backpatch ($3->truelist, $6);
				lint temp = merge ($3->falselist, $7->nextlist);
				$$->nextlist = merge ($8->nextlist, temp);
			}
		| IF_K LEFT_ROUND_BRACKET expression N RIGHT_ROUND_BRACKET M statement N ELSE_K M statement
			{
				backpatch ($4->nextlist, nextinstr());
				conv2bool($3);
				backpatch ($3->truelist, $6);
				backpatch ($3->falselist, $10);
				lint temp = merge ($7->nextlist, $8->nextlist);
				$$->nextlist = merge (temp, $11->nextlist);
			}
		| SWITCH_K LEFT_ROUND_BRACKET expression RIGHT_ROUND_BRACKET statement
			{}
		;
		
iteration_statement
		: WHILE_K M LEFT_ROUND_BRACKET expression RIGHT_ROUND_BRACKET M statement
			{
				$$ = new statement();
				conv2bool($4);

				backpatch($7->nextlist, $2);
				backpatch($4->truelist, $6);
				$$->nextlist = $4->falselist;

				emit (GOTO, tostr($2));
			}
		| DO_K M statement M WHILE_K LEFT_ROUND_BRACKET expression RIGHT_ROUND_BRACKET SEMI_COLON
			{
				$$ = new statement();
				conv2bool($7);

				backpatch ($7->truelist, $2);
				backpatch ($3->nextlist, $4);

				$$->nextlist = $7->falselist;
			}
		| FOR_K LEFT_ROUND_BRACKET expression_statement M expression_statement M expression N RIGHT_ROUND_BRACKET M statement
			{
				$$ = new statement();
				conv2bool($5);
				backpatch ($5->truelist, $10);
				backpatch ($8->nextlist, $4);
				backpatch ($11->nextlist, $6);
				
				emit (GOTO, tostr($6));
				$$->nextlist = $5->falselist;
			}
		| FOR_K LEFT_ROUND_BRACKET expression_statement M expression_statement RIGHT_ROUND_BRACKET M statement
			{
				$$ = new statement();
				conv2bool($5);
				backpatch ($5->truelist, $7);
				backpatch ($8->nextlist, $4);
				
				emit (GOTO, tostr($4));
				$$->nextlist = $5->falselist;
			}
		;
		
jump_statement
		: GOTO_K ID SEMI_COLON 
			{$$ = new statement();}
		| CONTINUE_K SEMI_COLON	
			{$$ = new statement();}
		| BREAK_K SEMI_COLON
			{$$ = new statement();}
		| RETURN_K expression SEMI_COLON
			{$$ = new statement();}
		| RETURN_K SEMI_COLON
			{
				$$ = new statement();
				emit(RETURN,"");
			}
		;
		


		
/* *********EXTERNAL DEFINITIONS************ */
translation_unit
		: external_declaration
		| translation_unit external_declaration
		| SINGLE_LINE_COMMENT
			{;}
		| MULTI_LINE_COMMENT
			{;}
		;
		
external_declaration
		: function_definition
		| declaration
		;
		
function_definition
		: declaration_specifiers declarator declaration_list  CST compound_statement
		| declaration_specifiers declarator CST compound_statement
			{
				table->parent = globalTable;
				changeTable (globalTable);
			}
		;
	
declaration_list
		: declaration
			{}
		| declaration_list declaration
			{}
		;

%%

void yyerror(const char *s)
{
    printf("\n%s\n\t-due to (or near) :\n%s [line number:%d]\n",s, yytext, ln);
}
