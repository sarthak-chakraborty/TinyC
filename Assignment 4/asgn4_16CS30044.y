%{
	#include<stdio.h>
	extern int yylex();
	void yyerror(char *s);
%}

/* Bison Declaration */
%token AUTO
%token BREAK
%token CASE
%token CHAR
%token CONST
%token CONTINUE
%token DEFAULT 
%token DO 		
%token DOUBLE 	
%token ELSE 	
%token ENUM 	
%token EXTERN 	
%token FLOAT 	
%token FOR 	
%token GOTO 	
%token IF 		
%token INLINE	
%token INT 	
%token LONG 	
%token REGISTER
%token RESTRICT
%token RETURN 	
%token SHORT 	
%token SIGNED 	
%token SIZEOF 	
%token STATIC 	
%token STRUCT 	
%token SWITCH 	
%token TYPEDEF 
%token UNION 	
%token UNSIGNED
%token VOID 	
%token VOLATILE
%token WHILE 	
%token _BOOL 	
%token _COMPLEX
%token _IMAGINARY 
%token ID			
%token FLOAT_CONST	
%token INT_CONST	
%token ENUM_CONST 	
%token CHAR_CONST	
%token STRING_CONST
%token LSQBRACKET 	
%token RSQBRACKET 	
%token LBRACE		
%token RBRACE		
%token LPARAN		
%token RPARAN 		
%token DOT 		
%token ARROW		
%token INCREMENT 	
%token DECREMENT 	
%token BIT_AND 	
%token BIT_OR 		
%token BIT_XOR		
%token PLUS		
%token SUB		 	
%token MULT		
%token DIV 		
%token MOD 		
%token BIT_NOT		
%token LOG_NOT 	
%token LOG_AND		
%token LOG_OR 		
%token RIGHTSHIFT	
%token LEFTSHIFT 	
%token LESS		
%token GREATER 	
%token LESSEQ		
%token GREATEREQ	
%token EQUALS		
%token NOTEQ		
%token QUES 		
%token COLON		
%token SEMICOLON	
%token ELLIPSIS	
%token ASSIGN		
%token PLUS_ASSGN
%token SUB_ASSGN	
%token MULT_ASSGN	
%token DIV_ASSGN	
%token LEFT_SHIFT_ASSGN
%token RIGHT_SHIFT_ASSGN
%token AND_ASSGN		
%token OR_ASSGN		
%token XOR_ASSGN		
%token COMMA			
%token HASH			
%token SINGLE_COMMENT	
%token MULTI_COMMENT	


%start translational_unit


%%
/* *********EXPRESIION************ */
primary_expression: ID {printf("\nprimary-expression->Identifier\n");}
					|FLOAT_CONST {printf("\nprimary_expression->Float constant\n");}
					|INT_CONST {printf("\nprimary_expression->Integer constant\n");}
					|ENUM_CONST {printf("\nprimary_expression->Enumeration constant\n");}
					|CHAR_CONST {printf("\nprimary_expression->Character constant\n");}
					|STRING_CONST {printf("\nprimary_expression->String Literal\n");}
					|LPARAN expression RPARAN {printf("\nprimary_expression->(expression)\n");}
					;

postfix_expression: primary_expression {printf("\npostfix-expression->primary-expression\n");}
					|postfix_expression LSQBRACKET expression RSQBRACKET {printf("\npostfix-expression->postfix-expression[expression]\n");}
					|postfix_expression LPARAN argument_expression_list_opt RPARAN {printf("\npostfix-expression->postfix-expression(argument-expression-list-opt\n");}
					|postfix_expression DOT identifier {printf("\npostfix-expression->postfix-expression.identifier\n");}
					|postfix_expression ARROW identifier {printf("\npostfix-expression->postfix-expression->identifier\n");}
					|postfix_expression INCREMENT {printf("\npostfix-expression->postfix-expression++\n");}
					|postfix_expression DECREMENT {printf("\npostfix-expression->postfix-expression--\n");}
					|LPARAN type_name RPARAN LBRACE initializer_list RBRACE {printf("\n(type-name){initializer-list}\n");}
					|LPARAN type_name RPARAN LBRACE initializer_list COMMA RBRACE {printf("\n(type-name){initializer-list,}\n");}
					;

