#ifndef ass5_16CS30044_translator_h
#define ass5_16CS30044_translator_h
#include <bits/stdc++.h>
using namespace std;

#define SIZE_DOUBLE 8
#define SIZE_INT 4
#define SIZE_CHAR 4
#define SIZE_PTR 8

enum opcode{
	//Binary Assignment Operators
	PLUS=1,
	MINUS,
	MULT,
	DIVIDE,
	LESS,
	GREATER,
	EQUAL,
	NOT_EQUAL,
	LESS_OR_EQUAL,
	OR,
	AND,
	XOR,
	LOGICAL_OR,
	LOGICAL_AND,
	SHIFT_RIGHT,
	SHIFT_LEFT,
	MODULO,
	GREATER_OR_EQUAL,

	//UNARY ASSIGNMENT OPERATORS 
	COMPLEMENT,
	NOT,
	UNARY_PLUS,
	UNARY_MINUS,

	//Copy assignment instruction
	ASSIGN,
	//Unconditional Jump,
	OP_GOTO,
	//Conditional Jump
	IF_EQUAL,
	IF_NOT_EQUAL,
	IF_LESS,
	IF_LESS_OR_EQUAL,
	IF_EXPRESSION,
	IF_NOT_EXPRESSION,
	IF_GREATER,
	IF_GREATER_OR_EQUAL,

	//Hardware defined conversions
	CHAR2INT,
	CHAR2DOUBLE,
	INT2CHAR,
	INT2DOUBLE,
	DOUBLE2INT,
	DOUBLE2CHAR,

	//Procedural Call
	PARAM,
	CALL,

	//Return Call
	RETURN,

	//Array Indexing Opcodes to be Inserted
	ARRAY_INDEX_FROM,
	ARRAY_INDEX_TO,

	//ADDRESS AND POINTER ASSIGNMENT INSTRUCTIONS
	POINTER_ASSIGNMENT,
	REFERENCE,
	DEREFERENCE,
	LDEREFERENCE,
	FUNC_BEGIN,
	FUNC_END
};

class quad{      
public:
    opcode op; string arg1,arg2,result;
    void print(int x=0, int y=0);           
};

enum basic_type{
	none,type_int,type_char,type_ptr,type_double,
	type_void,type_array,type_function,type_bool
};


class symval{
public:
	void* pval;
	char cval;
	int ival;
	double dval;

	void setval(double a){
		ival=a;cval=a;dval=a;
	}
	void setval(int a, int b=0){
		ival=a;cval=a;dval=a;
	}
	void setval(char a, char b='a'){
		ival=a;cval=a;dval=a;
	}
};


class expression_type{
public:
	list<int> truelist, falselist, nextlist;
	list<int> templist;
	int instr,fold;
	basic_type btype;
	string loc;
	string *folder;
	string positon;
	expression_type(){
		fold=0;
		folder=NULL;
	}
};

class decc{
public:
	int pc; 
	string name;
	string name1,name2;
	basic_type btype;
	expression_type *init_val,*initvalue;
	vector<int> alist;
	set<pair<int,int> > st;
};

class symtype{
public:
	int pc;
	basic_type base_t,btype;
	vector<int> alist;
	vector<int> btlist;
	map<list<double>,pair<int,pair<int,int> > > mp;
};

class temp{
public:
	int x,y,z;
	double c,r;
	char a,b;
	temp(int a, int b, int c){
		x=a;y=b;z=c;
	}
	temp(char x){
		this->a=x;
		this->b=x;
	}
	temp(double z, double y){
		this->c=z;
		this->r=y;
	}
	void printint(){
		printf("%d %d %d\n",x,y,z);
	}
	void printdouble(){
		printf("%lf %lf\n",c,r);
	}
	void printchar(){
		printf("%c %c\n",a,b);
	}
};

list<int> makelist(int index);
list<int> merge(list<int> a, list<int> b, int n=1);
void get(string x);  //test function
class quadarray{
public:
	vector<quad> array;
	int nextinstr;
	quadarray(){
		nextinstr=0;
	}
	void backpatch(list<int> a, int index, int index2=0);
	void convInt2Bool(expression_type* res, int x=1, int error=0);
	void conv2type(string t,basic_type bt, string f, basic_type from, int error=0);
	void conv2type(expression_type* t, expression_type* res, basic_type bt, int error=0);
	void emit(string res, string arg1, opcode op, string arg2="", string error="yes");
	void emit(string res, char c, opcode unary_op);
	void emit(string a, string b);
	void emit(string res, int i, opcode unary_op, pair<int,int> pi=make_pair(0,0));
    void emit(string res, double d, opcode unary_op, double xy=1.11);
};

class symtab;
class symdata{
public:
	string name;
	int size,offset;
	symtype type;
	map<pair<int,string>,set<int> > mp;
	symtab *nested_symtab;
	symval *init_val;
	symdata(){
		nested_symtab=NULL;
	}
};

void gencode(int abc=1, double xyz=10.0);

class param{
public:
	symtype type;
	string name;
};

class symtab{
public:
	string gentemp(int xy, basic_type bt = type_int);
	string gentemp(basic_type bt=type_int);
	void print();
	symdata* lookup(string var, basic_type bt=type_int, int pc=0, int xy=0);
	symdata* justlookup(string var);
	int offset;
	map<string,symdata*> _symtab;
	vector<symdata*> ord_sym;
	symtab() { 
		offset=0;
	}
};

#endif
