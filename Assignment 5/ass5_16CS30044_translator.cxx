
#include "ass5_16CS30044_translator.h"

symtab* globalTable;
symtab* table;
quads qarr;						// for the sequence of Quads
etype TYPE;					// to Store the latest type specifier
sym* currsym; 					// to point to the latest function entry in the symbol table


/** GlobalST Design Pattern */
GlobalST* GlobalST::pGlobalST= NULL;	// pointer to the GST
GlobalST::GlobalST() {;}	// Constructor
GlobalST* GlobalST::getInstance() {	// to create the instance of GST
	if (pGlobalST== NULL) {		// if already not created
		pGlobalST = new GlobalST();
	}
	return pGlobalST;
}


symType::symType(etype cat, symType* ptr, int width): 
	cat (cat), 
	ptr (ptr), 
	width (width) {};
	sym* symtab::lookup(string n){
		sym* s;
		list <sym>::iterator it;
		it = table.begin();

		while(it != table.end()){
			if(it->name == n)
				break;
			it++;
		}

		if(it!=table.end())
			return &*it;
		else {
			s =  new sym (n);
			s->category = "local";
			table.push_back (*s);
			return &table.back();
		}
	}


sym* gentemp (etype t, string init) {
	char n[5];
	sprintf(n, "t%02d", table->tcount++);
	sym* s = new sym (n, t);
	s->category = "temp";
	s-> init = init;
	table->table.push_back(*s);
	return &table->table.back();
}


sym* gentemp (symType* t, string init) {
	char n[5];
	sprintf(n, "t%02d", table->tcount++);
	sym* s = new sym (n);
	s->type = t;
	s->category = "temp";
	s-> init = init;
	table->table.push_back (*s);
	return &table->table.back();
}


symtab::symtab (string name): tname(name), tcount(0){;}


void symtab::print(int all) {
	list<symtab*> tablelist;
	cout << setw(100) << setfill ('+') << "+"<< endl;
	cout << "Symbol Table:- " << setfill (' ') << left << setw(40)  << this -> tname ;
	cout << right << setw(20) << "Parent:- ";

	if (this->parent!=NULL)
		cout << this->parent->tname;
	else 
		cout << "null" ;

	cout << endl;
	cout << setw(100) << setfill ('+') << "+"<< endl;
	cout << setfill (' ') << left << setw(16) << "Name";
	cout << left << setw(14) << "Type";
	cout << left << setw(12) << "Category";
	cout << left << setw(12) << "Init Val";	
	cout << left << setw(8) << "Size";
	cout << left << setw(10) << "Offset";
	cout << left << "Nested table" << endl;
	cout << setw(100) << setfill ('=') << "="<< setfill (' ') << endl;
	
	list <sym>::iterator it = table.begin();
	while(it != table.end()){
		cout << &*it;
		if (it->nest!=NULL)
			tablelist.push_back(it->nest);
		it++;
	}

	cout << setw(100) << setfill ('-') << "-"<< setfill (' ') << endl;
	cout << endl;

	if(all){
		list <symtab*>::iterator it = tablelist.begin();
		while(it != tablelist.end()){
			(*it)->print();
			it++;
		}		
	}
}


void symtab::computeOffsets() {
	list<symtab*> tablelist;
	int off;

	list <sym>::iterator it = table.begin();
	while(it!=table.end()){
		if (it==table.begin()) {
			it->offset = 0;
			off = it->size;
		}
		else {
			it->offset = off;
			off = it->offset + it->size;
		}
		if (it->nest!=NULL)
			tablelist.push_back(it->nest);	
		it++;
	}

	list<symtab*>::iterator iter = tablelist.begin();
	while(iter != tablelist.end()){
		(*iter)->computeOffsets();
		++iter;
	}
}


sym* sym::linkst(symtab* t) {
	this->nest = t;
	this->category = "function";
}


int sizeOfType (symType* t)
{
	switch(t->cat){
		case VOID:		return 0;
						break;
		case CHAR:		return char_size;
						break;
		case INT:		return int_size;
						break;
		case DOUBLE:	return double_size;
						break;
		case PTR:		return pointer_size;
						break;
		case ARR:		return t->width*sizeOfType(t->ptr);
						break;
		case FUNC:		return 0;
						break;

	}
}


ostream& operator<<(ostream& os, const symType* t) {
	etype cat = t->cat;
	string stype = conv2string(t);
	os << stype;
	return os;
}


ostream& operator<<(ostream& os, const sym* it) {
	os << left << setw(16) << it->name;
	os << left << setw(14) << it->type;
	os << left << setw(12) << it->category;
	os << left << setw(12) << it->init;
	os << left << setw(8) << it->size;	
	os << left << setw(10) << it->offset;
	os << left;

	if(it->nest == NULL)
		os << "null" << endl;
	else
		os << it->nest->tname << endl;

	return os;
}


quad::quad (string result, string arg1, optype op, string arg2):
	result (result), arg1(arg1), arg2(arg2), op (op){;};


