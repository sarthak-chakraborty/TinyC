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
  printStr("Difference = ");
  printInt(x-y);
  printStr("\n");
  printStr("Product = ");
  printInt(x*y);
  printStr("\n");
  
   return 0;
}

