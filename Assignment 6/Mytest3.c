/************BUBBLE SORT TEST FILE***************/
/*-----------ITERATIVE APPROACH----------------*/
/* 	The following tests the sorting of an array of 10 user
	fed integers using the bubblesort sorting technique*/
#include "myl.h"
int main()
{
	int *ep;
	int a[5];
	int i,j,k,r,p;
	ep = &j;
	printStr("");
	printStr("--------------BUBBLE SORT TEST FILE---------------");
	printStr("Here we sort an array of elements"); 
	printStr("using ITERATIVE approach:");
	printStr("Enter 5 integers of the array :");
	for(i=0;i<5;i++)
	{
		r = readInt(ep);
		a[i] = r;
	}
	printStr("The array fed is :");
	for(i=0;i<5;i++)
	{
		r = a[i];
		printInt(r);
		printStr("");
	}
	//----Bubble sort----
	for(i=0;i<5;i++)
	{
		for(k=0;k<4-i;k++)
		{
			r = a[k];
			p = a[k+1];
			if(r>p)
			{
				a[k] = p;
				a[k+1] = r;
			}
		}
	}
	printStr("The array after sorting is :");
	for(i=0;i<5;i++)
	{
		r = a[i];
		printInt(r);
		printStr("");
	}
}