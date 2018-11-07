int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int main()
{
   int a[10], arr, *ep;
   printStr("Testing Basic arithmetic operations using ARRAY:");
   printStr("\nEnter 2 numbers:\n");
   arr = readInt(&ep);
   a[0] = readInt(&ep);
   a[1] = a[0]+arr;
 
   printStr("Sum = ");
   printInt(a[1]);
   printStr("\n");
   int x, y;
   x=2;
   y=3; 
    
}
