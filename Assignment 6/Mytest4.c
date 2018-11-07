/*-----------------GCD TEST FILE-------------------*/
/***************RECURSIVE APPROACH******************/
/*The following function will test the greatest common divisor of two numbers
using a RECURSIVE APPROACH */
#include "myl.h"
int gcd(int a,int b)
{
	int m,n,h;
	if(a==b)
		return a;
	else
	{
		if(a>b)
		{
			m = a-b;
			n = b;
		}
		else
		{
			m = b-a;
			n = a;
		}
		h = gcd(m,n);
		return h;
	}
}
int main()
{
	int a,b,c,d;
	int*ep;
	ep = &c;
	printStr("");
	printStr("----------Here we test GCD :---------");
	printStr("Enter 2 numbers for finding their gcd recursively");
	a = readInt(ep);
	b = readInt(ep);
	d = gcd(a,b);
	printStr("The gcd of the 2 numbers you entered is :");
	printInt(d);
	printStr("");
}