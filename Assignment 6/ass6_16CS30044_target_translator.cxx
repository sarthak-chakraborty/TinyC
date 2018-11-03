#include "ass6_16CS30044_translator.h"
#include <iostream>
#include <cstring>
#include <string>

extern vector<string> stringnames;
extern quadarray qar;
extern symtab symtabvar;
extern symtab *ST;
string current_function="";
int number_block=100;


void prologue(int num)
{
    int a= num/16;
    a = (a+1)*16;
    cout << "\t.globl\t"<<current_function<<endl;
    cout << "\t.type\t"<<current_function<<", @function"<<endl;
    cout << current_function << ":" << endl;
    cout << "\t" << "pushq\t%rbp"<<endl;
    cout << "\t" << "movq\t%rsp,\t%rbp"<<endl;
    cout << "\t" << "subq\t$"<<a<<",\t%rsp"<<endl;
}

void stringmapping()
{
    cout << "\t.section\t.rodata"<<endl;
    vector<string>:: iterator it=stringnames.begin();
    int number=0;
    while(it!=stringnames.end())
    {
        cout << ".LC"<<number<< ":"<<endl; 
        cout << "\t.string "<<*it<<endl;
        number++;
        it++;
    }
}

void globalmapping()
{
    for(vector<symdata*>::iterator it=(symtabvar.ord_sym).begin(); it!=(symtabvar.ord_sym).end(); it++){
        if((*it)->type.btype==type_int && (*it)->name[0]!='t')
        {              
            if((*it)->init_val==NULL)
            {                
                cout << "\t.comm\t"<<(*it)->name<<",4,4"<<endl;
            }
            else 
            {
                cout << "\t.globl\t"<<(*it)->name<<endl;
                cout << "\t.data"<<endl;
                cout << "\t.align 4"<<endl;
                cout << "\t.type\t"<<(*it)->name<<", @object"<<endl;
                cout << "\t.size\t"<<(*it)->name<<", 4"<<endl;
                cout << (*it)->name<< ":" << endl;
                cout << "\t.long\t"<< (*it)->init_val->ival << endl;
            }
        }
        if((*it)->type.btype==type_char && (*it)->name[0]!='t')
        {              
            if((*it)->init_val==NULL)
            {                
                cout << "\t.comm\t"<<(*it)->name<<",1,1"<<endl;
            }
            else
            {
                cout << "\t.globl\t"<<(*it)->name<<endl;
                cout << "\t.data"<<endl;
                cout << "\t.type\t"<<(*it)->name<<", @object"<<endl;
                cout << "\t.size\t"<<(*it)->name<<", 1"<<endl;
                cout << (*it)->name<< ":" << endl;
                cout << "\t.byte\t"<< (*it)->init_val->cval << endl;
            }
        } 
    }
}

void code_for_quad(quad q);


