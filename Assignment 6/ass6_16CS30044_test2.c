int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int main()
{
	printStr("Basic IO opearations and Computations:\n");
  int x, y, z;
  int *ep;
  printStr("Enter 2 nos.:\n");
  x = readInt(&ep);
  y=readInt(&ep);
//  z = x+y;
  printStr("Sum = ");
  printInt(x+y);
  printStr("\n");
  
   return 0;
}

/*
int main()
{
    printStr("Lest find the max and 2nd max of an array of integers\n");
    printStr("Enter the number n:\n");
    int n,*ep,largest=-100,secondlargest=-100;
    n=readInt(&ep);
    printStr("Now enter ");
    printInt(n);
    printStr(" integers (one in each line)\n");
    int i;
    for(i=0;i<n;i++)
    {
        x=readInt(&ep);
        printInt(x);
        printStr("\n");
        if(x>=largest)
        {
            secondlargest=largest;
            largest=x;
        }
        else if(x>=secondlargest)
        {
            secondlargest=x;
        }
    }
    printStr("The largest number entered is ");
    printInt(largest);
    printStr("\nThe second largest number entered is");
    printInt(secondlargest);
    printStr("\nEnd of Program!!!\n");
}*/
