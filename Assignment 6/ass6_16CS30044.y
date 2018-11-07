
%{
    #include <string>
    #include <bits/stdc++.h>
    using namespace std;
    void yyerror(string s);
    extern int yydebug;
    extern int yylex();
    #include "ass6_16CS30044_translator.h"
    quadarray qar;
    symtab symtabvar;
    symtab *ST = &(symtabvar);
    vector<string> stringnames;
    int strct=0;
%}


%union {
    opcode op;                     // to store opcode of non terminal
    int ival;                       // to store integer value
    string *str;                    // pointer to a string
    double dval;                    // to store double value
    void* ptr;                      // to store pointer value
    symtype *typeinfo;              // keeps info of all the types
    vector<param*> *prm_list;       // holds a list of parameters
    symdata *symdat;                // a pointer to an entry in the symbol table
    basic_type btype;              // a basic type enum
    decc *dec_info;                 // holds info on declartors
    char cval;                      // to store the char vaue
    vector<decc*> *ivec;            // holds a list of declators
    param *prm;                     // holds parameters like name and type of a parameter
    expression_type *exp_info;                 // holds info like loc and type for an expression and truelist false list and next list for statements
}


%token SIZEOF_KEYWORD
%token POINTER_OP 
%token INCREMENT_OP 
%token DECREMENT_OP 
%token LEFT_SHIFT_OP 
%token RIGHT_SHIFT_OP 
%token LESS_EQUAL_OP 
%token GREATER_EQUAL_OP 
%token EQUAL_OP 
%token NOT_EQUAL_OP
%token LOGICAL_AND_OP 
%token LOGICAL_OR_OP 
%token MUL_ASSIGN 
%token DIV_ASSIGN 
%token MOD_ASSIGN 
%token ADD_ASSIGN
%token SUB_ASSIGN 
%token LEFT_SHIFT_ASSIGN 
%token RIGHT_SHIFT_ASSIGN 
%token AND_ASSIGN
%token XOR_ASSIGN 
%token OR_ASSIGN 
%token TYPE_NAME
%token TYPEDEF_KEYWORD 
%token EXTERN_KEYWORD 
%token STATIC_KEYWORD 
%token AUTO_KEYWORD 
%token REGISTER_KEYWORD
%token CHAR_KEYWORD  
%token SHORT_KEYWORD  
%token INT_KEYWORD  
%token LONG_KEYWORD  
%token SIGNED_KEYWORD 
%token UNSIGNED_KEYWORD  
%token FLOAT_KEYWORD  
%token DOUBLE_KEYWORD  
%token CONST_KEYWORD 
%token RESTRICT_KEYWORD 
%token VOLATILE_KEYWORD 
%token VOID_KEYWORD
%token BOOL_KEYWORD 
%token COMPLEX_KEYWORD 
%token IMAGINARY_KEYWORD
%token INLINE_KEYWORD
%token STRUCT_KEYWORD 
%token UNION_KEYWORD
%token ENUM_KEYWORD 
%token ELLIPSIS
%token CASE_KEYWORD 
%token DEFAULT_KEYWORD 
%token IF_KEYWORD 
%token ELSE_KEYWORD 
%token SWITCH_KEYWORD 
%token WHILE_KEYWORD 
%token DO_KEYWORD 
%token FOR_KEYWORD 
%token GOTO_KEYWORD 
%token CONTINUE_KEYWORD
%token BREAK_KEYWORD 
%token RETURN_KEYWORD
%token<str> STRING_LITERAL IDENTIFIER
%token<ival> INTEGER_CONSTANT
%token<dval> FLOAT_CONSTANT
%token<cval> CHAR_CONSTANT
%type<exp_info> primary_expression 
%type<exp_info> expression expression_opt
%type<exp_info> postfix_expression assignment_expression unary_expression
%type<exp_info> additive_expression multiplicative_expression shift_expression cast_expression
%type<exp_info> relational_expression equality_expression
%type<exp_info> M N conditional_expression logical_or_expression logical_and_expression and_expression exclusive_or_expression inclusive_or_expression
%type<exp_info> selection_statement statement iteration_statement compound_statement expression_statement jump_statement
%type<op> unary_operator
%type<exp_info> block_item block_item_list
%type<btype> type_specifier declaration_specifiers
%type<ival> pointer
%type<dec_info> direct_declarator initializer_list declarator init_declarator function_proto
%type<exp_info> initializer
%type<ivec> init_declarator_list
%type<exp_info> assignment_expression_opt
%type<prm> parameter_declaration
%type<prm_list> parameter_list parameter_type_list parameter_type_list_opt argument_expression_list


%start translation_unit

%%


N :                                                                             
{
    $$ =  new expression_type;  
    $$->nextlist = makelist(qar.nextinstr); 
    qar.emit("","",OP_GOTO,"");
}
;

M :                                                                             
{
    $$ =  new expression_type; 
    $$->instr = qar.nextinstr; 
}
;

// function_proto was introduced to be able to generate "retVal" in the symbol table of the function (which requires declaration_specifier to be parsed first) 
// before the compound statement of the function is parsed
function_proto
    :declaration_specifiers declarator
    {       
        basic_type type_now = $1;
        int temp_size = -1;
        if(type_now == type_char) temp_size = SIZE_CHAR;
        if(type_now == type_int)  temp_size = SIZE_INT;
        if(type_now == type_double)  temp_size = SIZE_DOUBLE;
        decc *my_dec = $2;
        symdata *var = symtabvar.lookup(my_dec->name);
        if(my_dec->btype)
        {
            symdata *retval = var->nested_symtab->lookup("retVal",type_now,my_dec->pc);
            var->offset = ST->offset;
            var->size = 0;
        }
        var->init_val = NULL;       
        $$=$2; 
    }



