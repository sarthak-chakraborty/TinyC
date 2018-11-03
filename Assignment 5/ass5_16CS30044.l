%{
	#include "y.tab.h"
	#include "ass5_16CS30044_translator.h"
	int ln=1;
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


/* Constants */
DIG_SEQ					[0-9]+
FRAC_CONST				{DIG_SEQ}[.]{DIG_SEQ}|[.]{DIG_SEQ}|{DIG_SEQ}[.]
EXP_PART				[eE]{DIG_SEQ}|[eE][+\-]{DIG_SEQ}
FLOAT_CONST				{FRAC_CONST}|{FRAC_CONST}{EXP_PART}|{DIG_SEQ}{EXP_PART}
INT_CONST 				[1-9][0-9]*
ESC_SEQ					[\\][']|[\\]["]|[\\][?]|[\\][\\]|[\\][a]|[\\][b]|[\\][f]|[\\][n]|[\\][r]|[\\][t]|[\\][v]
C_CHAR					[^'\n\\]|{ESC_SEQ}
C_CHAR_SEQ				{C_CHAR}+
CHAR_CONST				[']{C_CHAR_SEQ}[']
S_CHAR 					[^"\n\\]|{ESC_SEQ}
S_CHAR_SEQ				{S_CHAR}+
STRING_CONST			["]{S_CHAR_SEQ}["]|["]["]
ENUM_CONST 				{ID}


/* Comments */
SINGLE_COMMENT			[/][/][^\n]*[\n]
SENTENCE				[^*]|[*]+[^/*]
MULTI_COMMENT			[/][*]{SENTENCE}*[*]+[/]
 

/* White Spaces */
WS 						[ \t\n]
NEWLINE					[\n]





%%
{MULTI_COMMENT}					{/*return MULTI_LINE_COMMENT;*/}
{SINGLE_COMMENT}				{/*return SINGLE_LINE_COMMENT;*/}


{AUTO}							{return AUTO_K;}
{BREAK}							{return BREAK_K;}
{CASE}							{return CASE_K;}
{CHAR}							{return CHAR_K;}
{CONST}							{return CONST_K;}
{CONTINUE}						{return CONTINUE_K;}
{DEFAULT}						{return DEFAULT_K;}
{DO}							{return DO_K;}
{DOUBLE}						{return DOUBLE_K;}
{ELSE}							{return ELSE_K;}
{ENUM}							{return ENUM_K;}
{EXTERN}						{return EXTERN_K;}
{FLOAT}							{return FLOAT_K;}
{FOR}							{return FOR_K;}
{GOTO}							{return GOTO_K;}
{IF}							{return IF_K;}
{INLINE}						{return INLINE_K;}
{INT}							{return INT_K;}
{LONG}							{return LONG_K;}
{REGISTER}						{return REGISTER_K;}
{RESTRICT}						{return RESTRICT_K;}
{RETURN}						{return RETURN_K;}
{SHORT}							{return SHORT_K;}
{SIGNED}						{return SIGNED_K;}
{SIZEOF}						{return SIZEOF_K;}
{STATIC}						{return STATIC_K;}
{STRUCT}						{return STRUCT_K;}
{SWITCH}						{return SWITCH_K;}
{TYPEDEF}						{return TYPEDEF_K;}
{UNION}							{return UNION_K;}
{UNSIGNED}						{return UNSIGNED_K;}
{VOID}							{return VOID_K;}
{VOLATILE}						{return VOLATILE_K;}
{WHILE}							{return WHILE_K;}
{_BOOL}							{return _BOOL_K;}
{_COMPLEX}						{return _COMPLEX_K;}
{_IMAGINARY}					{return _IMAGINARY_K;}


{ID}							{	yylval.symp = table -> lookup(yytext);
									return ID;}


{FLOAT_CONST}					{	yylval.strval = yytext;
									return FLOAT_CONST;}
{INT_CONST}						{	yylval.intval = atoi(yytext);
									return INT_CONST;}
{ENUM_CONST}					{return ENUM_CONST;}
{CHAR_CONST}					{return CHAR_CONST;}
{STRING_CONST}					{	yylval.strval = yytext;
									return STRING_CONST;}


"["								{return LEFT_SQUARE_BRACKET;}
"]"								{return RIGHT_SQUARE_BRACKET;}
"{"								{return LEFT_CURLY_BRACKET;}
"}"								{return RIGHT_CURLY_BRACKET;}
"("								{return LEFT_ROUND_BRACKET;}
")"								{return RIGHT_ROUND_BRACKET;}
"."								{return DOT;}
"->"							{return ARROW;}
"+="							{return PLUS_EQUAL_TO;}
"-="							{return MINUS_EQUAL_TO;}
"*="							{return ASTERISK_EQUAL_TO;}
"/="							{return SLASH_EQUAL_TO;}
"<<="							{return LEFT_SHIFT_EQUAL_TO;}
">>="							{return RIGHT_SHIFT_EQUAL_TO;}
"&="							{return AND_EQUAL_TO;}
"|="							{return OR_EQUAL_TO;}
"^="							{return XOR_EQUAL_TO;}
"<="							{return LESS_THAN_EQUAL_TO;}
">="							{return GREATER_THAN_EQUAL_TO;}
"=="							{return EQUAL_TO;}
"!="							{return NOT_EQUAL_TO;}
"++"							{return INCREMENT;}
"--"							{return DECREMENT;}
"&"								{return AND;}
"|"								{return OR;}
"^"								{return XOR_SIGN;}
"+"								{return PLUS;}
"-"								{return MINUS;}
"*"								{return ASTERISK;}
"/"								{return FORWARD_SLASH;}
"%"								{return PERCENT;}
"~"								{return TILDA;}
"!"								{return NOT;}
"&&"							{return LOGICAL_AND;}
"||"							{return LOGICAL_OR;}
"<<"							{return LEFT_SHIFT;}
">>"							{return RIGHT_SHIFT;}
"<"								{return LESS_THAN;}
">"								{return GREATER_THAN;}
"?"								{return QUESTION_MARK;}
":"								{return COLON;}
";"								{return SEMI_COLON;}
"..."							{return ELLIPSIS;}
"="								{return ASSIGNED;}
","								{return COMMA;}
"#"								{return HASH;}


{WS}							{/* Ignore whitespace */}
{NEWLINE}						{ln++;}
%%