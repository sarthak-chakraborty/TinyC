
int test = 5;
double d = 2.3;
int i, w[10];
int a = 4, *p, b;
void func(int i, double d);
char c;
int main () {
	a = 10;
	int *x, y;
	x = &y;
	*x = y;
	y = *x;
	int a=1, b=2, c;
	c = a + b;
	a++;
	int check = a+b*c;
	if (check < c) 
		c = a|b;
	i = ++a;
	int n = 6;
	int fn = (int)d;
	char d = 'D';
	fn = factorial(n);
	int i, a[10], v = 5;
	double d1 = 123.456;
	double d = f1(d1);
	char* ex1 = "halo";
	char* ex2 = f2(ex1);
	/*dfgh d
	s*/
	for (i=1; i<a[10]; i++) 
		i++;
	do i = i - 1; while (a[i] < v);
	i = 2;
	int d = func(d);
	if (i&&v) i = 1;
	int ar1[] = {1,2,4};
	return 0;
}

double f1(double i){
	double x=12.31;/**/
double y = 32.54;
/*
*/
	double z = x*i/y;
	return z; //x*i/y;
}
/*
*/
char* f2(const char* ci){
	return ci;
}
// My name is Sarthak Chakraborty
int factorial (int n) {
	if(n==1)
		return 1;
	return n * factorial(n-1);
}
void func(char c){
	int j = (int)c;
	return;
}
int add(int a, int b) {
	a = 10;
	int *x, y;
	x = &y;
	*x = y;
	y = *x;
}