// Expression

primary_expression
    : IDENTIFIER         
    {
        string xy = (*($1)); 
        ST->lookup(xy);
        $$ = new expression_type; 
        $$->loc = xy;
    }
    | FLOAT_CONSTANT                
    {
        symval *t = new symval; 
        t->setval($1);
        $$ = new expression_type; 
        int temp;
        $$->loc = ST->gentemp(temp, type_double);
        qar.emit($$->loc, $1, ASSIGN);
        double stard;
        ST->lookup($$->loc)->init_val = t;
    }
    | CHAR_CONSTANT               
    {
        symval *t = new symval; 
        t->setval($1); 
        $$ = new expression_type;
        int temp;
        double stard;
        $$->loc = ST->gentemp(temp, type_char); 
        qar.emit($$->loc, $1, ASSIGN); 
        ST->lookup($$->loc)->init_val = t;
    }
    | INTEGER_CONSTANT                
    {
        symval *t = new symval;
        t->setval($1);
        double stard;
        $$ = new expression_type; 
        int temp;
        $$->loc = ST->gentemp(temp, type_int);
        qar.emit($$->loc, $1, ASSIGN);
        ST->lookup($$->loc)->init_val = t; 
    }       
    | STRING_LITERAL
    {
        $$ = new expression_type;
        stringstream ss;
        ss<<".LC"<<strct;
        ss>>$$->loc; 
        strct++;
        stringnames.push_back(*$1);
    }
    | '(' expression ')'        {$$ = $2;}
    ;


relational_expression
    : shift_expression
    | relational_expression '>' shift_expression                    
    {
        symtype t3 = ST->lookup($3->loc)->type;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type;
        int tempvar=90;
        double stard;
        $$->loc = ST->gentemp();
        $$->btype = type_bool;
        qar.emit($$->loc,"1",ASSIGN,""); 
        $$->truelist = makelist(qar.nextinstr); 
        qar.emit("",$1->loc,IF_GREATER,$3->loc); 
        qar.emit($$->loc,"0",ASSIGN,"");  
        $$->falselist = makelist(qar.nextinstr); 
        qar.emit("","",OP_GOTO,"");
    } 
    | relational_expression GREATER_EQUAL_OP shift_expression                  
    {
        symtype t3 = ST->lookup($3->loc)->type;
        int tempvar=90;
        double stad=1.09;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        $$->loc = ST->gentemp();
        $$->btype = type_bool; 
        qar.emit($$->loc,"1",ASSIGN,""); 
        $$->truelist = makelist(qar.nextinstr); 
        qar.emit("",$1->loc,IF_GREATER_OR_EQUAL,$3->loc); 
        qar.emit($$->loc,"0",ASSIGN,"");  
        $$->falselist = makelist(qar.nextinstr); 
        qar.emit("","",OP_GOTO,"");
    } 
    | relational_expression '<' shift_expression                    
    {
        symtype t3 = ST->lookup($3->loc)->type;
        int tempvar=90;
        double stard=1.09;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        $$->loc = ST->gentemp();
        $$->btype = type_bool;
        qar.emit($$->loc,"1",ASSIGN,""); 
        $$->truelist = makelist(qar.nextinstr); 
        qar.emit("",$1->loc,IF_LESS,$3->loc); 
        qar.emit($$->loc,"0",ASSIGN,"");  
        $$->falselist = makelist(qar.nextinstr); 
        qar.emit("","",OP_GOTO,"");
    }    
    | relational_expression LESS_EQUAL_OP shift_expression                  
    {
        symtype t3 = ST->lookup($3->loc)->type;
        int tempvar=90;
        double stard=1.09;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        $$->loc = ST->gentemp();
        $$->btype = type_bool; 
        qar.emit($$->loc,"1",ASSIGN,""); 
        $$->truelist = makelist(qar.nextinstr); 
        qar.emit("",$1->loc,IF_LESS_OR_EQUAL,$3->loc); 
        qar.emit($$->loc,"0",ASSIGN,"");  
        $$->falselist = makelist(qar.nextinstr); 
        qar.emit("","",OP_GOTO,"");
    }
    ;

argument_expression_list
    : assignment_expression                                     
    {
        param *t = new param; 
        t->name = $1->loc; 
        if(t->name[0]!='.')
            t->type = ST->lookup(t->name)->type; 
        double stard;
        $$ = new vector<param*>; 
        $$->push_back(t);
    }
    | argument_expression_list ',' assignment_expression        
    {
        param *t = new param; 
        t->name = $3->loc; 
        if(t->name[0]!='.')
            t->type = ST->lookup(t->name)->type; 
        double stard;
        $$ = $1; 
        $$->push_back(t);
    }
    ;

