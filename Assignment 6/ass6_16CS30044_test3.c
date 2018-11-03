int printInt(int num);
int printStr(char * c);
int readInt(int *eP);


int fibo(int n)
{
    if(n == 0) return 0;
    else if(n==1) return 1;
    else return fibo(n-1) + fibo(n-2);
}

int main()
{
    printStr("Lets compute the fibonacci series!!\n Enter a number(<=45): ");
    int a, c, *err;
    err= &c;
    a = readInt(&err);
    int small=0,large=1,i=1,temp;
    for(i=1;i<a+1;i++)
    {
        temp=large;
        large=small+large;
        small=temp;
        printInt(large);
        printStr(" ");
    }
    printStr("\n");
    return 0;
}