identifier: ID
			;

argument_expression_list_opt: /* epsilon */
							  |argument_expression_list
							  ;

argument_expression_list: assignment_expression {printf("\nargument-expression-list->assignment-expression\n");}
						  |argument_expression_list COMMA assignment_expression {printf("\nargument-expression-list->argument-expression-list,assignment-expression\n");}
						  ;

unary_expression: postfix_expression {printf("\nunary-expression->postfix-expression\n");}
				  |INCREMENT unary_expression {printf("\nunary-expression->++unary-expression\n");}
				  |DECREMENT unary_expression {printf("\nunary-expression->--unary-expression\n");}
				  |unary_operator cast_expression {printf("\nunary-expression-->unary-operator cast-expression\n");}
				  |SIZEOF unary_expression {printf("\nunary-expression->sizeof unary-expression\n");}
				  |SIZEOF LPARAN type_name RPARAN {printf("\nunary-expression->sizeof (type-name)\n");}
				  ;

unary_operator: BIT_AND {printf("\nunary-operator->&\n");}
				|MULT {printf("\nunary-operator->*\n");}
				|PLUS {printf("\nunary-operator->+\n");}
				|SUB {printf("\nunary-operator->-\n");}
				|BIT_NOT {printf("\nunary-operator->~\n");}
				|LOG_NOT {printf("\nunary-operator->!\n");}
				;

cast_expression: unary_expression {printf("\ncast-expression->unary-expression\n");}
				 |LPARAN type_name RPARAN cast_expression {printf("\ncast-expression->(type-name)cast-expression\n");}
				 ;

multiplicative_expression: cast_expression {printf("\nmultiplicative-expression->cast-expression\n");}
						   |multiplicative_expression MULT cast_expression {printf("\nmultiplicative-expression->multiplicative-expression*cast-expression\n");}
						   |multiplicative_expression DIV cast_expression {printf("\nmultiplicative-expression->multiplicative-expression/cast-expression\n");}
						   |multiplicative_expression MOD cast_expression {printf("\nmultiplicative-expression->multiplicative-expression%cast-expression\n");}
						   ;

additive_expression: multiplicative_expression {printf("\nadditive-expression->multiplicative-expression\n");}
					 |additive_expression PLUS multiplicative_expression {printf("\nadditive-expression->additive-expression+multiplicative-expression\n");}
					 |additive_expression SUB multiplicative_expression {printf("\nadditive-expression->additive-expression-multiplicative-expression\n");}
					 ;

shift_expression: additive_expression {printf("\nshift-expression->additive-expression\n");}
				  |shift_expression LEFTSHIFT additive_expression {printf("\nshift-expression->shift-expression<<additive-expression\n");}
				  |shift_expression RIGHTSHIFT additive_expression {printf("\nshift-expression->shift-expression>>additive-expression\n");}
				  ;

relational_expression: shift_expression {printf("\nrelational-expression->shift-expression\n");}
					   |relational_expression LESS shift_expression {printf("\nrelational-expression->relational-expression<shift-expression\n");}
					   |relational_expression GREATER shift_expression  {printf("\nrelational-expression->relational-expression>shift-expression\n");}
					   |relational_expression LESSEQ shift_expression {printf("\nrelational-expression->relational-expression<=shift-expression\n");}
					   |relational_expression GREATEREQ shift_expression {printf("\nrelational-expression->relational-expression>=shift-expression\n");}
					   ;

equality_expression: relational_expression {printf("\nequality-expression->relational-expression\n");}
					 |equality_expression EQUALS relational_expression {printf("\nequality-expression->equality-expression==relational-expression\n");}
					 |equality_expression NOTEQ  relational_expression {printf("\nequality-expression->equality-expression!=relational-expression\n");}
					 ;