quad::quad (string result, int arg1, optype op, string arg2):
	result(result), arg2(arg2), op (op){
		this ->arg1 = number2string(arg1);
	}

sym::sym(string name, etype t, symType* ptr, int width): name(name){
	type = new symType (symType(t, ptr, width));
	nest = NULL;
	init = "";
	category = "";
	offset = 0;
	size = sizeOfType(type);
}


sym* sym::initialize(string init){
	this->init = init;
}


sym* sym::update(symType* t){
	type = t;
	this -> size = sizeOfType(t);
	return this;
}


sym* sym::update(etype t) {
	this->type = new symType(t);
	this->size = sizeOfType(this->type);
	return this;
}


void quad::update (int addr){
	this ->result = addr;
}


void quad::print(){
	switch(op) {
		case ADD:		cout << result << " = " << arg1 << " + " << arg2;				
						break;
		case SUB:		cout << result << " = " << arg1 << " - " << arg2;				
						break;
		case MULT:		cout << result << " = " << arg1 << " * " << arg2;				
						break;
		case DIVIDE:	cout << result << " = " << arg1 << " / " << arg2;				
						break;
		case MODOP:		cout << result << " = " << arg1 << " % " << arg2;				
						break;
		case XOR:		cout << result << " = " << arg1 << " ^ " << arg2;				
						break;
		case INOR:		cout << result << " = " << arg1 << " | " << arg2;				
						break;
		case BAND:		cout << result << " = " << arg1 << " & " << arg2;				
						break;
		case LEFTOP:	cout << result << " = " << arg1 << " << " << arg2;				
						break;
		case RIGHTOP:	cout << result << " = " << arg1 << " >> " << arg2;				
						break;
		case EQUAL:		cout << result << " = " << arg1 ;								
						break;
		case EQOP:		cout << "if " << arg1 <<  "==" << arg2 << " goto " << result;			
						break;
		case NEOP:		cout << "if " << arg1 <<  "!=" << arg2 << " goto " << result;				
						break;
		case LT:		cout << "if " << arg1 <<  "<"  << arg2 << " goto " << result;				
						break;
		case GT:		cout << "if " << arg1 <<  ">"  << arg2 << " goto " << result;				
						break;
		case GE:		cout << "if " << arg1 <<  ">=" << arg2 << " goto " << result;				
						break;
		case LE:		cout << "if " << arg1 <<  "<=" << arg2 << " goto " << result;				
						break;
		case GOTO:		cout << "goto " << result;						
						break;
		case ADDRESS:	cout << result << " = &" << arg1;				
						break;
		case PTRR:		cout << result	<< " = *" << arg1 ;				
						break;
		case PTRL:		cout << "*" << result	<< " = " << arg1 ;		
						break;
		case UMINUS:	cout << result 	<< " = -" << arg1;				
						break;
		case BNOT:		cout << result 	<< " = ~" << arg1;				
						break;
		case LNOT:		cout << result 	<< " = !" << arg1;				
						break;
		case ARRR:	 	cout << result << " = " << arg1 << "[" << arg2 << "]";			
						break;
		case ARRL:	 	cout << result << "[" << arg1 << "]" <<" = " <<  arg2;			
						break;
		case RETURN: 	cout << "ret " << result;				
						break;
		case PARAM: 	cout << "param " << result;				
						break;
		case CALL: 		cout << result << " = " << "call " << arg1<< ", " << arg2;				
						break;
		case LABEL:		cout << result << ": ";					
						break;
		default:		cout << "op";							
						break;
	}
	cout << endl;
}


void quads::printtab() {
	cout << "**** Quad Table ****" << endl;
	cout << setw(8) << "index";
	cout << setw(8) << " op";
	cout << setw(8) << "arg 1";
	cout << setw(8) << "arg 2";
	cout << setw(8) << "result" << endl;
	for (vector<quad>::iterator itr = array.begin(); itr!=array.end(); itr++) {
		cout << left << setw(8) << itr - array.begin(); 
		cout << left << setw(8) << op2str(itr->op);
		cout << left << setw(8) << itr->arg1;
		cout << left << setw(8) << itr->arg2;
		cout << left << setw(8) << itr->result << endl;
	}
}


void backpatch(list <int> l, int addr){
	list<int>::iterator it= l.begin();
	while(it!=l.end()){
		qarr.array[*it].result = tostr(addr);
		++it;
	}
}


void quads::print () {
	cout << setw(50) << setfill ('+') << "+"<< endl;
	cout << "\t Quad Translation" << endl;
	cout << setw(50) << setfill ('+') << "+"<< setfill (' ') << endl;

	vector<quad>::iterator it = array.begin();
	while(it != array.end()){
		if(it->op != LABEL){
			cout << "\t" << setw(3) << it-array.begin() << ":   ";
			it->print();
		}
		else{
			cout << "\n";
			it->print();
			cout << "\n";
		}
		++it;
	}
	cout << setw(50) << setfill ('-') << "-"<< endl;
}


