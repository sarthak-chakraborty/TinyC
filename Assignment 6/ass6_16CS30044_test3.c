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
    int n1=1, n2=1, i=1, temp;
    printInt(n1);
    printStr(" ");
    printInt(n2);
    printStr(" ");

    for(i=3;i<a+1;i++)
    {
        temp=n2;
        n2=n1+n2;
        n1=temp;
        printInt(n2);
        printStr(" ");
    }
    printStr("\n");
    return 0;
}