and_expression: equality_expression {printf("\nAND-expression->equality-expression\n");}
				|and_expression BIT_AND equality_expression {printf("\nAND-expression->AND-expression&equality-expression\n");}
				;

exclusive_or_expression: and_expression {printf("\neclusive-OR-expression->AND-expression\n");}
						 |exclusive_or_expression BIT_XOR and_expression {printf("\neclusive-OR-expression->eclusive-OR-expression^AND-expression\n");}
						 ;

inclusive_or_expression: exclusive_or_expression {printf("\ninclusive-OR-expression->exclusive-OR-expression\n");}
						 |inclusive_or_expression BIT_OR exclusive_or_expression {printf("\ninclusive-OR-expression->inclusive-OR-expression|exclusive-OR-expression\n");}
						 ;

logical_and_expression: inclusive_or_expression {printf("\nlogical-AND-expression->inclusive-OR-expression\n");}
						|logical_and_expression LOG_AND inclusive_or_expression {printf("\nlogical-AND-expression->logical-AND-expression&&inclusive-OR-expression\n");}
						;
 
logical_or_expression: logical_and_expression {printf("\nlogical-OR-expression->logical-AND-expression\n");}
					   |logical_or_expression LOG_OR logical_and_expression {printf("\nlogical-OR-expression->logical-OR-expression||logical-AND-expression\n");}
					   ;

conditional_expression: logical_or_expression {printf("\nconditional-expression->logical-OR-expression\n");}
						|logical_or_expression QUES expression COLON conditional_expression {printf("\nconditional-expression->logical-OR-expression?expression:conditional-expression\n");}
						;

assignment_expression: conditional_expression {printf("\nassignment-expression->conditional-expression\n");}
					   |unary_expression assignment_operator assignment_expression {printf("\nassignment-expression->unary-expression assignment-operator assignment-expression\n");}
					   ;

assignment_operator: ASSIGN {printf("\nassignment-operator->=\n");}
					 |MULT_ASSGN {printf("\nassignment-operator->*=\n");}
					 |DIV_ASSGN {printf("\nassignment-operator->/=\n");}
					 |'%=' {printf("\nassignment-operator->%=\n");}
					 |PLUS_ASSGN {printf("\nassignment-operator->+=\n");}
					 |SUB_ASSGN {printf("\nassignment-operator->-=\n");}
					 |LEFT_SHIFT_ASSGN {printf("\nassignment-operator-><<=\n");}
					 |RIGHT_SHIFT_ASSGN {printf("\nassignment-operator->>>=\n");}
					 |AND_ASSGN {printf("\nassignment-operator->&=\n");}
					 |XOR_ASSGN {printf("\nassignment-operator->^=\n");}
					 |OR_ASSGN {printf("\nassignment-operator->|=\n");}
					 ;

expression: assignment_expression {printf("\nexpression->assignment-expression\n");}
			|expression COMMA assignment_expression {printf("\nexpression->expression,assignment-expression\n");}
			;

constant_expression: conditional_expression {printf("\nconstant-expression->conditional-expression\n");}
					 ;



/* *********DECLARATIONS************ */
declaration: declaration_specifiers init_declarator_list_opt SEMICOLON {printf("\ndeclaration->declaration-specifiers init-declaration-list-opt\n");}
			 ;

declaration_specifiers_opt: /* epsilon */
							|declaration_specifiers
							;

declaration_specifiers: storage_class_specifier declaration_specifiers_opt {printf("\ndeclaration-specifiers->storage-class-specifiers declaration-specifiers-opt\n");}
						|type_specifier declaration_specifiers_opt {printf("\ndeclaration-specifiers->type-specifier declaration-specifiers-opt\n");}
						|type_qualifier declaration_specifiers_opt {printf("\ndeclaration-specifiers->type-qualifier declaration-specifiers-opt\n");}
						|function_specifier declaration_specifiers_opt {printf("\ndeclaration-specifiers->function-specifier declaration-specifiers-opt\n");}
						;

