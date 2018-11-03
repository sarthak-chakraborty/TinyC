#define BUFF 100
#define ERR 1
#define OK 0


int printStr(char * a){
	int i = 0, len = 0;
  	char str[500];         // Stores it in array str
  	while(a[i] != '\0'){
    	str[i] = a[i];
    	len++;              // Length of str
    	i++;
  	}
  
  	__asm__ __volatile__ (
          	"movl $1, %%eax \n\t"
	          "movq $1, %%rdi \n\t"
        	  "syscall \n\t"
        	  :
        	  :"S"(str), "d"(len)
	);
  	return len;         // Length is returned

}


int readInt(int *n){

	char buff[BUFF];     // buff array where the console input is stored.
	int len = 0, i = 0, num = 0;


	__asm__ __volatile__ (
		"movl $0, %%eax \n\t"
		"movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		:"S"(buff), "d"(BUFF)      //Stores the string in buff with maximum of BUFF characters 
	);

	while(buff[i] != '\n' && buff[i] != '.')    //Ensuring the integer is upto the decimal point if it entered or the new line character.
		i++;

	buff[i] = '\0';     // Ending the string with null character

	if((buff[0] == '-' || buff[0] == '+') && buff[1] == '\0'){    // If entered number is "-" or "+", then error.
		*n = 1;
		return -1;

	}

	num = 0;   // Initialize

	i = 0 + buff[0]=='-' || buff[0]=='+' ;    // Starting index for the parsing of string to int

	while(buff[i] != '\0'){
		if(buff[i] >= '0' && buff[i] <= '9'){   // Checking if the entered character is between '0' and '9'
			num *= 10;
			num += (int)(buff[i] - '0');     // Conversion of the character to number
			i++;
		}
		else{
			
			(*n) = 1;
			return -1;
		}
	}

	if(buff[0] == '-')    // If the number enterd is negative, then negate *n.
		num = -num;

	*n = 0;
	return num;
}


// Function to print Integer
int printInt(int n) {

    char buff[BUFF], zero = '0';
    int i = 0, j, k, length;

    if(n == 0)        // If n = 0, then append the zero character to the buff array
      buff[i++] = zero;
    else{
       if(n < 0) {        // If n<0, then first character is "-"
          buff[i++]='-';
          n = -n;
       }
       while(n){          // Extracting digits of the number and converting it into character
          int dig = n%10;
          buff[i++] = (char)(zero+dig);
          n /= 10;
       }
       if(buff[0] == '-') j = 1;
       else j = 0;
       k=i-1;
       while(j<k){      // Reversing the character array
          char temp=buff[j];
          buff[j++] = buff[k];
          buff[k--] = temp;
       }
    } 
    
    length = i;

    __asm__ __volatile__ (
          "movl $1, %%eax \n\t"
          "movq $1, %%rdi \n\t"
          "syscall \n\t"
          :
          :"S"(buff), "d"(length)
    );
    return length;
}



int readf(float *fp){
	char buff[BUFF]="", zero='0';
	int n=0, ef=0, exp=0;//ef- exp part is there, fr=0;	//d-0 => no fractional part
	int neg=0, negexp=0;
	double num=0.0, fr=0, frac=1;
	while(1)
	{
		__asm__ __volatile__ ("syscall \n\t"::"a"(0), "D"(0), "S"(buff+n), "d"(1));
		
		if(buff[n]==' '||buff[n]=='\n'||buff[n]=='\t'||buff[n]=='\0')
			{ if (n==0) continue; else break; }
		++n;
	}
	int i=0;
	if('-'==buff[0]){
		neg=1; i++;
	}
	else if('+'==buff[0])
		i++;
	while(i<n){
		if(buff[i]>='0' && buff[i]<='9'){
			if(0==fr)
				num = num*10+(buff[i]-zero);
			else{
				frac /=10.0;
				num+= (buff[i]-zero)*frac;
			}
			 
		}
		else if('.'==buff[i]){
			if(fr){return ERR;}
			fr=1;
		}
		else if('e'==buff[i] || 'E'==buff[i]){
			ef=1;
			break;
		}
		else{
			return ERR;
		}
		i++;
	}
	
	
	if(ef){
			i++;
		if('-'==buff[i]){
			negexp=1; i++;
		}
		else if('+'==buff[i])
			i++;
		if(i==n){			//1.2e or 12e- or 2.3e+
			return ERR;
		}
		while(i<n){
			if(!(buff[i]>='0' && buff[i]<='9')){
				 return ERR;
				}
			else{
				exp = exp*10+(buff[i]-zero);
			}
			i++;
		}
	}
	
	if(negexp){
		while(exp){
			num/=10;
			exp--;
		}
	}
	else{
		while(exp){
			num*=10;
			exp--;
		}
	}
	if(neg) num*=-1;
	if(num>3.4e38 ||num<-3.4e38){
		return ERR;
	}
	int r;
	if((long long int)(num*10000000)%10 == 5){
		if(((long long int)(num*1000000)%10)%2==1)
			r=1;
		else
			r=0;
	}
	else if((long long int)(num*10000000)%10 > 5)
		r=1;
	else
		r=0;
	float tmpfnum = (float)num;
	if(r) tmpfnum+=.000001;
	*fp = tmpfnum;
	return OK;
	
}

int printd(float f){
	int c=(f<0)? 1:0;
	if(c) printStr("-");
	long double fabs = c? -f : f;
	int d=0, flag=0 ;	//d- position of decimal point
	
	int r;
	if((long long int)(fabs*10000000)%10 == 5){
		if(((long long int)(fabs*1000000)%10)%2==1)
			r=1;
		else
			r=0;
	}
	else if((long long int)(fabs*10000000)%10 > 5)
		r=1;
	else
		r=0;
	if (r) fabs+=.000001;
	if(0==(int)fabs) {
		printInt(0);
		flag=1;
	} else{
		while(fabs >= 1){
			fabs/=10;
			d++;
		}
	}
	for(int i=1; i <= d; i++){
		fabs*=10;
		int tmi=(int)fabs;
		if(fabs-tmi>.99999999) tmi++;
		printInt(tmi);
		fabs-=tmi;
	}
	printStr(".");
	for(int i=0; i < 6; i++){
		fabs*=10;
		printInt(((long int)fabs)%10);
	}
	if(c) d++;	//one more character for '-'
	if(flag) {
		 if(c) return 9;
 		else return 8;
	}
	else return d+7;
}

