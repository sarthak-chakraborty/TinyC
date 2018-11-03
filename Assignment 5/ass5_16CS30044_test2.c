
int i, w[10];
int a = 4, *p, b;
int test = 8;
int factorial (int n);

int add(int a, int b){
	return a+b;
}

void main () {
	int n = 6;
	int fn;

	int c = add(3,4);

	fn = factorial(n*c);
	return;
}

int factorial (int n) {
	int m = n-1;
	int r = 1;
	if (m) {
		int fn = factorial(m-1);
		r = n*fn;
	}
	return r;
}
