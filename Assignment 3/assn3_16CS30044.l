%{
#define	AUTO				10
#define BREAK 				11
#define CASE 				12
#define CHAR 				13
#define CONST 				14
#define CONTINUE 			15
#define DEFAULT 			16
#define DO 					17
#define DOUBLE 				18
#define ELSE 				19
#define ENUM 				20
#define EXTERN 				21
#define FLOAT 				22
#define FOR 				23
#define GOTO 				24
#define IF 					25
#define INLINE				26
#define INT 				27
#define LONG 				28
#define REGISTER 			29
#define RESTRICT			30
#define RETURN 				31
#define SHORT 				32
#define SIGNED 				33
#define SIZEOF 				34
#define STATIC 				35
#define STRUCT 				36
#define SWITCH 				37
#define TYPEDEF 			38
#define UNION 				39
#define UNSIGNED 			40
#define VOID 				41
#define VOLATILE 			42
#define WHILE 				43
#define _BOOL 				44
#define _COMPLEX 			45
#define _IMAGINARY 			46
#define	ID					47
#define FLOAT_CONST			48
#define	INT_CONST			49
#define ENUM_CONST 			50
#define CHAR_CONST			51
#define STRING_CONST 		52
#define LSQBRACKET 			53
#define RSQBRACKET 			54
#define	LBRACE				55
#define	RBRACE				56
#define LPARAN				57
#define RPARAN 				58
#define DOT 				59
#define ARROW				60
#define INCREMENT 			61
#define DECREMENT 			62
#define BIT_AND 			63
#define BIT_OR 				64
#define BIT_XOR				65
#define	PLUS				66
#define SUB		 			67
#define	MULT				68
#define DIV 				69
#define MOD 				70
#define BIT_NOT				71
#define LOG_NOT 			72
#define LOG_AND				73
#define LOG_OR 				74
#define RIGHTSHIFT			75
#define LEFTSHIFT 			76
#define LESS				77
#define GREATER 			78
#define LESSEQ				79
#define GREATEREQ			80
#define EQUALS				81
#define NOTEQ				82
#define QUES 				83
#define COLON				84
#define	SEMICOLON			85
#define ELLIPSIS	 		86
#define	ASSIGN				87
#define PLUS_ASSGN			88
#define SUB_ASSGN			89
#define MULT_ASSGN			90
#define DIV_ASSGN			91
#define LEFT_SHIFT_ASSGN	92
#define RIGHT_SHIFT_ASSGN	93
#define AND_ASSGN			94
#define OR_ASSGN			95
#define XOR_ASSGN			96
#define COMMA				97
#define HASH				98
#define SINGLE_COMMENT		99
#define MULTI_COMMENT		100
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
{MULTI_COMMENT}					{return MULTI_COMMENT;}
{SINGLE_COMMENT}				{return SINGLE_COMMENT;}


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