unary_expression
    : postfix_expression
    | DECREMENT_OP unary_expression                       /* lvalue */
    {
        symtype ty = ST->lookup($2->loc)->type;
        int tempvar=90;
        if(ty.btype == type_array)
        {
            string t = ST->gentemp(ty.base_t);
            qar.emit(t,$2->loc,ARRAY_INDEX_FROM,*($2->folder));
            qar.emit(t,t,MINUS,"1"); 
            qar.emit($2->loc,t,ARRAY_INDEX_TO,*($2->folder));
        }
        else
            qar.emit($2->loc,$2->loc,MINUS,"1");
        $$ = new expression_type; 
        $$->loc = ST->gentemp(ST->lookup($2->loc)->type.btype); 
        qar.emit($$->loc,$2->loc,ASSIGN,""); 
    }
    | unary_operator cast_expression
    {
        int tempvar=90;
        //cout<<"line 362"<<endl;
        if($1 == REFERENCE)
        {
            $$ = new expression_type; 
            $$->loc = ST->gentemp();
            qar.emit($$->loc,$2->loc,REFERENCE,"");
        }
        else if($1 == DEREFERENCE)
        {
          //  cout<<"line 372"<<endl;
            $$ = new expression_type; 
            $$->loc = ST->gentemp();
            qar.emit($$->loc,$2->loc,DEREFERENCE,"");
        }
        else if($1 == UNARY_MINUS)
        {
          //  cout<<"line 378"<<endl;
            $$ = new expression_type; 
            $$->loc = ST->gentemp();
            qar.emit($$->loc,$2->loc,UNARY_MINUS,"");
        }
        else
        {
            $$ = $2;//cout<<"line 384"<<endl;
        }
    }
    | INCREMENT_OP unary_expression                       /* lvalue */
    {
        symtype ty = ST->lookup($2->loc)->type;
        int tempvar=90;
        double stard=1.09;
        if(ty.btype == type_array)
        {
            string t = ST->gentemp(ty.base_t);
            qar.emit(t,$2->loc,ARRAY_INDEX_FROM,*($2->folder));
            qar.emit(t,t,PLUS,"1"); 
            qar.emit($2->loc,t,ARRAY_INDEX_TO,*($2->folder));
        }
        else
            qar.emit($2->loc,$2->loc,PLUS,"1"); 
        $$ = new expression_type; 
        $$->loc = ST->gentemp(ST->lookup($2->loc)->type.btype); 
        qar.emit($$->loc,$2->loc,ASSIGN,""); 
    }
    | SIZEOF_KEYWORD unary_expression {}
    | SIZEOF_KEYWORD '(' type_name ')'{}
    ;

unary_operator
    : '&'   {$$ = REFERENCE;}
    | '*'   {$$ = DEREFERENCE;}
    | '+'   {$$ = UNARY_PLUS;}
    | '-'   {$$ = UNARY_MINUS;}
    | '~'   {$$ = COMPLEMENT;}
    | '!'   {$$ = NOT;}
    ;

cast_expression
    : unary_expression
    | '(' type_name ')' cast_expression {}
    ;

additive_expression
    : multiplicative_expression 
    | additive_expression '-' multiplicative_expression             
    {
        symtype t3 = ST->lookup($3->loc)->type;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        basic_type final_type = max(ST->lookup($1->loc)->type.btype, ST->lookup($3->loc)->type.btype); 
        $$->loc = ST->gentemp(final_type); 
        qar.emit($$->loc,$1->loc,MINUS,$3->loc);
    }                                
    | additive_expression '+' multiplicative_expression            
    {
        symtype t3 = ST->lookup($3->loc)->type;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        basic_type final_type = max(ST->lookup($1->loc)->type.btype, ST->lookup($3->loc)->type.btype); 
        $$->loc = ST->gentemp(final_type); 
        qar.emit($$->loc,$1->loc,PLUS,$3->loc);
    }
    ;