init_declarator_list_opt: /* epsilon */
						  |init_declarator_list
						  ;

init_declarator_list: init_declarator {printf("\ninit-declarator-list->init-declarator\n");}
					  |init_declarator_list COMMA init_declarator {printf("\ninit-declarator-list->init-declaration-list,init-declarator\n");}
					  ;

init_declarator: declarator {printf("\ninit-declarator->declarator\n");}
				 |declarator ASSIGN initializer {printf("\ninit-declarator->declarator=initializer\n");}
				 ;

storage_class_specifier: EXTERN {printf("\nstorage-class-specifier->extern\n");}
						 |STATIC {printf("\nstorage-class-specifier->static\n");}
						 |AUTO {printf("\nstorage-class-specifier->auto\n");}
						 |REGISTER {printf("\nstorage-class-specifier->register\n");}
						 ;

type_specifier: VOID {printf("\ntype-specifier->void\n");}
				|CHAR {printf("\ntype-specifier->char\n");}
				|SHORT {printf("\ntype-specifier->short\n");}
				|INT {printf("\ntype-specifier->int\n");}
				|LONG {printf("\ntype-specifier->long\n");}
				|FLOAT {printf("\ntype-specifier->float\n");}
				|DOUBLE {printf("\ntype-specifier->double\n");}
				|SIGNED {printf("\ntype-specifier->signed\n");}
				|UNSIGNED {printf("\ntype-specifier->unsigned\n");}
				|_BOOL {printf("\ntype-specifier->_Bool\n");}
				|_COMPLEX {printf("\ntype-specifier->_Complex\n");}
				|_IMAGINARY {printf("\ntype-specifier->_Imaginary\n");}
				|enum_specifier {printf("\ntype-specifier->enum-specifier\n");}
				;

specifier_qualifier_list: type_specifier specifier_qualifier_list_opt {printf("\n\nspecifier-qualifier-list->type-specifier specifier_qualifier_list_opt");}
						  |type_qualifier specifier_qualifier_list_opt {printf("\n\nspecifier-qualifier-list->type-qualifier specifier_qualifier_list_opt");}
						  ;

specifier_qualifier_list_opt: /* epsilon */
							  |specifier_qualifier_list
							  ;

enum_specifier: ENUM identifier_opt LBRACE enumerator_list RBRACE {printf("\nenum-specifier->enum identifier-opt{enumerator-list}\n");}
				|ENUM identifier_opt LBRACE enumerator_list COMMA RBRACE {printf("\nenum-specifier->enum identifier-opt{enumerator-list,}\n");}
				|ENUM identifier {printf("\nenum-specifier->enum identifier\n");}
				;

identifier_opt: /* epsilon */
				|identifier
				;

enumerator_list: enumerator {printf("\nenumerator-list->enumerator\n");}
				|enumerator_list COMMA enumerator {printf("\nenumerator-list->enumerator-list,enumerator\n");}
				;

enumerator: ENUM_CONST {printf("\nenumerator->enumerator-constant\n");}
			|ENUM_CONST ASSIGN constant_expression {printf("\nenumerator->enumerator-constant=constant-expression\n");}
			;

type_qualifier: CONST {printf("\ntype-qualifier->const\n");}
				|RESTRICT {printf("\ntype-qualifier->restrict\n");}
				|VOLATILE {printf("\ntype-qualifier->volatile\n");}
				;

function_specifier: INLINE {printf("\nfunction-specifier->inline\n");}
					;

declarator: pointer_opt direct_declarator {printf("\ndeclarator->pointer-opt direct-declarator\n");}
			;

pointer_opt: /* epsilon */
			 |pointer
			 ;

