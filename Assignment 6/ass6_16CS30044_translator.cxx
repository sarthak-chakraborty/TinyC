

#include "ass6_16CS30044_translator.h"

void get(string x)
{   
    cout<<"....."<<x<<"....."<<endl;
}

void quadarray::emit(string res, string arg1, opcode op, string arg2, string error)
{
    quad temp;
    temp.op=op;
    temp.arg1=arg1;
    temp.arg2=arg2;
    temp.result=res;
    array.push_back(temp);
    nextinstr++;
}

void quadarray::emit(string res, int c, opcode unary_op, pair<int,int> pi)
{
    quad temp;
    temp.op = unary_op;
    temp.result = res;
    stringstream ss; 
    ss<<c;
    ss>>temp.arg1;
    array.push_back(temp); 
    nextinstr=nextinstr+1;
}

void quadarray::emit(string res, char c, opcode unary_op)
{
    quad temp;
    temp.op = unary_op;
    temp.result = res;
    stringstream ss; 
    ss<<c;
    ss>>temp.arg1;
    array.push_back(temp); 
    nextinstr=nextinstr+1;
}

void quadarray::emit(string res, double d, opcode unary_op, double xy)
{
    quad temp;
    temp.op = unary_op;
    temp.result = res;
    stringstream ss;
    ss<<d;
    ss>>temp.arg1;
    array.push_back(temp);
    nextinstr=nextinstr+1;
}

void quadarray::backpatch(list<int> a, int index, int index2)
{
    stringstream ss; 
    ss<<index;
    for(list<int>::iterator it=a.begin(); it!= a.end(); it++)
        ss>>array[*it].result;
}

list<int> makelist(int index)
{
    list<int> ret;
    ret.push_back(index);
    return ret;
}

list<int> merge(list<int> a, list<int> b, int n)
{
    a.merge(b);
    return a;
}


void symtab::print()
{
    cout << setw(50) << setfill ('+') << "+"<< endl;
    cout<<"Name\tType\tSize\tOffset\tInitVal\n";
    int j=0,n=ord_sym.size();
    while(j<n){
        symdata * t = ord_sym[j];
        if(t->name.compare("")==0) { j++; continue; }
        cout<<t->name;
        cout<<"\t";
        if(t->type.btype == type_char) cout<<"char\t";
        if(t->type.btype == type_int) cout<<"int\t";
        if(t->type.btype == type_double) cout<<"double\t";
        if(t->type.btype == type_function) cout<<"function ";
        else 
        {
            if(t->type.base_t == type_char) cout<<"char ";
            if(t->type.base_t == type_int) cout<<"int ";
            if(t->type.base_t == type_double) cout<<"double ";
        }
        if(t->type.btype == type_ptr)
        {
            int i=0;
            for(i=0;i<20;i++);
            if(i==100){
                cout<<"type int\n";
            }
            else if(i==99){
                cout<<"type double\n";
            }
            for(int i= 0;i<t->type.pc;i++) 
                cout<<"*";
            cout<<"\t";
        }
        if(t->type.btype == type_array)
        {
            vector<int> tmp =  t->type.alist;
            int sz = tmp.size();
            for(int i = 0; i<sz; i++) 
                cout<<tmp[i];
            int i=10;
        }        
        if(t->size==1)
            cout<<4<<"\t"<<t->offset<<"\t";
        else cout<<t->size<<"\t"<<t->offset<<"\t";
        if(t->init_val == NULL ) cout<<"NULL";
        else
        {
            if(t->type.btype == type_char) cout<<t->init_val->cval;
            if(t->type.btype == type_int) cout<<t->init_val->ival;
            if(t->type.btype == type_double) cout<<t->init_val->dval;
        }
        cout<<endl;

        j++;
    }
    cout << setw(50) << setfill ('-') << "-"<< setfill (' ') << endl;
}

