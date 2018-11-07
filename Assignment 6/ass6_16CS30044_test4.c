

int printInt(int num);
int printStr(char *c);
int readInt(int *eP);

int max(int a, int b)
{
    if(a>b)
      return a;
    else
      return b;
}
int main()
{
    printStr("Compute maximum of two numbers\n");  
    int a, b, maxim, *ep;
    a = readInt(&ep);
    b = readInt(&ep);

    if(a > b)
      maxim = a;
    else
      maxim = b;

    printStr("Maximum is: ");
    printInt(maxim);
    printStr("\n");


    printStr("Compute minimum of two numbers\n");
    int c, d, minim;
    c = readInt(&ep);
    d = readInt(&ep);

    if(c < d)
      minim = c;
    else
      minim = d;

    printStr("Minimum is: ");
    printInt(minim);
    printStr("\n");
}