void gencode(int abc, double xyz)
{
    globalmapping();
    stringmapping();
    cout<<"\t.text\n";
    symdata* function_pointer = NULL;
    symtab* symTab_pointer = NULL;
    map<int,string> mp;
    int labelcnt=0;
    vector<quad>::iterator it=qar.array.begin();
    while(it!=qar.array.end())
    {
        if(it->op>=OP_GOTO && it->op<=IF_GREATER_OR_EQUAL)
        {
            int target_goto;
            stringstream ss;
            ss<<it->result;
            ss>>target_goto;
            if(!mp.count(target_goto))
            {
                string output;
                stringstream ss2;
                ss2<<".L"<<labelcnt;
                ss2>>output;
                mp[target_goto]=output;
                labelcnt++;
            }
            it->result=mp[target_goto];
        }
        it++;
    }
    int i=0,membind;
    bool param;
    for(it=qar.array.begin();it!=qar.array.end();it++,i++)
    {
        cout<<" # "; it->print();
        if(mp.count(i)){
            cout<<mp[i]<<":"<<endl;
        }
        if(it->op==FUNC_END)
        {
            ST=&(symtabvar);
            current_function="";
            cout<<"\tleave"<<endl;
            cout<<"\tret"<<endl;
            cout << "\t.size\t"<<it->result<<",\t.-"<<it->result<<endl;
            continue;
        }
        else if(it->op==FUNC_BEGIN)
        {
            i++;
            it++;
            if(it->op==FUNC_END) continue;
            else {i--; it--; }  
            function_pointer=symtabvar.justlookup(it->result);
            symTab_pointer=function_pointer->nested_symtab;
            vector<symdata*>:: iterator it2;
            param=true;
            membind=16;
            ST=symTab_pointer;
            for(it2=(symTab_pointer->ord_sym).begin(); it2!=(symTab_pointer->ord_sym).end();it2++)
            {
                if((*it2)->name!="retVal"){
                    if(!param){
                        membind-=(*it2)->size;
                        (*it2)->offset=membind;
                        //cout<<(*it2)->name<<" "<<(*it2)->offset<<endl;
                    }
                    else{
                        (*it2)->offset=membind;
                        //cout<<"line 623"<<endl;
                        if((*it2)->type.btype==type_ptr) membind+=8;
                        else  membind+=4;
                    }
                }
                else{
                    param=false;
                    membind=0;
                    (*it2)->offset=0;
                }              
            }
            if(membind>0) membind=0;
            else membind*=-1;
            current_function=it->result;
            prologue(membind);
            continue;
        }
        if(current_function!="") code_for_quad(*it);
    }
}

