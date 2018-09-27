%{
	#include "y.tab.h"
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





%%
{MULTI_COMMENT}					{/*return MULTI_COMMENT;*/}
{SINGLE_COMMENT}				{/*return SINGLE_COMMENT;*/}


{AUTO}							{return AUTO;}
{BREAK}							{return BREAK;}
{CASE}							{return CASE;}
{CHAR}							{return CHAR;}
{CONST}							{return CONST;}
{CONTINUE}						{return CONTINUE;}
{DEFAULT}						{return DEFAULT;}
{DO}							{return DO;}
{DOUBLE}						{return DOUBLE;}
{ELSE}							{return ELSE;}
{ENUM}							{return ENUM;}
{EXTERN}						{return EXTERN;}
{FLOAT}							{return FLOAT;}
{FOR}							{return FOR;}
{GOTO}							{return GOTO;}
{IF}							{return IF;}
{INLINE}						{return INLINE;}
{INT}							{return INT;}
{LONG}							{return LONG;}
{REGISTER}						{return REGISTER;}
{RESTRICT}						{return RESTRICT;}
{RETURN}						{return RETURN;}
{SHORT}							{return SHORT;}
{SIGNED}						{return SIGNED;}
{SIZEOF}						{return SIZEOF;}
{STATIC}						{return STATIC;}
{STRUCT}						{return STRUCT;}
{SWITCH}						{return SWITCH;}
{TYPEDEF}						{return TYPEDEF;}
{UNION}							{return UNION;}
{UNSIGNED}						{return UNSIGNED;}
{VOID}							{return VOID;}
{VOLATILE}						{return VOLATILE;}
{WHILE}							{return WHILE;}
{_BOOL}							{return _BOOL;}
{_COMPLEX}						{return _COMPLEX;}
{_IMAGINARY}					{return _IMAGINARY;}


{ID}							{return ID;}


{FLOAT_CONST}					{return FLOAT_CONST;}
{INT_CONST}						{return INT_CONST;}
{ENUM_CONST}					{return ENUM_CONST;}
{CHAR_CONST}					{return CHAR_CONST;}
{STRING_CONST}					{return STRING_CONST;}


"["								{return LSQBRACKET;}
"]"								{return RSQBRACKET;}
"{"								{return LBRACE;}
"}"								{return RBRACE;}
"("								{return LPARAN;}
")"								{return RPARAN;}
"."								{return DOT;}
"->"							{return ARROW;}
"+="							{return PLUS_ASSGN;}
"-="							{return SUB_ASSGN;}
"*="							{return MULT_ASSGN;}
"/="							{return DIV_ASSGN;}
"<<="							{return LEFT_SHIFT_ASSGN;}
">>="							{return RIGHT_SHIFT_ASSGN;}
"&="							{return AND_ASSGN;}
"|="							{return OR_ASSGN;}
"^="							{return XOR_ASSGN;}
"<="							{return LESSEQ;}
">="							{return GREATEREQ;}
"=="							{return EQUALS;}
"!="							{return NOTEQ;}
"++"							{return INCREMENT;}
"--"							{return DECREMENT;}
"&"								{return BIT_AND;}
"|"								{return BIT_OR;}
"^"								{return BIT_XOR;}
"+"								{return PLUS;}
"-"								{return SUB;}
"*"								{return MULT;}
"/"								{return DIV;}
"%"								{return MOD;}
"~"								{return BIT_NOT;}
"!"								{return LOG_NOT;}
"&&"							{return LOG_AND;}
"||"							{return LOG_OR;}
"<<"							{return LEFTSHIFT;}
">>"							{return RIGHTSHIFT;}
"<"								{return LESS;}
">"								{return GREATER;}
"?"								{return QUES;}
":"								{return COLON;}
";"								{return SEMICOLON;}
"..."							{return ELLIPSIS;}
"="								{return ASSIGN;}
","								{return COMMA;}
"#"								{return HASH;}


{WS}							{/* Ignore whitespace */}
%%