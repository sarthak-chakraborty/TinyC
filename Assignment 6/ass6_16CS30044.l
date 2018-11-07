%{
	#include "ass6_16CS30044_translator.h"
	#include "y.tab.h"
	#include <stdlib.h>
%}


/* Keywords */	
AUTO					"auto"
BREAK 					"break"
CASE 					"case"
CHAR 					"char"
CONST 					"const"
CONTINUE 				"continue"
DEFAULT 				"deafult"
DO 						"do"
DOUBLE 					"double"
ELSE 					"else"
ENUM 					"enum"
EXTERN					"extern"
FLOAT 					"float"
FOR 					"for"
GOTO 					"goto"
IF 						"if"
INLINE 					"inline"
INT 					"int"
LONG 					"long"
REGISTER				"register"
RESTRICT 				"restrict"
RETURN 					"return"
SHORT 					"short"
SIGNED					"signed"
SIZEOF 					"sizeof"
STATIC					"static"
STRUCT 					"struct"
SWITCH 					"switch"
TYPEDEF 				"typedef"
UNION 					"union"
UNSIGNED 				"unsigned"
VOID 					"void"
VOLATILE 				"volatile"
WHILE 					"while"
_BOOL 					"_Bool"
_COMPLEX 				"_Complex"
_IMAGINARY				"_Imaginary"


/* Identifier */
ID 						[a-zA-Z_][a-zA-Z0-9_]*


