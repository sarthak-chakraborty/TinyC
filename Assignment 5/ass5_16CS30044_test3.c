int test = 3;

void func(int, int);

int add (int a, int b) {
	a = 10;
	int *x, y;

	
	x = &y;
	*x = y;
	y = *x;
}
void main () {
	int i, a[10], v = 3;
	double d, d1;
	for (i=1; i<a[10]; i++) 
		i++;

	do {
		i = i - 1; 
	}while (a[i] < v);
	i = 2;
	if (i&&v) 
		i = 1;
	while (v>a[i]) {
		i--;
	}

	a[4] = i;
	v = a[i];

	return;
}
