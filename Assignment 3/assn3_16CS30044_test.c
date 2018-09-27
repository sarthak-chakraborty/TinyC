#define PI 3.14
#include<stdio.h>

void func(...);

typedef struct{
	register a;
}_StRuCt;

int main()
{
		int x1 = 20;			//Integer Constants
		int x2 = 15;
		int array[3] = {1, 2, 3};

		float y = 2.3e3;	//Floating point numbers
		float z = 4.56E6;	
		float a = 95.;
		float b = .98;
		const double c = 5E+2;
		const double d = 7e-6;
		double e = 6.9E-8;
		double f = 9e+7;

		/*MULTI LINE COMMENT
		  Character and String Literals
		*/

		/*****
		****
		***/
		char cC_cC = 'abcd1234!@#$\"In Quotes\"';
		char str[20] = "\'Hello World!\'";
		char s = "";

		x1++; y--; x1=x1<<1; x2=x2>>2;
		x1 = x1&x2;
		x2 = x1|x2;

		unsigned int y1 = 3, y2 = 4;
		int y3 = y1^y2;
		y1 &= x1;
		y2 |= x2;
		y1 ^= y2;

		if(a == 95){
			a /= 5;
			b = a+b;
			b += a;
			b *= y1;
			a -= b;
		}
		else if((d >= 1) || (c <= 1) && !(e < 10) || (~f > 4.5E-1)){
			d = a+b;
			d = a-b;
			d = y1 * y2;
			e = x1 / x2;
			f = a%b;
			a <<= 1;
			a >>= 1;
		}

		x1 = (x2=1)?1:2;

		char str[2] = {'a','b'};

		switch(str[1]){
			case 'a': break;
			case 'b': break;
			default: break;
		}

		for(auto i = 0; i<2; i++){
			continue;
		}

		do{
			static short int i;
			long int j;
		}while(0);

		signed double a = -9.0;

		enum abcd = {int a, double b};

		/*
		Don't know the use of these keywords
		*/
		//Start Here
		extern;
		goto;
		inline;
		restrict;
		union;
		volatile;
		_Bool;
		_Complex;
		_Imaginary;

		return 1;
}

/***/*/