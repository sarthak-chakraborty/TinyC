
#ifndef Translator
#define Translator
#include <bits/stdc++.h>
#define char_size 1
#define int_size 4
#define double_size 8
#define pointer_size 4
extern char* yytext;
extern int yyparse();

using namespace std;

class symtab;		// Entire symbol table
class sym;			// Each entry in a symbol table
class symType;		// Type of a symbol in the symbol table
class quads;		// Entire quads
class quad;			// Each entry in each quad array

enum etype			// Enumeration of types
{
	VOID, CHAR, INT, DOUBLE, PTR, ARR, FUNC
};

enum optype			// Enumeration of operations
{
	EQUAL,													// Equality operator
	LT, GT, LE, GE, EQOP, NEOP,								// Relational operators
	GOTO, RETURN,											// Jump operations
	ADD, SUB, MULT, DIVIDE, RIGHTOP, LEFTOP, MODOP,			// ALU operations
	UMINUS, UPLUS, ADDRESS, RIGHT_POINTER, BNOT, LNOT,		// Unary operators
	BAND, XOR, INOR,										// Logical operators
	PTRL, PTRR,												// PTR Assign
	ARRR, ARRL,												// Arrays
	PARAM, CALL, LABEL										// Function calling
};


class symType {		// Type of an entry of symbol table
public:
	etype cat;	
	symType* ptr;
	int width;	
	symType(etype cat, symType* ptr = NULL, int width = 1);
	friend ostream& operator << (ostream&, const symType);
};


class sym {			// Each entry of symbol table
public:
	string name;		
	symType* type;		
	string init;		
	string category;	
	int size;			
	int offset;			
	symtab* nest;		
	sym(string s, etype t = INT, symType* ptr = NULL, int width = 0);
	sym* initialize (string s);	
	sym* update(etype t);
	sym* update(symType * sym);
	friend ostream& operator << (ostream&, const sym*);
	sym* linkst(symtab* t);
};


class symtab {			// Symbol table (ST)
public:
	string tname;		
	int tcount;			
	list <sym> table;	
	symtab* parent;		
	symtab(string name = "");		
	sym* lookup(string name);		
	void print(int all = 0);
	void computeOffsets();
};

class quad {		// for individual quads
public:
	optype op;		//operator type
	string arg1;	// for argument 1
	string arg2;	// for argument 2
	string result;	// for result

	// Constructors
	quad(string result, string arg1, optype op = EQUAL, string arg2 = "");
	quad(string result, int arg1, optype op = EQUAL, string arg2 = "");

	void print();	// to print the quads
	void update(int address);	// to backpatch address

};

class quads {
public:
	vector <quad> array;	// for Vector of quads

	quads() {
		array.reserve(300);		// initially reserving for quads
	}

	void print();		// to print all quads
	void printtab();	// to print quads in tabular form as asked in question
};

class GlobalST {		// for the unique global ST object
public:
	static GlobalST* getInstance();		// has a single unique instance of GST

private:
	GlobalST();		// constructor
	static GlobalST* pGlobalST;	// ptr to the GlobalST instance
};

/** Function Declarations (required for the semantic actions)*/
sym* gentemp(etype t = INT, string init = "");		// Generate a temporary variable and insert it in symbol table
sym* gentemp(symType* t, string init = "");		// Generate a temporary variable and insert it in symbol table

void backpatch(list <int> l, int i);
void emit(optype opL, string res, string a1 = "", string a2 = "");	// string operands
void emit(optype op, string res, int a1, string a2="");			// one int operand
	
typedef list<int> lint;		// Convenience

list<int> makelist(int);	// making a new list
list<int> merge(list <int> & l1, list <int> & l2);	// merging the lists

int sizeOfType(symType*);							// to calculate size of any type
string conv2string(const symType*);			// to printe the type structure

string op2str(int);								// to Convert an op to string

sym* conv(sym*, etype);							// Convert symbol to different type
bool typecheck(sym* &s1, sym* &s2);					// Checks if two symbol table entries have same type
bool typecheck(symType* s1, symType* s2);			// Checks if the type objects are equivalent

int nextinstr();									// to Return the address of the next instruction
string number2string(int);							// to Convert a number to string (mainly used to store numbers)

void changeTable(symtab* newtable);			// to change the current symbol table


/** Some global vars used in the translator.cxx file */
extern symtab* table;		// Current ST
extern symtab* globalTable;		// global ST
extern quads qarr;			// for the array / list of Quads
extern sym* currsym;		// ptr to the current symbol


/** Some structs for the Attributes / Global for Boolean Expression***/
struct expr {
	bool isbool;				// to check if the expression is boolean type
								
	// Valid for non-bool type
	sym* symp;					// Pointer to the entry of the ST
								
	// Valid for bool type only
	lint truelist;				// Truelist - for boolean expressions
	lint falselist;				// Falselist - for boolean expressions

	lint nextlist;				// Valid for statement expression
};

struct statement {
	lint nextlist;				// Nextlist for statement
};

struct unary {
	etype cat;					// for category
	sym* loc;					// Temporary var used for computing array address
	sym* symp;					// Pointer to symbol table
	symType* type;				// type of the subarray generated
};

// Utility functions
template <typename T> string tostr(const T& t) {	// Convert any type to string type
	ostringstream os;
	os << t;
	return os.str();
}

expr* conv2bool(expr*);				// Convert any expression to bool

expr* convfrombool(expr*);			// Convert bool to expression


#endif