direct_declarator: identifier {printf("\ndirect-declarator->identifier\n");}
				   |LPARAN declarator RPARAN {printf("\ndirect-declarator->(declarator)\n");}
				   |direct_declarator LSQBRACKET type_qualifier_list_opt assignment_expression_opt RSQBRACKET {printf("\ndirect-declarator->direct-declarator[type_qualifier_list_opt assignment-expression-opt\n");}
				   |direct_declarator LSQBRACKET STATIC type_qualifier_list_opt assignment_expression RSQBRACKET {printf("\ndirect-declarator->direct-declarator[static type_qualifier_list_opt assignment-expression\n");}
				   |direct_declarator LSQBRACKET type_qualifier_list STATIC assignment_expression RSQBRACKET {printf("\ndirect-declarator->direct-declarator[type_qualifier_list static assignment-expression\n");}
				   |direct_declarator LSQBRACKET type_qualifier_list_opt MULT RSQBRACKET{printf("\ndirect-declarator->direct-declarator[type_qualifier_list_opt*\n");}
				   |direct_declarator LPARAN parameter_type_list RPARAN {printf("\ndirect-declarator->direct-declarator[type_qualifier_list_opt (parameter-type-list)\n");}
				   |direct_declarator LPARAN identifier_list_opt RPARAN {printf("\ndirect-declarator->direct-declarator[type_qualifier_list_opt (identifier-list-opt)\n");}
				   ;

type_qualifier_list_opt: /* epsilon */
						 |type_qualifier_list
						 ;

assignment_expression_opt: /* epsilon */
						   |assignment_expression
						   ;

identifier_list_opt: /* epsilon */
				     |identifier_list
				     ;

pointer: MULT type_qualifier_list_opt {printf("\npointer->*type-qualifier-list-opt\n");}
		 |MULT type_qualifier_list_opt pointer {printf("\npointer->*type-qualifier-list-opt pointer\n");}
		 ;

type_qualifier_list: type_qualifier {printf("\ntype-qualifier-list->type-qualifier\n");}
					 |type_qualifier_list type_qualifier {printf("\ntype-qualifier-list->type-qualifier-list type-qualifier\n");}
					 ;

parameter_type_list: parameter_list {printf("\nparameter-type-list->parameter-list\n");}
					 |parameter_list COMMA ELLIPSIS {printf("\nparameter-type-list->parameter-list, ...\n");}
					 ;

parameter_list: parameter_declaration {printf("\nparameter-list->parameter-declaration\n");}
				|parameter_list COMMA parameter_declaration {printf("\nparameter-list->parameter-list,parameter-declaration\n");}
				;

parameter_declaration: declaration_specifiers declarator {printf("\nparameter-declaration->declaration-specifiers declarator\n");}
					   |declaration_specifiers {printf("\nparameter-declaration->declaration-specifiers\n");}
					   ;

identifier_list: identifier {printf("\nidentifier-list->identifier\n");}
				 |identifier_list COMMA identifier {printf("\nidentifier-list->identifier-list,identifier\n");}
				 ;

type_name: specifier_qualifier_list {printf("\ntype-name->specifier-qualifier-list\n");}
		   ;

initializer: assignment_expression {printf("\ninitializer->assignment-expression\n");}
			 |LBRACE initializer_list RBRACE {printf("\ninitializer->{initializer-list}\n");}
			 |LBRACE initializer_list COMMA RBRACE {printf("\ninitializer->{initializer-list,}\n");}
			 ;

initializer_list: designation_opt initializer {printf("\ninitializer-list->designation-opt initializer\n");}
				  |initializer_list COMMA designation_opt initializer {printf("\ninitializer-list->initializer-list, designation-opt initializer\n");}
				  ;

designation_opt: /* epsilon */
				 |designation
				 ;

designation: designator_list ASSIGN {printf("\ndesignation->designator-list\n");}
			 ;

designator_list: designator {printf("\ndesignator-list->designator\n");}
				 |designator_list designator {printf("\ndesignator-list->designator-list designator\n");}
				 ;

