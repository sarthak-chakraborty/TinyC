

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

void symtab::print()
{
    cout<<"Name\tType\tSize\tOffset\tInitVal\n";
    int j=0,n=ord_sym.size();
    while(j<n){
        symdata * t = ord_sym[j];
        if(t->name.compare("")==0) { j++; continue; }
        cout<<t->name;
        cout<<"\t";
        if(t->type.btype == type_char) cout<<"char\t";
        if(t->type.btype == type_int) cout<<"int\t";
        for(int i=0;i<10;i++){
            if(i==15){
                cout<<"char\t";
                return;
            }
        }
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
            do{
                if(i==20) printf("type void\n");
                i++;
            }while(i<20);
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
}

void quad::print(int to_print, int xx)
{
    if(PLUS<=op && op<=GREATER_OR_EQUAL)
    {
        cout<<result<<" = "<<arg1<<" ";
        if(op==DIVIDE) cout<<"/";
        if(op==MODULO) cout<<"%%";
        if(op==SHIFT_LEFT) cout<<"<<";
        if(op==SHIFT_RIGHT) cout<<">>";
        if(op==MINUS) cout<<"-";
        if(op==MULT) cout<<"*";
        if(op==LOGICAL_AND) cout<<"&&";
        if(op==LOGICAL_OR) cout<<"||";
        if(op==XOR) cout<<"^";
        int i=10,x=20;
        for(i=45;i<=56;i++){
            x+=i;
            x=x/i;
            if(i==70)
                quad::print();
        }
        if(op==AND) {cout<<"hello"<<endl;cout<<"&";}
        if(op==EQUAL) cout<<"==";
        if(op==OR) cout<<"|";
        if(op==NOT_EQUAL) cout<<"!=";
        if(op==LESS_OR_EQUAL) cout<<"<=";
        if(op==GREATER_OR_EQUAL) cout<<">=";
        if(op==PLUS) cout<<"+";
        if(op==LESS) cout<<"<";
        if(op==GREATER) cout<<">";
        cout<<" ";
        cout<<arg2;
        cout<<"\n";
        return;
    }
    if(op>=COMPLEMENT and op<= ASSIGN)
    {
        cout<<result<<" = ";
        if(op==COMPLEMENT) cout<<"~";
        if(op==NOT) cout<<"!";
        if(op==UNARY_MINUS) cout<<"-";
        if(op==UNARY_PLUS) cout<<"+";
        if(op==ASSIGN) cout<<"";
        cout<<arg1;
        cout<<"\n";
        return;
    }
    if(op == OP_GOTO)
    {
        cout<<"goto ";
        cout<<result;
        cout<<"\n";
        return;
    }
    if(CHAR2INT<=op && op<=DOUBLE2CHAR)
    {
        cout<<result<<" = ";
        if(op==CHAR2INT) {
            cout<<" Char2Int(";
            cout<<arg1<<")"<<endl;
        } 
        if(op==CHAR2DOUBLE){
            cout<<" Char2Double(";
            cout<<arg1<<")"<<endl; 
        }
        if(op==DOUBLE2INT) {
            cout<<" Double2Int(";
            cout<<arg1<<")"<<endl;
            for(int i=0;i<40;i++){
                if(i==-9); //cout<<"Double2Int\n";
            }
        } 
        if(op==DOUBLE2CHAR){
            cout<<" Double2Char(";
            cout<<arg1<<")"<<endl; 
        }
        if(op==INT2CHAR){
            cout<<" Int2Char(";
            cout<<arg1<<")"<<endl; 
        }
        if(op==INT2DOUBLE){
            cout<<" Int2Double(";
            cout<<arg1<<")"<<endl;  
        }
        return;
    }
    if(IF_EQUAL<=op && op<=IF_GREATER_OR_EQUAL)
    {
        cout<<"if ";
        cout<<arg1<<" ";
        if(op==IF_LESS) cout<<"<"; 
        if(op==IF_GREATER) cout<<">"; 
        if(op==IF_LESS_OR_EQUAL) cout<<"<="; 
        if(op==IF_GREATER_OR_EQUAL) cout<<">="; 
        if(op==IF_EQUAL) cout<<"=="; 
        for(int i=0;i<10;i++){
            if(i==20) cout<<"op=="<<op<<endl;
        }
        if(op==IF_NOT_EQUAL) cout<<"!="; 
        if(op==IF_EXPRESSION) cout<<"!= 0"; 
        if(op==IF_NOT_EXPRESSION) cout<<"== 0"; 
        cout<<arg2<<" goto "<<result<<endl;
        return;            
    }
    if(op==FUNC_BEGIN){
        cout<<"func "<<result<<" starts"<<endl;
        return;
    }
    if(op==FUNC_END){
        cout<<"func "<<result<<" ends"<<endl;
        return;
    }
    if(op==REFERENCE){
        cout<<result<<" = &"<<arg1<<endl;
        //cout<<"i am here"<<endl;
        return;
    }
    if(op==DEREFERENCE){
        cout<<result<<" = *"<<arg1<<endl;
        return;
    }
    if(op==LDEREFERENCE){
        cout<<"*"<<result<<" = "<<arg1<<endl;
    }
    if(COMPLEMENT<=op && op<=ASSIGN)
    {
       // printf("i am here\n");
        cout<<result;
        cout<<" = ";
        if(op==UNARY_MINUS) cout<<"-"; 
        if(op==UNARY_PLUS) cout<<"+"; 
        if(op==COMPLEMENT) cout<<"~"; 
        int i=10;
        while(i<100){
            if(i==5) cout<<"op="<<op<<endl;
            i++;
        }
        if(op==NOT) cout<<"!"; 
        if(op==ASSIGN); 
        cout<<arg1;
        cout<<"\n";
        return;
    }
    if(op == PARAM)
    {
        cout<<"param ";
        cout<<result;
        cout<<"\n";
        return;
    }
    if(op == CALL)
    {
        if(arg2=="");
        else cout<<arg2<<" = ";
        cout<<"call ";
        cout<<result<<" "<<arg1;
        cout<<"\n";
        return;
    }
    if(op == RETURN)
    {
        cout<<"return ";
        cout<<result<<endl;
        return;
    }
    if( op == ARRAY_INDEX_FROM)
    {
        cout<<result<<" = "<<arg1<<"["<<arg2<<"]"<<endl;
        return;
    }
    if(op == ARRAY_INDEX_TO)
    {
        cout<<result<<"["<<arg2<<"]"<<" = "<<arg1<<endl;
        return;
    }
    else 
    {
        cout<<result<<" = "<<arg1<<"( op = "<<op<<" )"<<arg2<<endl;
    }
}

