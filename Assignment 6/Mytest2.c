/*----------SUM OF NUMBERS TEST FILE------------*/
/*Here we test the basic functionalities such as the
working of the various LOOPING STRUCTURES and declarations and
initialisations*/

//#include "myl.h"

int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int main(){

	int n,c;
	int*ep;
	ep = &c;
	// printStr("------------SUM TEST FILE-------------");
	// printStr("Here we find the sum of numbers upto a number"); 
	// printStr("using ITERATIVE approach thus ");
	// printStr("testing different loops:");
	printStr("Enter the number :");
	n=readInt(ep);
	int i=0;
	int sum=0;
	for(i=1;i<=n;i++)
	{
		sum=sum+i;
	}
	printStr("");
	printStr("Sum calculated using FOR LOOP :");
	printInt(sum);
	sum=0;
	i=1;

	printStr("");
	printStr("Sum calculated using WHILE LOOP :");
	while(i<=n)
	{
		sum=sum+i;
		i++;
	}
	printInt(sum);
	sum=0;
	i=1;

	printStr("");
	printStr("Sum calculated using DO-WHILE LOOP :");
	do
	{
		sum=sum+i;
		i++;
	}while(i<=n);
	printInt(sum);
	printStr("");
}
