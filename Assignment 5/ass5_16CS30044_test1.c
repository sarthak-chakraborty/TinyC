// Test Expressions

int i = 1;

int main () {
	int a=1, b=2, c;
	double x = 3.0,y =5.78;
	c = a + b;
	a++;
	a = a>>2;
	b=b<<2;
	b = a / b;
	double d, e;
	d = a+d;
	e = a*b;
	int f = b%c;
	
	if(c==a)
		return;
	a = b > a ? b : a;
	int check = a+b*c;
	if (check < c) 
		c = a|b;
	i = ++a + b++;

	if(a&&b || b&&d)
		return;
}