stack<vector<string> > parameter_stack;
void code_for_quad(quad q)
{
    if(q.op == FUNC_BEGIN)
    {
        cout<<"\t"<<q.result<<":"<<endl;
        return;
    }
    string label=q.result;
    bool string_label=(q.result[0]=='.' && q.result[1]=='L' && q.result[2]=='C');
    string printarg1="",printarg2="",printresult="";
    int arg1n=0,arg2n=0,resultn=0;
    symdata* s1=ST->lookup(q.arg1);
    symdata* s2=ST->lookup(q.arg2); 
    symdata* s3=ST->lookup(q.result);
    symdata* f1=symtabvar.justlookup(q.arg1);
    symdata* f2=symtabvar.justlookup(q.arg2); 
    symdata* f3=symtabvar.justlookup(q.result);
    if(ST==&symtabvar){
        printarg1=q.arg1;
        printresult=q.result;
        printarg2=q.arg2;
    }
    else{
        if(f1==NULL) arg1n=s1->offset;
        if(f2==NULL) arg2n=s2->offset;
        if(f3==NULL) resultn=s3->offset;
        //cout<<s1->offset<<" "<<s2->offset<<" "<<s3->offset<<endl;
        if(q.arg1[0]>='9' || q.arg1[0]<='0')
        {
            if(f1==NULL)
            {
                ostringstream convert;                
                convert<<arg1n;
                printarg1=convert.str();
                printarg1=printarg1+"(%rbp)";
            }
            else
            {
                printarg1=q.arg1;
            }
        }
        if(q.arg2[0]>='9' || q.arg2[0]<='0')
        {   
            if(f2==NULL)
            {                           
                ostringstream convert;
                convert<<arg2n;
                printarg2=convert.str();
                printarg2=printarg2+"(%rbp)";
            }
            else
            {
                printarg2=q.arg2;
            }
        }
        if(q.result[0]>='9' || q.result[0]<='0')
        {       
            if(f3==NULL)
            {                            
                ostringstream convert;
                convert<<resultn;
                printresult=convert.str();
                printresult=printresult+"(%rbp)";
            }
            else
            {
                printresult=q.result;
            }
        }
    }
    if(string_label) printresult=label;
    if(q.op==ASSIGN)
    {
        if(q.arg1[0]>='0' && q.arg1[0]<='9')
        {           
            //movl  $1, -4(%ebp)
            cout<<"\t"<<"movl"<<"\t$"<<q.arg1<<","<<"\t"<<printresult<<endl;
        }
        else
        {
            //a = bcout
            cout<<"\t"<<"movl"<<"\t"<<printarg1<<",\t%eax"<<endl; 
            cout<<"\t"<<"movl"<<"\t"<<"%eax,\t"<<printresult<<"\t"<<endl; 
        }
    }
    else if(q.op==UNARY_MINUS)
    {
        //a=-b
        //cout<<"line 722"<<endl;
        cout << "\t" << "movl" << "\t" <<printarg1<< ",\t%eax" << endl; 
        cout << "\t" << "negl\t %eax"<< endl;
        cout << "\t" << "movl" << "\t" << "%eax,\t" << printresult << "\t"  << endl; 
    }
    else if(q.op==PLUS){
        if((q.arg2.compare("1"))==0)
        {
            //b=a+1
            cout << "\t" << "movl" << "\t" <<printarg1<< "," << "\t%edx" << endl;
            cout << "\t" << "addl\t $1,\t %edx" << endl;
            cout << "\t" << "movl\t %edx,\t %eax" << endl;
            cout << "\t" << "movl \t %eax,\t"  << printresult<< endl;
        }
        else
        {
            //a=b+c
            cout << "\t" << "movl\t" <<printarg1<<",\t%edx" << endl; 
            if(q.arg2[0]>=0 && q.arg2[0]<=9)
            cout << "\t" << "movl\t$" << q.arg2 << "," << "%eax" << endl;
            else      
            cout << "\t" << "movl\t" <<printarg2 << ",\t%eax" << endl;
            cout << "\t" << "addl\t %edx,\t %eax" << endl;
            cout << "\t" << "movl\t %eax,\t"  << printresult  << endl;     
        }
    }
    else if(q.op==MINUS){
        if((q.arg2).compare("1")==0)
        {
            //b=a-1
            cout << "\t" << "movl\t" <<printarg1<< ",\t%edx" << endl;
            cout << "\t" << "subl\t $1,\t %edx" << endl;
            cout << "\t" << "movl\t %edx,\t %eax" << endl;
            cout << "\t" << "movl \t %eax,\t" << printresult<< endl;
        }
        else
        {
            //a=b-c
            cout << "\t" << "movl\t" <<printarg1<< ",\t%edx" << endl;
            cout << "\t" << "movl\t" <<printarg2 << ",\t%eax" << endl;
            cout << "\t" << "subl\t %eax,\t%edx" << endl;
            cout << "\t" << "movl\t %edx,\t%eax" << endl;
            cout << "\t" << "movl \t %eax,\t"  << printresult<< endl;       
        }                       
    }
    else if(q.op==MULT)
    {
        //a=b*c
        cout << "\t"<<"movl\t" <<printarg1 << ",\t%eax" << endl; 
        if(q.arg2[0]>='0' && q.arg2[0]<='9')
            cout << "\t" << "imull\t$" << q.arg2 << "," << "%eax" << endl;
        else cout << "\t"<<"imull\t" <<printarg2 << ",\t%eax" << endl;        
        cout << "\t"<<"movl\t %eax,\t"  << printresult<< endl;                   
    }
    else if(q.op==DIVIDE)
    {
        //a=b/c
        cout << "\t" << "movl\t" <<printarg1 << ",\t%eax" << endl;
        cout << "\t" << "cltd" << endl;
        cout << "\t" << "idivl\t"<< printarg2 << endl;
        cout << "\t" << "movl \t %eax,\t"  << printresult<< endl;      
    }
    else if(q.op==MODULO)
    {
        //a=b%c
        cout << "\t" << "movl\t" <<printarg1 << ",\t%eax" << endl;
        cout << "\t" << "cltd" << endl;
        cout << "\t" << "idivl\t"<< printarg2 << endl;
        cout << "\t" << "movl \t %edx,\t"  << printresult << endl;      
    }
    else if(q.op==OP_GOTO)
    {
        cout << "\t" << "jmp\t" <<q.result << endl;
    }
    else if(q.op==IF_LESS)
    {
        //  if a < b goto L1
        cout << "\t" << "movl\t" <<printarg1 << "," << "\t%eax" << endl;
        cout << "\t" << "cmpl\t" <<printarg2 << "," << "\t%eax" << endl;
        cout << "\t" << "jge\t" << ".L" << number_block << endl;
        cout << "\t" << "jmp\t" <<q.result << endl;
        cout << ".L" << number_block  << ":" << endl;
        number_block++;
    }
    else if(q.op==IF_GREATER)
    {
        //  if a > b goto L1
        cout << "\t" << "movl\t" <<printarg2 << "," << "\t%eax" << endl;
        cout << "\t" << "cmpl\t" << printarg1 << "," << "\t%eax" << endl;
        cout << "\t" << "jle\t" << ".L" << number_block << endl;
        cout << "\t" << "jmp\t" <<q.result << endl;
        cout << ".L" << number_block  << ":" << endl;
        number_block++;
    }
    else if(q.op==IF_EQUAL)
    {
        //if a == b goto L1
        cout << "\t" << "movl\t" <<printarg1 << "," << "\t%eax" << endl;
        cout << "\t" << "cmpl\t" <<printarg2 << "," << "\t%eax" << endl;
        cout << "\t" << "jne\t" << ".L" << number_block << endl;
        cout << "\t" << "jmp\t" <<q.result << endl;
        cout << ".L" << number_block  << ":" << endl;number_block++;
    }
    else if(q.op==IF_NOT_EQUAL)
    {
        //if a != b goto L1
        cout << "\t" << "movl\t" <<printarg1<< "," << "\t%eax" << endl;
        cout << "\t" << "cmpl\t" <<printarg2 << "," << "\t%eax" << endl;
        cout << "\t" << "je\t" << ".L" << number_block << endl;
        cout << "\t" << "jmp\t" <<q.result << endl;
        cout << ".L" << number_block  << ":" << endl;number_block++;
    }
    else if(q.op==IF_EXPRESSION)
    {  
        cout << "\t" << "cmpl\t$0,\t"<<printarg1<< endl; 
        cout << "\t" << "je\t.L"<< number_block<<endl; 
        cout << "\t" << "jmp\t"<<q.result<<endl;
        cout << ".L" <<number_block<<" : "<< endl;  
        number_block++;
    }
    else if(q.op==IF_NOT_EXPRESSION)
    {
        cout << "\t" << "cmpl\t$0,\t"<<printarg1<< endl; 
        cout << "\t" << "jne\t.L"<< number_block<<endl; 
        cout << "\t" << "jmp\t"<<q.result<<endl;
        cout << ".L" <<number_block<<" : "<< endl;  
        number_block++;     
    }
    else if(q.op==PARAM)
    {        
        stringstream ss1, ss2,ss3;
        vector<string> temp;
        //cout<<s1->type.btype<<" "<<s2->type.btype<<" "<<s3->type.btype<<endl;
        if(s3->type.btype==type_char)
        {
            ss1<<"\tmovzbl\t"<<printresult<<",%rax"<<endl;
            ss3<<"\tmovq\t%rax,%rdi"<<endl;
        }
        else if(s3->type.base_t==type_array)
        {
            ss1<<"\tleaq\t"<<printresult<<",%rax"<<endl;
            ss3<<"\tmovq\t%rax,%rdi"<<endl;
        }
        else if(printresult[0]=='.')
        {
            ss1 << "\t" << "movq\t$"<<printresult<<",\t%rdi"<< endl;
            ss2<<"\tpushq\t$"<<printresult<<endl;
            temp.push_back(ss1.str());
            temp.push_back(ss2.str());
            parameter_stack.push(temp);
            return ;
        }
        else if(q.result[0]>='0' && q.result[0]<='9')
            ss1 << "\t" << "movq\t"<<q.result<<",\t%rdi"<< endl;
        else{
            //cout<<"line 883"<<endl;
            ss1 << "\t" << "movq\t"<<printresult<<",\t%rax"<< endl;
            ss3 << "\t" << "movq\t%rax,%rdi"<<endl;            
        }
        ss2 << "\t" << "pushq\t%rax"<< endl;   
        temp.push_back(ss1.str()); 
        temp.push_back(ss3.str());
        temp.push_back(ss2.str());
        parameter_stack.push(temp);
    }
    else if(q.op==CALL)
    {
        while(parameter_stack.size())
        {
            vector<string> temp; 
            temp = parameter_stack.top();
            parameter_stack.pop();
            int tsize = temp.size();
            for(int i = 0; i<tsize; i++)
            {
                cout<<temp[i];
            }
        }
        int num;
        stringstream ss;
        ss<<q.arg1;
        ss>>num;
        num=num*8;
        cout << "\t" << "call\t"<<q.result << endl;
        cout << "\t" << "addq\t$"<<num<<",\t%rsp"<< endl;
        if(q.arg2 != "")  //# to store return value to its place 
        {
            //cout<<"return val"<<endl;
            if(s3->type.base_t==type_array || s3->type.btype==type_ptr)
                cout<<"\tleaq\t%rax,\t"<<printarg2<<endl;
            cout << "\t" << "movq\t%rax,\t"<<printarg2<< endl;
        }
    }
    else if(q.op==RETURN)
    {
        if(q.result.compare("")!=0)            
            cout << "\t" << "movq\t"<<printresult<< ",\t%rax"<< endl;
    }
    else if(q.op==ARRAY_INDEX_FROM) // R_INDEX 
    {
        //a = x[i]
        cout << "\t" << "movl\t"<<printarg2<<",\t%eax"<< endl;
        cout<<"\tcltq"<<endl;
        if(arg1n<0){
            cout << "\t" << "movl\t"<<arg1n<<"(%rbp,%rax),\t%edx"<< endl;
        }
        else{
            cout<<"\tmovq\t"<<arg1n<<"(%rbp),%rcx"<<endl;
            cout<<"\tmovl\t%edx,(%rcx,%rax)"<<endl;
        }
        cout << "\t" << "movl\t%edx,\t"<< printresult<< endl;   
    }
    else if(q.op==ARRAY_INDEX_TO) // L_INDEX
    {
        //x[i] = b
        //printf("\tmovl\t%%edx, %d(%%rbp, %%rax)\n",res->offset);
        stringstream ss4;
        ss4<<"\tmovl\t"<<printarg2<<",%eax"<<endl;
        ss4<<"\timull\t$4,"<<"%eax"<<endl;
        ss4<<"\tmovl\t%eax,"<<printarg2<<endl;
        cout << "\t" << "movl\t"<<printarg1<<",\t%eax"<< endl;
        cout << "\t" << "movl\t"<<printarg2<<",\t%edx"<< endl;
        cout<<"\tcltq"<<endl;
        if(resultn<0) cout << "\t" << "movl\t%eax,\t"<<resultn<<"(%rbp,%rdx)"<< endl;
        else{
            cout<<"\tmovq\t"<<resultn<<"(%rbp),%rcx"<<endl;
            cout<<"\tmovl\t%eax,(%rcx,%rax)"<<endl;
        }
    }
    else if(q.op==REFERENCE)
    {
        //p=&a
        cout << "\t" << "leaq\t"<<printarg1<<",\t%rax"<<endl;
        cout << "\t" << "movq\t%rax,\t"<< printresult<< endl;
    }
    else if(q.op==DEREFERENCE)
    {
        // a=*p
        //cout<<"line 935"<<endl;
        cout << "\t" << "movq\t"<<printarg1<<",\t%rax"<<endl;
        cout << "\t" << "movl\t(%rax),\t %eax"<<endl;
        cout << "\t" << "movl\t%eax,\t"<< printresult<< endl;
    }
    else if(q.op==LDEREFERENCE)
    {
        cout<<"\tmovq\t"<<printresult<<",%rax"<<endl;
        cout<<"\tmovl\t"<<printarg1<<",%edx"<<endl;
        cout<<"\tmovl\t%edx,(%rax)"<<endl;
    }
}