designator: LSQBRACKET constant_expression RSQBRACKET {printf("\ndesignator->[constant-expression]\n");}
			|DOT identifier {printf("\ndesignator->.identifier\n");}
			;




/* *********STATEMENTS************ */
statement: labeled_statement {printf("\nstatement->labeled-statement\n");}
		   |compound_statement {printf("\nstatement->compound-statement\n");}
		   |expression_statement {printf("\nstatement->expression-statement\n");}
		   |selection_statement {printf("\nstatement->selection-statement\n");}
		   |iteration_statement {printf("\nstatement->iteration-statement\n");}
		   |jump_statement {printf("\nstatement->jump-statement\n");}
		   ;

labeled_statement: identifier COLON statement {printf("\nlabeled-statement->identifier:statement\n");}
				   |CASE constant_expression COLON statement {printf("\nlabeled-statement->case constant-expression:statement\n");}
				   |DEFAULT COLON statement {printf("\nlabeled-statement->default:statement\n");}
				   ;

compound_statement: LBRACE block_item_list_opt RBRACE {printf("\ncompoumd-statement->{block-item-list-opt}\n");}
					;

block_item_list_opt: /* epsilon */
					 |block_item_list
					 ;

block_item_list: block_item {printf("\nblock-item-list->block-item\n");}
				 |block_item_list block_item {printf("\nblock-item-list->block-item-list block-item\n");}
				 ;

block_item: declaration {printf("\nblock-item->declaration\n");}
			|statement {printf("\nblock-item->statement\n");}
			;

expression_statement: expression_opt SEMICOLON {printf("\nexpression-statement->expression-opt\n");}
					  ;

expression_opt: /* epsilon */
				|expression
				;

selection_statement: IF LPARAN expression RPARAN statement {printf("\nselection-statement->if(expression) statement\n");}
					 |IF LPARAN expression RPARAN statement ELSE statement {printf("\nselection-statement->if(expression) statement else statement\n");}
					 |SWITCH LPARAN expression RPARAN statement {printf("\nselection-statement->switch(expression) statement\n");}
					 ;

iteration_statement: WHILE LPARAN expression RPARAN statement {printf("\niteration-statement->while(expression) statement\n");}
					 |DO statement WHILE LPARAN expression RPARAN SEMICOLON {printf("\niteration-statement->do statement while(expression);\n");}
					 |FOR LPARAN expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RPARAN statement {printf("\niteration-statement->for(expression-opt;expression-opt;expression-opt) statement\n");}
					 |FOR LPARAN declaration expression_opt SEMICOLON expression_opt RPARAN statement {printf("\niteration-statement->for(declaration expression-opt;expression-opt) statement\n");}
					 ;

jump_statement: GOTO identifier SEMICOLON {printf("\njump-statement->goto identifier\n");}
				|CONTINUE SEMICOLON {printf("\njump-statement->continue;\n");}
				|BREAK SEMICOLON {printf("\njump-statement->break;\n");}
				|RETURN expression_opt SEMICOLON {printf("\njump-statement->return expression-opt;\n");}
				;




/* *********EXTERNAL DEFINITIONS************ */
translational_unit: external_declaration {printf("\ntranslational-unit->external-declaration\n");}
					|translational_unit external_declaration {printf("\ntranslational-unit->translational-unit external-declaration\n");}
					;

external_declaration: function_definition {printf("\nexternal-declaration->function-definition\n");}
					  |declaration {printf("\nexternal-declaration->declaration\n");}
					  ;

function_definition: declaration_specifiers declarator declaration_list_opt compound_statement {printf("\nfunction-definition->declaration-specifiers declarartor declaration-list-opt compound-statement\n");}
					 ;

declaration_list_opt: /* epsilon */
					  |declaration_list
					  ;

declaration_list: declaration {printf("\ndeclaration-list->declaration\n");}
				  |declaration_list declaration {printf("\ndeclaration-list->declaration-list declaration\n");}
				  ;



%%


yyerror (char *s) 
{
  printf ("%s\n", s);
}
