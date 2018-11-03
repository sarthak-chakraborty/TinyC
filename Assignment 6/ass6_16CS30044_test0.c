
int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int func(int i)
{
	return i*i;
}
int fact(int i)
{
	if(i==1)
	{
		return 1;
	}
	else
	{
		int ret=1,t=1;
		for(t=1;t<i+1;t++)
		{
			ret=ret*t;
		}
		return ret;
	}
}
int main()
{
    int a[10], arel;
    a[0] = 20;
    arel = a[0] + 30;
    a[0] = arel;
    a[1] = a[0];
    //arel=a[0]+a[1];
    printInt(a[1]);
    int i=0,x=1;
    int t=1,ans=1;
    for(i=1;i<10;i++)
    {
    	x=x*i;
    }
    int *ep;
    printStr("Enter an integer to find its square: ");
    printStr("\nCaution: if the square of the integer exceeds the maximum value of int, you may get an Invalid output!\n");
    i=readInt(&ep);
    i=func(i);
	a[1]=100;
    printInt(i);
    printStr("\n");
    printStr("Enter an integer(<=14) to calculate its factorial: ");
    i=readInt(&ep);
    printStr("The read integer is: ");
    printInt(i);
    printStr(" \nIts factorial is: ");
   	t=fact(i);
    printInt(t);
    printStr("\n");
}