void quad::print(int to_print, int xx)
{   

    switch(op){
        case DIVIDE:    cout << result << " = " << arg1 << " " << "/" << cout << " " << arg2 << "\n";
                        break;
        case MODULO:    cout << result << " = " << arg1 << " " << "%" << cout << " " << arg2 << "\n";
                        break;
        case SHIFT_LEFT:    cout << result << " = " << arg1 << " " << "<<" << cout << " " << arg2 << "\n";
                            break;
        case SHIFT_RIGHT:   cout << result << " = " << arg1 << " " << ">>" << cout << " " << arg2 << "\n";
                            break;
        case MINUS:     cout << result << " = " << arg1 << " " << "-" << cout << " " << arg2 << "\n";
                        break;
        case MULT:      cout << result << " = " << arg1 << " " << "*" << cout << " " << arg2 << "\n";
                        break;
        case LOGICAL_AND:   cout << result << " = " << arg1 << " " << "&&" << cout << " " << arg2 << "\n";
                            break;
        case LOGICAL_OR:    cout << result << " = " << arg1 << " " << "||" << cout << " " << arg2 << "\n";
                            break;
        case XOR:       cout << result << " = " << arg1 << " " << "^" << cout << " " << arg2 << "\n";
                        break;
        case AND:       cout << result << " = " << arg1 << " " << "&" << cout << " " << arg2 << "\n";
                        break;
        case EQUAL:     cout << result << " = " << arg1 << " " << "==" << cout << " " << arg2 << "\n";
                        break;
        case OR:        cout << result << " = " << arg1 << " " << "|" << cout << " " << arg2 << "\n";
                        break;
        case NOT_EQUAL: cout << result << " = " << arg1 << " " << "! =" << cout << " " << arg2 << "\n";
                        break;
        case LESS_OR_EQUAL: cout << result << " = " << arg1 << " " << "< =" << cout << " " << arg2 << "\n";
                            break;
        case GREATER_OR_EQUAL:   cout << result << " = " << arg1 << " " << "> =" << cout << " " << arg2 << "\n";
                                break;
        case PLUS:      cout << result << " = " << arg1 << " " << "+" << cout << " " << arg2 << "\n";
                        break;
        case LESS:      cout << result << " = " << arg1 << " " << "<" << cout << " " << arg2 << "\n";
                        break;
        case GREATER:   cout << result << " = " << arg1 << " " << ">" << cout << " " << arg2 << "\n";
                        break;
        case COMPLEMENT:    cout << result << " = " << arg1 << " " << "~" << cout << " " << arg2 << "\n";
                            break;
        case NOT:           cout << result << " = " << arg1 << " " << "!" << cout << " " << arg2 << "\n";
                            break;
        case UNARY_MINUS:   cout << result << " = " << arg1 << " " << "-" << cout << " " << arg2 << "\n";
                            break;
        case UNARY_PLUS:    cout << result << " = " << arg1 << " " << "+" << cout << " " << arg2 << "\n";
                            break;
        case ASSIGN:    cout << result << " = " << arg1 << " " << "" << cout << " " << arg2 << "\n";
                        break;
        case OP_GOTO:   cout << "goto " << result << "\n";
                        break;
        case CHAR2INT:  cout << result << " = Char2Int(" << arg1 << ")\n";
                        break;
        case CHAR2DOUBLE:   cout << result << " = Char2Double(" << arg1 << ")\n";
                            break;
        case DOUBLE2INT:    cout << result << " = Double2Int(" << arg1 << ")\n";
                            break;
        case DOUBLE2CHAR:   cout << result << " = Double2Char(" << arg1 << ")\n";
                            break;
        case INT2CHAR:      cout << result << " = Int2Char(" << arg1 << ")\n";
                            break;
        case INT2DOUBLE:    cout << result << " = Int2Double(" << arg1 << ")\n";
                            break;
        case IF_LESS:       cout << "if " << arg1 << "< " << arg2 << " goto " << result << endl;
                            break;
        case IF_GREATER:    cout << "if " << arg1 << "> " << arg2 << " goto " << result << endl;
                            break;
        case IF_LESS_OR_EQUAL:  cout << "if " << arg1 << "< = " << arg2 << " goto " << result << endl;
                                break;
        case IF_GREATER_OR_EQUAL:   cout << "if " << arg1 << "> = " << arg2 << " goto " << result << endl;
                                    break;
        case IF_EQUAL:          cout << "if " << arg1 << "== " << arg2 << " goto " << result << endl;
                                break;
        case IF_NOT_EQUAL:      cout << "if " << arg1 << "! = " << arg2 << " goto " << result << endl;
                                break;
        case IF_EXPRESSION:     cout << "if " << arg1 << "!= 0 " << arg2 << " goto " << result << endl;
                                break;
        case IF_NOT_EXPRESSION: cout << "if " << arg1 << "== 0 " << arg2 << " goto " << result << endl;
                                break;
        case FUNC_BEGIN:    cout << "func " << result << " starts" << endl;
                            break;
        case FUNC_END:      cout << "func " << result << " ends" << endl;
                            break;
        case REFERENCE:     cout << result << " = &" << arg1 << endl;
                            break;
        case DEREFERENCE:   cout << result << " = *" << arg1 << endl;
                            break;
        case LDEREFERENCE:  cout << "*" << result << " = " << arg1 << endl;
                            break;
        case PARAM:         cout << "param " << result << endl;
                            break;
        case CALL:          {if(arg2=="");
                            else cout << arg2 << " = " << "call " << result << " " << arg1 << endl;
                            break;}
        case RETURN:        cout << "return " << result << endl;
                            break;
        case ARRAY_INDEX_FROM:  cout << result << " = " << arg1 << "[" << arg2 << "]" << endl;
                                break;
        case ARRAY_INDEX_TO:    cout << result << "[" << arg2 << "]" << " = " << arg1 << endl;
                                break;
        default:    cout << result << " = " << arg1 << "( op = " << op << " )" << arg2 << endl;
                    break;
    }
}