void emit(optype op, string result, string arg1, string arg2) {
	qarr.array.push_back(*(new quad(result,arg1,op,arg2)));
}


void emit(optype op, string result, int arg1, string arg2) {
	qarr.array.push_back(*(new quad(result,arg1,op,arg2)));
}


string conv2string (const symType* t){
	if (t==NULL) 
		return "null";
	switch (t->cat) {
		case VOID:		return "void";
						break;
		case CHAR:		return "char"; 
						break;
		case INT:		return "int"; 
						break;
		case DOUBLE:	return "double"; 
						break;
		case PTR:		return "ptr("+conv2string(t->ptr)+")"; 
						break;
		case ARR:		return "arr("+tostr(t->width)+", "+conv2string(t->ptr)+")"; 
						break;
		case FUNC:		return "funct"; 
						break;
		default:		return "type"; 
						break;
	}
}


string op2str (int op) {
	switch(op) {
		case ADD:				return " + ";
		case SUB:				return " - ";
		case MULT:				return " * ";
		case DIVIDE:			return " / ";
		case EQUAL:				return " = ";
		case EQOP:				return " == ";
		case NEOP:				return " != ";
		case LT:				return " < ";
		case GT:				return " > ";
		case GE:				return " >= ";
		case LE:				return " <= ";
		case GOTO:				return " goto ";
		case ADDRESS:			return " &";
		case PTRR:				return " *R";
		case PTRL:				return " *L";
		case UMINUS:			return " -";
		case BNOT:				return " ~";
		case LNOT:				return " !";
		case ARRR:	 			return " =[]R";
		case RETURN: 			return " ret";
		case PARAM: 			return " param ";
		case CALL: 				return " call ";
		default:				return " op ";
	}
}


list<int> makelist(int i){
	list<int> l(1,i);
	return l;
}


list<int> merge(list<int> &a, list <int> &b){
	a.merge(b);
	return a;
}


int nextinstr(){
	return qarr.array.size();
}


string number2string(int Number){
	ostringstream ss;
	ss << Number;
	return ss.str();
}


expr* conv2bool(expr* ex){
	if (!ex->isbool) {
		ex->falselist = makelist (nextinstr());
		emit(EQOP, "", ex->symp->name, "0");
		ex->truelist = makelist (nextinstr());
		emit(GOTO, "");
	}
}


expr* convfrombool(expr* ex){
	if (ex->isbool) {
		ex->symp = gentemp(INT);
		backpatch(ex->truelist, nextinstr());
		emit(EQUAL, ex->symp->name, "true");
		emit(GOTO, tostr (nextinstr()+1));
		backpatch(ex->falselist, nextinstr());
		emit(EQUAL, ex->symp->name, "false");
	}
}


bool typecheck(sym*& s1, sym*& s2){
	symType* type1 = s1->type;
	symType* type2 = s2->type;
	if(typecheck(type1, type2))
		return true;
	else if(s1 = conv(s1, type2->cat)) 
		return true;
	else if(s2 = conv(s2, type1->cat)) 
		return true;
	return false;
}


bool typecheck(symType* t1, symType* t2){
	if(t1==NULL || t2==NULL) 
		return false;

	if(t1->cat==t2->cat) 
		return typecheck(t1->ptr, t2->ptr);
	else 
		return false;

	return true;
}


sym* conv (sym* s, etype t) {
	sym* temp = gentemp(t);

	if(s->type->cat == INT && t==DOUBLE){
		emit(EQUAL, temp->name, "int2double(" + s->name + ")");
		return temp;
	}

	if(s->type->cat == INT && t==CHAR){
		emit(EQUAL, temp->name, "int2char(" + s->name + ")");
		return temp;
	}

	if(s->type->cat == DOUBLE && t==INT){
		emit(EQUAL, temp->name, "double2int(" + s->name + ")");
		return temp;
	}

	if(s->type->cat == DOUBLE && t==CHAR){
		emit(EQUAL, temp->name, "double2char(" + s->name + ")");
		return temp;
	}	

	if(s->type->cat == CHAR && t==INT){
		emit(EQUAL, temp->name, "char2int(" + s->name + ")");
		return temp;
	}

	if(s->type->cat == CHAR && t==DOUBLE){
		emit(EQUAL, temp->name, "char2double(" + s->name + ")");
		return temp;
	}

	return s;
}


void changeTable(symtab* newtable){
	table = newtable;
} 


int  main (int argc, char* argv[]){
	globalTable = new symtab("Global");
	table = globalTable;
	yyparse();
	table->computeOffsets();
	table->print(1);
	qarr.print();
	int n, x;
	cin >> n;
	if(n==10){
		while(n--){
			cin >> x;
			if(x==1)
				gentemp(DOUBLE);
			else if(x==2)
				emit(ADD, "a", "b", "c");
		}	
	}
}
