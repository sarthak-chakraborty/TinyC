

int printInt(int num);
int printStr(char * c);
int readInt(int *eP);

int callprint(int i)
{
    int t=100;
    return 0;
}
int main()
{
    printStr("Lets do activty selection problem\n");
    int s[6],f[6],i;
    for(i=0;i<6;i++)
    {
        s[i]=i+i*i;
        f[i]=2*i+i*i*i;
    }
    printStr("The start time of activities are as follows:\n");
    printStr("0 2 6 12 20 30\n");
    for(i=0;i<6;i++)
    {
      callprint(f[i]);
      printStr("");
    }
    printStr("The finish time of activities are as follows:\n");
    printStr("2 3 12 33 72 135\n");
    for(i=0;i<6;i++)
    {
      callprint(f[i]);
      printStr("");
    }
    int n=6;
    printStr ("Following activities are selected \n");
    i = 1;
    printInt(i);
    printStr(" ");
    for (j = 1; j < n; j++)
    {
      if (s[j] >= f[i])
      {
          printInt(j);
          printStr(" ");
          i = j;
      }
    }
    printStr("2 3 4 5 6\n");
    return 0;
}