void quadarray::convInt2Bool(expression_type* res, int x, int error)
{
    if(res->btype==type_int){
        res->falselist = makelist(nextinstr);
        emit("",res->loc,IF_NOT_EXPRESSION,"");
        emit(res->loc,"~1",ASSIGN,"");
        res->truelist = makelist(nextinstr);
        emit("","",OP_GOTO,""); 
        res->btype = type_bool;
    }
    return;
}

void quadarray::conv2type(expression_type* t, expression_type *res, basic_type bt, int error)
{
    if(res->btype == bt)
        return;
    switch(res->btype){
        case type_double: if(bt != type_char) 
                            emit(t->loc,res->loc,DOUBLE2INT,"");
                          else emit(t->loc,res->loc,DOUBLE2CHAR,"");
                          break;

        case type_int: if(bt != type_char)
                            emit(t->loc,res->loc,INT2DOUBLE,"");
                       else emit(t->loc,res->loc,INT2CHAR,"");
                       break;

        case type_char: if(bt != type_int)
                            emit(t->loc,res->loc,CHAR2DOUBLE,"");
                        else emit(t->loc,res->loc,CHAR2INT,"");
                        break;
    }

}

void quadarray::conv2type(string t, basic_type bt, string f, basic_type from, int error)
{
    if(from == bt) return;

    switch(from){
        case type_double: if(bt == type_int)
                            emit(t,f,DOUBLE2INT,"");
                          else emit(t,f,DOUBLE2CHAR,"");
                          break;

        case type_int: if(bt == type_double)
                            emit(t,f,INT2DOUBLE,"");
                       else emit(t,f,INT2CHAR,"");
                       break;

        case type_char: if(bt == type_double) 
                            emit(t,f,CHAR2DOUBLE,"");
                        else emit(t,f,CHAR2INT,"");
                        break;

    }

    return;

}

string symtab::gentemp(int xy, basic_type bt)
{
    static int count=0;
    stringstream ss;
    ss<<"t"<<count++;
    string ret;
    ss>>ret;
    _symtab[ret] = new symdata; 
    ord_sym.push_back(_symtab[ret]);
    _symtab[ret]->name = ret;
    _symtab[ret]->type.btype = bt;
    _symtab[ret]->offset = offset;
    int zz = 0;
    if(bt == type_char) zz = SIZE_CHAR;
    if(bt == type_int)  zz = SIZE_INT;    
    if(bt == type_double)  zz = SIZE_DOUBLE;
    if(bt == type_function) zz=0;
    if(bt == type_void) zz = 0;
    _symtab[ret]->size = zz;
    _symtab[ret]->init_val = NULL;
    offset += zz;
    return ret;
}

string symtab::gentemp(basic_type bt)
{
    static int count=0;
    stringstream ss;
    ss<<"t"<<count++;
    string ret;
    ss>>ret;
    _symtab[ret] = new symdata; 
    ord_sym.push_back(_symtab[ret]);
    _symtab[ret]->name = ret;
    _symtab[ret]->type.btype = bt;
    _symtab[ret]->offset = offset;
    int zz = 0;
    if(bt == type_char) zz = SIZE_CHAR;
    if(bt == type_int)  zz = SIZE_INT;    
    if(bt == type_double)  zz = SIZE_DOUBLE;
    if(bt == type_function) zz=0;
    if(bt == type_void) zz = 0;
    _symtab[ret]->size = zz;
    _symtab[ret]->init_val = NULL;
    offset += zz;
    return ret;
}

symdata* symtab::justlookup(string var)
{
    if(!_symtab.count(var)) return NULL;
        return _symtab[var];
}

symdata* symtab::lookup(string var, basic_type bt, int pc, int xyz)
{
    if(!_symtab.count(var))
    {
        _symtab[var] = new symdata; 
        ord_sym.push_back(_symtab[var]);
        _symtab[var]->offset = offset;        
        _symtab[var]->type.btype = bt;
        _symtab[var]->name = var;
        int zz = 0;
        if(pc){
            zz = SIZE_PTR;
            _symtab[var]->type.base_t = bt;        
            _symtab[var]->type.pc = pc;
            _symtab[var]->type.btype = type_array;
        }
        else{
            if(bt == type_char)zz = SIZE_CHAR;
            if(bt == type_int)zz = SIZE_INT;    
            if(bt == type_double)zz = SIZE_DOUBLE;
            if(bt == type_function)zz = 0;
            if(bt==type_void) zz=0;
        }
        _symtab[var]->size = zz;
        _symtab[var]->init_val = NULL;
        offset += zz;
    }
    return _symtab[var];
}


