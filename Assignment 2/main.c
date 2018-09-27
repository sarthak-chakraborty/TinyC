#include "myl.h"
int main(){
	int n, len, err_code;
	float f;

	len = printStr("Enter an integer: ");

	err_code = readInt(&n);

	if(err_code)
		printStr("ERROR: Not an integer\n");
	else{
		len = printStr("Entered integer is: ");
		len = printInt(n);
	}

	len = printStr("Enter a float: ");

	err_code = readFlt(&f);

	if(err_code)
		printStr("ERROR: Not a float\n");
	else{
		len = printStr("Entered floating point number is: ");
		len = printFlt(f);
	}
	
	return 0;
}