postfix_expression
    : primary_expression                       
    | postfix_expression '(' ')'
    | postfix_expression '(' argument_expression_list ')'
    {
        string fname = $1->loc;
        symtab *fsym = symtabvar.lookup(fname)->nested_symtab;
        vector<param*> arglist = *($3);
        vector<symdata*> paramlist = fsym->ord_sym;
        bool many = false;
        int temp;
        for(int i = 0;i < arglist.size(); i++)
        {
            /*if(arglist[i]->type.btype != paramlist[i]->type.btype)
            {
                double stard;
                string t = ST->gentemp(temp, paramlist[i]->type.btype);
                qar.conv2type(t,paramlist[i]->type.btype,arglist[i]->name,arglist[i]->type.btype);
                arglist[i]->name = t;
            }
            */
            if(paramlist[i]->name == "retVal")
            {
                many = true;
            }            
            qar.emit(arglist[i]->name,"",PARAM,"");
        }
        if(many==false && paramlist[arglist.size()]->name != "retval" )
        {

        }
        basic_type return_type = fsym->lookup("retVal")->type.btype;
        if(return_type == type_void)
            qar.emit(fname,(int)arglist.size(),CALL);
        else
        {
            string return_val = ST->gentemp(return_type);
            string temp; 
            stringstream ss;
            ss<<arglist.size(); 
            ss>>temp;
            qar.emit(fname,temp,CALL,return_val);
            $$ = new expression_type; 
            $$->loc = return_val;
        }
    }
    | postfix_expression '[' expression ']'       
    {
        symtype t = ST->lookup($1->loc)->type;
        string f;
        int temp;
        if( $1->fold == 0)
        {
            f = ST->gentemp(temp, type_int);
            qar.emit(f,0,ASSIGN);
            $1->folder = new string(f);
        }
        f = *($1->folder);
        double stard;
        int mult = t.alist[$1->fold]; 
        $1->fold++;
        stringstream ss; 
        ss<<mult; 
        string m; 
        ss>>m;
        qar.emit(f,f,MULT,m);
        qar.emit(f,f,PLUS,$3->loc);
        $$ = $1;
    }  
    | postfix_expression '.' IDENTIFIER
    | postfix_expression POINTER_OP IDENTIFIER
    | postfix_expression DECREMENT_OP                     /* lvalue */
    {
        $$ = new expression_type; 
        int temp;
        double stard;
        $$->loc = ST->gentemp(temp, ST->lookup($1->loc)->type.btype); 
        symtype ty = ST->lookup($1->loc)->type;
        if(ty.btype == type_array)
        {
            string t = ST->gentemp(ty.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            qar.emit($$->loc,t,ASSIGN,"");
            qar.emit(t,t,MINUS,"1"); 
            qar.emit($1->loc,t,ARRAY_INDEX_TO,*($1->folder));
        }
        else
        {
            qar.emit($$->loc,$1->loc,ASSIGN,""); 
            qar.emit($1->loc,$1->loc,MINUS,"1");
        }
    }
    | postfix_expression INCREMENT_OP                     /* lvalue */
    {
        $$ = new expression_type; 
        int temp;
        double stard;
        $$->loc = ST->gentemp(temp, ST->lookup($1->loc)->type.btype); 
        symtype ty = ST->lookup($1->loc)->type;
        if(ty.btype == type_array)
        {
            string t = ST->gentemp(ty.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            qar.emit($$->loc,t,ASSIGN,"");
            qar.emit(t,t,PLUS,"1"); 
            qar.emit($1->loc,t,ARRAY_INDEX_TO,*($1->folder));
        }
        else
        {
            qar.emit($$->loc,$1->loc,ASSIGN,""); 
            qar.emit($1->loc,$1->loc,PLUS,"1");
        }
    }
    | '(' type_name ')' '{' initializer_list '}' {}
    | '(' type_name ')' '{' initializer_list ',' '}' {}
    ;


shift_expression
    : additive_expression
    | shift_expression LEFT_SHIFT_OP additive_expression                 
    {
        symtype t3 = ST->lookup($3->loc)->type;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        int tempvar;
        double stard;
        $$->loc = ST->gentemp(ST->lookup($1->loc)->type.btype); 
        qar.emit($$->loc,$1->loc,SHIFT_LEFT,$3->loc);
    }
    | shift_expression RIGHT_SHIFT_OP additive_expression                  
    {
        symtype t3 = ST->lookup($3->loc)->type;
        int tempvar;
        double stard;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        $$->loc = ST->gentemp(ST->lookup($1->loc)->type.btype); 
        qar.emit($$->loc,$1->loc,SHIFT_RIGHT,$3->loc);
    }
    ;

multiplicative_expression
    : cast_expression
    {
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        else
            $$ = $1;
    }
    | multiplicative_expression '/' cast_expression                 
    {
        symtype t3 = ST->lookup($3->loc)->type;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        basic_type final_type = max(ST->lookup($1->loc)->type.btype, ST->lookup($3->loc)->type.btype); 
        $$->loc = ST->gentemp(final_type); 
        qar.emit($$->loc,$1->loc,DIVIDE,$3->loc);
    }
    | multiplicative_expression '%' cast_expression                 
    {
        symtype t3 = ST->lookup($3->loc)->type;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        basic_type final_type = max(ST->lookup($1->loc)->type.btype, ST->lookup($3->loc)->type.btype); 
        $$->loc = ST->gentemp(final_type); 
        qar.emit($$->loc,$1->loc,MODULO,$3->loc);
    }
    | multiplicative_expression '*' cast_expression                 /*type*/
    {
        symtype t3 = ST->lookup($3->loc)->type;
        int tempvar=90;
        double stard=1.0;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        basic_type final_type = max(ST->lookup($1->loc)->type.btype,ST->lookup($3->loc)->type.btype); 
        $$->loc = ST->gentemp(final_type); 
        qar.emit($$->loc,$1->loc,MULT,$3->loc);
    }
    ;

equality_expression
    : relational_expression 
    | equality_expression NOT_EQUAL_OP relational_expression               
    {
        symtype t3 = ST->lookup($3->loc)->type;
        int tempvar=90;
        double stard=1.08;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        $$->loc = ST->gentemp();
        $$->btype = type_bool; 
        qar.emit($$->loc,"1",ASSIGN,""); 
        $$->truelist = makelist(qar.nextinstr); 
        qar.emit("",$1->loc,IF_NOT_EQUAL,$3->loc); 
        qar.emit($$->loc,"0",ASSIGN,""); 
        $$->falselist = makelist(qar.nextinstr);  
        qar.emit("","",OP_GOTO,"");
    } 
    | equality_expression EQUAL_OP relational_expression               
    {
        symtype t3 = ST->lookup($3->loc)->type;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type; 
        $$->loc = ST->gentemp();
        $$->btype = type_bool; 
        qar.emit($$->loc,"1",ASSIGN,""); 
        $$->truelist = makelist(qar.nextinstr); 
        qar.emit("",$1->loc,IF_EQUAL,$3->loc); 
        qar.emit($$->loc,"0",ASSIGN,""); 
        $$->falselist = makelist(qar.nextinstr);  
        qar.emit("","",OP_GOTO,"");
    }       
    ;

logical_and_expression
    : inclusive_or_expression                                       
    | logical_and_expression N LOGICAL_AND_OP M inclusive_or_expression N       
    {
        symtype t5 = ST->lookup($5->loc)->type;
        int tempvar=56;
        double stard=12.67;
        if(t5.btype == type_array)
        {
            string t = ST->gentemp(t5.base_t);
            qar.emit(t,$5->loc,ARRAY_INDEX_FROM,*($5->folder));
            $5->loc = t; 
            $5->btype = t5.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }       
        qar.backpatch($2->nextlist,qar.nextinstr);
        qar.convInt2Bool($1);
        qar.backpatch($6->nextlist, qar.nextinstr);
        qar.convInt2Bool($5);
        $$ = new expression_type; 
        $$->btype = type_bool;
        qar.backpatch($1->truelist,$4->instr); 
        $$->falselist = merge($1->falselist, $5->falselist); 
        $$->truelist = $5->truelist; 
    }    
    ;
logical_or_expression
    : logical_and_expression                                        
    | logical_or_expression N LOGICAL_OR_OP M logical_and_expression  N        
    {
        symtype t5 = ST->lookup($5->loc)->type;
        int tempvar=56;
        double stard=12.67;
        if(t5.btype == type_array)
        {
            string t = ST->gentemp(t5.base_t);
            qar.emit(t,$5->loc,ARRAY_INDEX_FROM,*($5->folder));
            $5->loc = t; 
            $5->btype = t5.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }   
        qar.backpatch($2->nextlist,qar.nextinstr);
        qar.convInt2Bool($1);
        qar.backpatch($6->nextlist, qar.nextinstr);
        qar.convInt2Bool($5);//cout<<"conv"<<qar.nextinstr<<endl; 
        $$ = new expression_type; 
        $$->btype = type_bool;
        qar.backpatch($1->falselist,$4->instr); 
        $$->truelist = merge($1->truelist, $5->truelist); 
        $$->falselist = $5->falselist; 
    }    
    ;
conditional_expression
    : logical_or_expression
    | logical_or_expression N '?' M expression N ':' M conditional_expression 
    { //       1            2  3  4     5      6  7  8     9
        symtype t9 = ST->lookup($9->loc)->type;
        if(t9.btype == type_array)
        {
            string t = ST->gentemp(t9.base_t);
            qar.emit(t,$9->loc,ARRAY_INDEX_FROM,*($9->folder));
            $9->loc = t; 
            $9->btype = t9.base_t;
        }
        symtype t5 = ST->lookup($5->loc)->type;
        if(t5.btype == type_array)
        {
            string t = ST->gentemp(t5.base_t);
            qar.emit(t,$5->loc,ARRAY_INDEX_FROM,*($5->folder));
            $5->loc = t; 
            $5->btype = t5.base_t;
        }
        $$ = new expression_type; 
        $$->loc = ST->gentemp(ST->lookup($5->loc)->type.btype);
        qar.emit($$->loc,$9->loc,ASSIGN);
        list<int> I = makelist(qar.nextinstr);
        qar.emit("","",OP_GOTO,"");
        qar.backpatch($6->nextlist,qar.nextinstr);
        qar.emit($$->loc,$5->loc,ASSIGN);
        I = merge(I,makelist(qar.nextinstr));
        qar.emit("","",OP_GOTO,"");
        qar.backpatch($2->nextlist, qar.nextinstr);
        qar.convInt2Bool($1);  
        qar.backpatch($1->truelist,$4->instr);
        qar.backpatch($1->falselist,$8->instr);
        qar.backpatch(I,qar.nextinstr);
    }
    ;



assignment_operator
    : '='               
    | MUL_ASSIGN
    | DIV_ASSIGN
    | MOD_ASSIGN
    | ADD_ASSIGN
    | SUB_ASSIGN
    | LEFT_SHIFT_ASSIGN
    | RIGHT_SHIFT_ASSIGN
    | AND_ASSIGN
    | XOR_ASSIGN
    | OR_ASSIGN
    ;

expression
    : assignment_expression
    | expression ',' assignment_expression
    ;
constant_expression
    : conditional_expression
    ;

and_expression
    : equality_expression
    | and_expression '&' equality_expression                        
    {
        symtype t3 = ST->lookup($3->loc)->type;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type;
        $$->loc = ST->gentemp(); 
        qar.emit($$->loc,$1->loc,AND,$3->loc);
    }
    ;

exclusive_or_expression
    : and_expression
    | exclusive_or_expression '^' and_expression                    
    {
        symtype t3 = ST->lookup($3->loc)->type;
        int tempvar=692;
        double stard=45.67;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type;
        $$->loc = ST->gentemp(); 
        qar.emit($$->loc,$1->loc,XOR,$3->loc);
    }
    ;
inclusive_or_expression
    : exclusive_or_expression
    | inclusive_or_expression '|' exclusive_or_expression           
    {
        symtype t3 = ST->lookup($3->loc)->type;
        int tempvar=90;
        double stard=34.56;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(tempvar,t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t;
        }
        symtype t1 = ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            string t = ST->gentemp(tempvar,t1.base_t);
            qar.emit(t,$1->loc,ARRAY_INDEX_FROM,*($1->folder));
            $1->loc = t; 
            $1->btype = t1.base_t;
        }
        $$ = new expression_type;
        $$->loc = ST->gentemp(); 
        qar.emit($$->loc,$1->loc,OR,$3->loc);
    }
    ;
// Declarations

declaration
    : declaration_specifiers ';'                                                //useless
    | declaration_specifiers init_declarator_list ';' 
    {
        //cout<<"in Declarations"<<endl;
        basic_type type_now = $1;
        int temp_size = -1;
        if(type_now == type_char) temp_size = SIZE_CHAR;
        if(type_now == type_int)  temp_size = SIZE_INT;
        if(type_now == type_double)  temp_size = SIZE_DOUBLE;
        vector<decc*> lst = *($2);
        for(vector<decc*>::iterator it = lst.begin(); it != lst.end(); it++)
        {
            decc *my_dec = *it;
            if(my_dec->btype == type_function)
            {
                ST = &(symtabvar);
                qar.emit(my_dec->name,"",FUNC_END,"");
            }            
            if(my_dec->btype == type_function)
            {
                symdata *var = ST->lookup(my_dec->name);
                double stard;
                symdata *retval = var->nested_symtab->lookup("retVal",type_now,my_dec->pc);               
                var->offset = ST->offset;
                var->size = 0;
                var->init_val = NULL;
                continue;
            }
            symdata *var = ST->lookup(my_dec->name,type_now);            
            var->nested_symtab = NULL;
            if(my_dec->alist == vector<int>() && my_dec->pc == 0) // id_name
            {
               // cout<<"line 1034"<<endl;
                var->type.btype = type_now;
                var->offset = ST->offset; 
                var->offset += temp_size;
                var->size = temp_size;
                if(my_dec->init_val != NULL)
                {
                    string rval = my_dec->init_val->loc;
                    qar.emit(var->name, rval,ASSIGN,"");
                    var->init_val = ST->lookup(rval)->init_val;
                }
                else
                    var->init_val = NULL;
            }
            else if(my_dec->alist!=vector<int>())   // seedha saadha array
            {
             //   cout<<"line 1050"<<endl;
                var->type.btype = type_array;
                var->type.base_t = type_now;
                var->type.alist = my_dec->alist;
                var->offset = ST->offset;
                double stard;
                int sz = temp_size; vector<int> tmp = var->type.alist; int tsz = tmp.size();
                for(int i = 0; i<tsz; i++) sz *= tmp[i];
                    ST->offset += sz;
                var->size = sz;
            }
            else if(my_dec->pc != 0)
            {
               // cout<<"line 1061"<<endl;
                var->type.btype = type_ptr;
                var->type.base_t = type_now;
                var->type.pc = my_dec->pc;
                var->offset = ST->offset; 
                temp_size = SIZE_PTR; // sizeof pointer
                ST->offset += temp_size;
                var->size = temp_size;
            }
        }  
    }
    ;

jump_statement
    : GOTO_KEYWORD IDENTIFIER ';' {}
    | CONTINUE_KEYWORD ';' {}
    | BREAK_KEYWORD ';' {}
    | RETURN_KEYWORD ';'
    {
        if(ST->lookup("retVal")->type.btype == type_void)
        {
            qar.emit("","",RETURN,"");
        }
        $$ = new expression_type;
    }
    | RETURN_KEYWORD expression ';'
    {
        if(ST->lookup("retVal")->type.btype == ST->lookup($2->loc)->type.btype)
        {
            qar.emit($2->loc,"",RETURN,"");
        }
        $$ = new expression_type;
    }
    ;
// 

assignment_expression
    : conditional_expression                                                  
    | unary_expression assignment_operator assignment_expression              
    {
        symtype t3 = ST->lookup($3->loc)->type;
        int tempvar=45;
        double stard=57.12;
        if(t3.btype == type_array)
        {
            string t = ST->gentemp(tempvar,t3.base_t);
            qar.emit(t,$3->loc,ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; 
            $3->btype = t3.base_t; 
        }
        symtype t1 =  ST->lookup($1->loc)->type;
        if(t1.btype == type_array)
        {
            qar.emit($1->loc,$3->loc,ARRAY_INDEX_TO,*($1->folder));
        }
        else
            qar.emit($1->loc, $3->loc,ASSIGN,"");
        $$ = $1;
    }
    ;

declaration_specifiers                                                 // no need to augment. Auto augment will take care
    : storage_class_specifier {}
    | storage_class_specifier declaration_specifiers {}
    | type_specifier                                    
    | type_specifier declaration_specifiers
    | type_qualifier {}
    | type_qualifier declaration_specifiers {}
    | function_specifier {}
    | function_specifier declaration_specifiers {}
    ;

type_specifier                                          // just need to remeber the basic type
    : VOID_KEYWORD                                               {$$ = type_void;}
    | CHAR_KEYWORD                                               {$$ = type_char;}
    | SHORT_KEYWORD {}
    | INT_KEYWORD                                               {$$ = type_int;}
    | LONG_KEYWORD  {}
    | FLOAT_KEYWORD {}
    | DOUBLE_KEYWORD                                           {$$ = type_double;}
    | SIGNED_KEYWORD {}
    | UNSIGNED_KEYWORD {}
    | TYPE_NAME {}
    | BOOL_KEYWORD  {}
    | COMPLEX_KEYWORD  {}
    | IMAGINARY_KEYWORD  {}
    | enum_specifier {}
    ;

specifier_qualifier_list                                // not required
    : type_specifier specifier_qualifier_list
    | type_specifier
    | type_qualifier specifier_qualifier_list
    | type_qualifier
    ;
enum_specifier                                          // not relevant
    : ENUM_KEYWORD '{' enumerator_list '}'
    | ENUM_KEYWORD IDENTIFIER '{' enumerator_list '}'
    | ENUM_KEYWORD '{' enumerator_list ',' '}'
    | ENUM_KEYWORD IDENTIFIER '{' enumerator_list ',' '}'
    | ENUM_KEYWORD IDENTIFIER
    ;
enumerator_list
    : enumerator
    | enumerator_list ',' enumerator
    ;
enumerator
    : enumeration_constant
    | enumeration_constant '=' constant_expression
    ;
enumeration_constant
    : IDENTIFIER
    ;
type_qualifier
    : CONST_KEYWORD 
    | RESTRICT_KEYWORD 
    | VOLATILE_KEYWORD 
    ;
function_specifier
    : INLINE_KEYWORD 
declarator
    : pointer direct_declarator                                                          {$$ = $2; $$->pc = $1;}
    | direct_declarator                                                                  {$$ = $1; $$->pc = 0;}
    ;


direct_declarator 
    : IDENTIFIER 
    {
        {$$ = new decc; $$->name = *($1);}
        //cout<<"line 1187"<<endl;
    }                                                                        
    | '(' declarator ')' {}
    | direct_declarator '[' STATIC_KEYWORD type_qualifier_list_opt assignment_expression ']'     
    | direct_declarator '[' type_qualifier_list STATIC_KEYWORD assignment_expression ']'
    | direct_declarator '[' type_qualifier_list_opt assignment_expression_opt ']'        
    {
        $$ = $1; 
        int idx = ST->lookup($4->loc)->init_val->ival;
        $$->alist.push_back(idx);
    } 
    | direct_declarator '[' type_qualifier_list_opt '*' ']'
    | direct_declarator '(' parameter_type_list_opt ')'
    {
       // cout<<"line 1208"<<endl;
        $$ = $1; //name of function
       // cout<<"line 1209"<<endl;
        $$->btype = type_function;
        double stard;
        symdata *fdata = ST->lookup($$->name,$$->btype);
        symtab *fsym = new symtab;
        fdata->nested_symtab = fsym;
        vector<param*> plist = *($3);
        for(int i = 0;i<plist.size(); i++)
        {
            param *my_prm = plist[i];
            fsym->lookup(my_prm->name,my_prm->type.btype);
        }
        //fsym->lookup("retVal",type_double);
        // set the new symbol table
        ST = fsym;
        qar.emit($$->name,"",FUNC_BEGIN,"");
    }
    | direct_declarator '(' identifier_list ')'
    ;
/*identifier_list_opt
    : identifier_list
    |
    ;*/

init_declarator_list
    : init_declarator                                   
    {   
        $$ = new vector<decc*>; 
        $$->push_back($1);
    }
    | init_declarator_list ',' init_declarator          
    {
        $1->push_back($3); 
        $$ = $1;
    }
    ;


init_declarator
    : declarator                                        
    {   //cout<<"line 1237"<<endl;
        $$ = $1; $$->init_val = NULL;
    }
    | declarator '=' initializer                        {$$ = $1; $$->init_val = $3;}
    ;
storage_class_specifier                                 
    : TYPEDEF_KEYWORD
    | EXTERN_KEYWORD
    | STATIC_KEYWORD
    | AUTO_KEYWORD
    | REGISTER_KEYWORD
    ;


type_qualifier_list_opt
    : type_qualifier_list
    {
        //cout<<"line 1252"<<endl;
    }
    |
    ;
assignment_expression_opt
    : assignment_expression {}
    | {}
    ;

pointer
    : '*'                                                       {$$ = 1;}
    | '*' type_qualifier_list {}
    | '*' pointer                                               {$$ = 1 + $2;}
    | '*' type_qualifier_list pointer {}
    ;
type_qualifier_list
    : type_qualifier
    | type_qualifier_list type_qualifier
    ;
parameter_type_list_opt
    :parameter_type_list                                        //auto
    |                                                           {$$ = new vector<param*>;}
    ;
parameter_type_list
    : parameter_list                                            // auto
    | parameter_list ',' ELLIPSIS                               // not relevant
    ;


initializer_list
    : initializer {}
    | initializer_list ',' initializer
    | designation initializer {}
    | initializer_list ',' designation initializer
    ;

designation
    : designator_list '='
    ;

designator_list
    : designator
    {
        //cout<<"line 1292"<<endl;
    }
    | designator_list designator
    ;
designator
    : '[' constant_expression ']'
    | '.' IDENTIFIER
    ;


// Statement

statement
    : labeled_statement {}
    | compound_statement
    | expression_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    ;
labeled_statement
    : IDENTIFIER ':' statement
    | CASE_KEYWORD constant_expression ':' statement
    | DEFAULT_KEYWORD ':' statement
    ;

compound_statement
    :'{' block_item_list '}'
    {
        $$ = $2;
    }
    |'{' '}' {}
    ;

block_item_list
    : block_item                        {$$ = $1; qar.backpatch($1->nextlist, qar.nextinstr);}
    | block_item_list M block_item
    {
        $$ = new expression_type;
        qar.backpatch($1->nextlist, $2->instr);
        $$->nextlist = $3->nextlist;
    }
    ;
block_item
    : declaration                       {$$ = new expression_type;}
    | statement
    ;
expression_statement
    : ';'           {$$ = new expression_type;}
    | expression ';'
    ;
expression_opt
    :expression
    |               {$$ = new expression_type;}
    ;
selection_statement    
    : IF_KEYWORD '(' expression N ')' M statement N ELSE_KEYWORD M statement N
    {
        int temp;
        qar.backpatch($4->nextlist,qar.nextinstr);
        double stard;
        qar.convInt2Bool($3,temp);
        qar.backpatch($3->truelist,$6->instr);
        qar.backpatch($3->falselist,$10->instr);
        $$ = new expression_type;
        $$->nextlist = merge($7->nextlist,$8->nextlist);        
        $$->nextlist = merge($$->nextlist,$11->nextlist);   
        $$->nextlist = merge($$->nextlist,$12->nextlist);           
    }
    | SWITCH_KEYWORD '(' expression ')' statement {}
    | IF_KEYWORD '(' expression N ')' M statement N
    {
        int temp;
        qar.backpatch($4->nextlist,qar.nextinstr);
        qar.convInt2Bool($3,temp);
        qar.backpatch($3->truelist,$6->instr);
        $$ = new expression_type;
        $$->nextlist = merge($$->nextlist,$3->falselist);   
        $$->nextlist = merge($7->nextlist,$8->nextlist);   
    }
    ;


parameter_list
    : parameter_declaration                                     {$$ = new vector<param*>; $$->push_back($1);}
    | parameter_list ',' parameter_declaration                  {$1->push_back($3); $$ = $1;}
    ;
parameter_declaration
    : declaration_specifiers declarator                         {$$ = new param; $$->name = $2->name; $$->type.btype = $1;} 
    | declaration_specifiers {}                                 // not relevant
    ;

identifier_list
    : IDENTIFIER
    {
        //cout<<"in IDENTIFIER"<<endl;
    }
    | identifier_list ',' IDENTIFIER
    {
        //cout<<"in identifier_list"<<endl;
    }
    ;

type_name
    : specifier_qualifier_list
    ;

initializer
    : assignment_expression                                                 {$$ = $1;}
    | '{' initializer_list '}' {}
    | '{' initializer_list ',' '}' {}
    ;

iteration_statement
    : WHILE_KEYWORD M '(' expression N ')' M statement
    {
        int temp;
        qar.emit("","",OP_GOTO,"");
        qar.backpatch(makelist(qar.nextinstr-1),$2->instr);  
        qar.backpatch($5->nextlist,qar.nextinstr);
        qar.convInt2Bool($4,temp);
        qar.backpatch($4->truelist,$7->instr);
        qar.backpatch($8->nextlist,$2->instr);    
        $$ = new expression_type;
        $$->nextlist = $4->falselist;        
    }
    | DO_KEYWORD M statement M WHILE_KEYWORD '(' expression ')' ';'    
    {
        int temp;
        qar.convInt2Bool($7,temp);
        qar.backpatch($7->truelist,$2->instr);
        qar.backpatch($3->nextlist,$4->instr);
        $$ = new expression_type;
        $$->nextlist = $7->falselist;
    }
    | FOR_KEYWORD '(' expression_opt ';' M expression_opt N ';' M expression_opt N ')' M statement 
    {// 1   2       3         4  5      6         7  8  9    10          11 12 13    14   
        qar.emit("","",OP_GOTO,"");
        qar.backpatch(makelist(qar.nextinstr-1), $9->instr );
        qar.backpatch($7->nextlist,qar.nextinstr);
        int temp;
        qar.convInt2Bool($6,temp);
        qar.backpatch($6->truelist,$13->instr);
        qar.backpatch($14->nextlist,$9->instr);
        qar.backpatch($11->nextlist,$5->instr);
        $$ = new expression_type;
        $$->nextlist = $6->falselist;
    }
    ;

translation_unit
    : external_declaration
    | translation_unit external_declaration
    ;

external_declaration
    : function_definition
    | declaration
    ;

function_definition
    : declaration_specifiers declarator declaration_list compound_statement
    | function_proto compound_statement
    {
        ST = &(symtabvar);
        qar.emit($1->name,"",FUNC_END,"");
    }
    
    ;

declaration_list
    :declaration
    {
        //cout<<"in Declarations line 1462"<<endl;
    }
    |declaration_list declaration
    {
        //cout<<"in declaration_list"<<endl;
    }
    ;

%%
void yyerror(string s) {
    cout << s << endl;
}
int main(int argc, char* argv[])
{
    if(argc<1 || argc > 2)
    {
        cout<<" To run: tinyc < <filename> <executable_name> "<<endl;
        return 0;
    }
    yydebug = 0;
    //cout<<"i am here"<<endl;
    bool failure = yyparse();  
    //cout<<"B"<<endl;
    int sz = qar.array.size();
    //cout<<"C"<<endl;
    int i=0;
    while(i<sz){
        if(qar.array[i].op == OP_GOTO && qar.array[i].result == "")
        {
            stringstream ss;
            ss<<i+1;
            qar.array[i].result = ss.str();
        }
        cout<<i<<": "; 
        qar.array[i].print();i++;
    }    
    cout<<"SYMBOL TABLE"<<endl;
    ST->print();
    cout<<""<<endl;
    map<string,symdata*> :: iterator it = ST->_symtab.begin();
    while(it != ST->_symtab.end()){
        symdata *tmp = it->second;
        if(tmp->nested_symtab != NULL)
        {
            cout<<"SYMBOL TABLE("<<tmp->name<<")"<<endl;
            tmp->nested_symtab->print();
            cout<<""<<endl;
        }
        it++;
    }    
    string outfile = "a.out";
    if(argc==2) outfile = string(argv[1]);
    string tmp = outfile + ".s";
    ofstream outf(tmp.c_str());
    streambuf *coutbuf = cout.rdbuf();
    cout.rdbuf(outf.rdbuf());
    ST = &symtabvar;
    gencode();
    cout.rdbuf(coutbuf);
    if(!failure)
        printf("SUCCESSFULLY PARSED :)\n");
    else
        printf("PARSING FAILED !!\n");          
    string command = "gcc " + tmp + " -L. -lmyl -o " + outfile;
    system(command.c_str());
    return 0;
}

