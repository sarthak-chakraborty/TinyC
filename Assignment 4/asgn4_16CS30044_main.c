#include <stdio.h>
#include "y.tab.h"
extern int yyparse();

int main() {
	yydebug=1;
  	yyparse();
  
  	return 0;
}