/*Constants*/
ESC_SEQ					[\\][']|[\\]["]|[\\][?]|[\\][\\]|[\\][a]|[\\][b]|[\\][f]|[\\][n]|[\\][r]|[\\][t]|[\\][v]
C_CHAR					[^'\n\\]|{ESC_SEQ}
C_CHAR_SEQ				{C_CHAR}+
CHAR_CONST				[']{C_CHAR_SEQ}[']
S_CHAR 					[^"\n\\]|{ESC_SEQ}
S_CHAR_SEQ				{S_CHAR}+
STRING_CONST			["]{S_CHAR_SEQ}["]|["]["]
INT_CONST 				[1-9][0-9]*|"0"
DIG_SEQ					[0-9]+
FRAC_CONST				{DIG_SEQ}[.]{DIG_SEQ}|[.]{DIG_SEQ}|{DIG_SEQ}[.]
EXP_PART				[eE]{DIG_SEQ}|[eE][+\-]{DIG_SEQ}
FLOAT_CONST				{FRAC_CONST}|{FRAC_CONST}{EXP_PART}|{DIG_SEQ}{EXP_PART}
ENUM_CONST				{ID}


/* Comments */
SINGLE_COMMENT			[/][/][^\n]*[\n]
SENTENCE				[^*]|[*]+[^/*]
MULTI_COMMENT			[/][*]{SENTENCE}*[*]+[/]


/* White Spaces */
WS 						[ \t\n\v]



%%
{MULTI_COMMENT}					{/*return MULTI_LINE_COMMENT;*/}
{SINGLE_COMMENT}				{/*return SINGLE_LINE_COMMENT;*/}

{AUTO}					{return AUTO_KEYWORD;}
{ENUM}					{return ENUM_KEYWORD;}
{RESTRICT}				{return RESTRICT_KEYWORD;}
{UNSIGNED}				{return UNSIGNED_KEYWORD;}
{BREAK}					{return BREAK_KEYWORD;}
{EXTERN}				{return EXTERN_KEYWORD;}
{RETURN}				{return RETURN_KEYWORD;}
{VOID}					{return VOID_KEYWORD;}
{CASE}					{return CASE_KEYWORD;}
{FLOAT}					{return FLOAT_KEYWORD;}
{SHORT}					{return SHORT_KEYWORD;}
{VOLATILE}				{return VOLATILE_KEYWORD;}
{CHAR}					{return CHAR_KEYWORD;}
{FOR}					{return FOR_KEYWORD;}
{SIGNED}				{return SIGNED_KEYWORD;}
{WHILE}					{return WHILE_KEYWORD;}
{CONST}					{return CONST_KEYWORD;}
{GOTO}					{return GOTO_KEYWORD;}
{SIZEOF}				{return SIZEOF_KEYWORD;}
{_BOOL}					{return BOOL_KEYWORD;}
{CONTINUE}				{return CONTINUE_KEYWORD;}
{IF}					{return IF_KEYWORD;}
{STATIC}				{return STATIC_KEYWORD;}
{_COMPLEX}				{return COMPLEX_KEYWORD;}
{DEFAULT}				{return DEFAULT_KEYWORD;}
{INLINE}				{return INLINE_KEYWORD;}
{STRUCT}				{return STRUCT_KEYWORD;}
{_IMAGINARY}			{return IMAGINARY_KEYWORD;}
{DO}					{return DO_KEYWORD;}
{INT}					{return INT_KEYWORD;}
{SWITCH}				{return SWITCH_KEYWORD;}
{DOUBLE}				{return DOUBLE_KEYWORD;}
{LONG}					{return LONG_KEYWORD;}
{TYPEDEF}				{return TYPEDEF_KEYWORD;}
{ELSE}					{return ELSE_KEYWORD;}
{REGISTER}				{return REGISTER_KEYWORD;}
{UNION}					{return UNION_KEYWORD;}

{ID}                    { yylval.str = new string(yytext);return IDENTIFIER;}

{INT_CONST}				{ 	yylval.ival = atoi(yytext);
							return INTEGER_CONSTANT;}
{FLOAT_CONST}			{ 	yylval.dval=atof(yytext);
							return FLOAT_CONSTANT;}
{CHAR_CONST}			{ 	yylval.cval=yytext[1]; 
							return CHAR_CONSTANT;}
{STRING_CONST}        	{ 	yylval.str=new string(yytext); 
							return STRING_LITERAL;}


"..."                   { return ELLIPSIS;}
">>="                   { return RIGHT_SHIFT_ASSIGN;}
"<<="                   { return LEFT_SHIFT_ASSIGN;}
"+="                    { return ADD_ASSIGN;}
"-="                    { return SUB_ASSIGN;}
"*="                    { return MUL_ASSIGN;}
"/="                    { return DIV_ASSIGN;}
"%="                    { return MOD_ASSIGN;}
"&="                    { return AND_ASSIGN;}
"^="                    { return XOR_ASSIGN;}
"|="                    { return OR_ASSIGN;}
">>"                    { return RIGHT_SHIFT_OP;}
"<<"                    { return LEFT_SHIFT_OP;}
"++"                    { return INCREMENT_OP;}
"--"                    { return DECREMENT_OP;}
"->"                    { return POINTER_OP;}
"&&"                    { return LOGICAL_AND_OP;}
"||"                    { return LOGICAL_OR_OP;}
"<="                    { return LESS_EQUAL_OP;}
">="                    { return GREATER_EQUAL_OP;}
"=="                    { return EQUAL_OP;}
"!="                    { return NOT_EQUAL_OP;}

"{"                     { return '{'; }
"}"                     { return '}'; }
","                     { return ','; }
":"                     { return ':'; }
"="                     { return '='; }
"("                     { return '('; }
")"                     { return ')'; }
"["                     { return '['; }
"]"                     { return ']'; }
"."                     { return '.'; }
"&"                     { return '&'; }
"!"                     { return '!'; }
"~"                     { return '~'; }
"-"                     { return '-'; }
"+"                     { return '+'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"%"                     { return '%'; }
"<"                     { return '<'; }
">"                     { return '>'; }
"^"                     { return '^'; }
"|"                     { return '|'; }
"?"                     { return '?'; }
"#"                    	{ return '#'; }
";"                     { return ';'; }


{WS}					{/*Ignore whitespaces*/;}
%%





