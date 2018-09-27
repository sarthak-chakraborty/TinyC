#define BUFF1 20
#define BUFF2 50
#define ERR 1
#define OK 0


// Function to print String
int printStr(char *a){
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


// Function to read integer
int readInt(int *n){

  char buff[BUFF1];     // buff array where the console input is stored.
  int len = 0, i = 0;

  __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(BUFF1)      //Stores the string in buff with maximum of BUFF characters 
  );

  while(buff[i] != '\n' && buff[i] != '.')    //Ensuring the integer is upto the decimal point if it entered or the new line character.
    i++;
  buff[i] = '\0';     // Ending the string with null character

  if((buff[0] == '-' || buff[0] == '+') && buff[1] == '\0'){    // If entered number is "-" or "+", then error.
    *n = 0;
    return ERR;
  }

  *n = 0;   // Initialize

  i = 0 + buff[0]=='-' || buff[0]=='+' ;    // Starting index for the parsing of string to int
  while(buff[i] != '\0'){
    if(buff[i] >= '0' && buff[i] <= '9'){   // Checking if the entered character is between '0' and '9'
      (*n) *= 10;
      (*n) += (int)(buff[i] - '0');     // Conversion of the character to number
      i++;
    }
    else{
      (*n) = 0;
      return ERR;
    }
  }

  if(buff[0] == '-')    // If the number enterd is negative, then negate *n.
    (*n) = -(*n);

  return OK;
}


// Function to print Integer
int printInt(int n){
    char buff[BUFF1], zero = '0';
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
    buff[i]='\n';
    length = i+1;

    __asm__ __volatile__ (
          "movl $1, %%eax \n\t"
          "movq $1, %%rdi \n\t"
          "syscall \n\t"
          :
          :"S"(buff), "d"(length)
    );
    return length;
}


// Function to read floating point numbers
int readFlt(float *f){
  char buff[BUFF2];
  int j = 0, i = 0;
  float d = 1.0;

  __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(BUFF2)       
  );

  while(buff[i] != '\n')  //Ensuring the integer is upto the new line character.
    i++;
  buff[i] = '\0';   // Ending the string with null character

  if((buff[0] == '-' || buff[0] == '+') && buff[1] == '\0'){   //If entered number is "-" or "+", then error.
    *f = 0;
    return ERR;
  }

  // Converting the integer part of the character array to number
  *f=0;
  i = 0 + buff[0]=='-' || buff[0]=='+' ;
  while(buff[i] != '\0' && buff[i] != '.'){
    if(buff[i] >= '0' && buff[i] <= '9'){
      (*f) *= 10;
      (*f) += (float)(buff[i] - '0');
      i++;
    }
    else{
      (*f) = 0;
      return ERR;
    }
  }


  if(buff[i] == '\0'){
    if(buff[0] == '-')
      (*f) = -(*f);
    return OK;
  }

  //Converting the decimal part of the array to number
  i++;
  while(buff[i] != '\0'){
    if(buff[i] >= '0' && buff[i] <= '9'){
      d /= 10.0;
      (*f) += (float)(buff[i] - '0')*d;
      i++;
    }
    else{
      (*f) = 0;
      return ERR;
    }
  }

  if(buff[0] == '-')   // Negating the number if the entered stream of digits has "-" in the beginning
      (*f) = -(*f);

  return OK;
}


int printFlt(float n){
  char buff[BUFF2], zero = '0';
  int i = 0, int_part, k, j, dig;
  float dec_part;

  int_part = (int)n;    // Extracting the int part
  dec_part = n - int_part;    // Extracting the decimal part

  // Converting the int part to character array
  if(int_part == 0)
      buff[i++] = zero;
  else{
      if(n < 0) {     // Appending "-" if the number is negative
        buff[i++]='-';
        int_part = -int_part;
      }
      while(int_part){   // Extracting the digits of integer part and converting to character
        dig = int_part % 10;
        buff[i++] = (char)(zero + dig);
        int_part /= 10;
      }
      if(buff[0] == '-')
        j = 1;
      else j = 0;
      k = i - 1;
      while(j<k){       // Reversing the character array
        char temp = buff[j];
        buff[j++] = buff[k];
        buff[k--] = temp;
      }
    }

    // Appending "." after the integer part
    buff[i++] = '.';

    // Appending the after decimal part of the number to the character array
    if(dec_part < 0)
      dec_part = -dec_part;
    for(j = 0; j < 5; j++){
      dec_part *= 10;
      dig = (int)dec_part % 10;
      buff[i++] = (char)(zero + dig);
    }
    buff[i++] = '\n';

     __asm__ __volatile__ (
          "movl $1, %%eax \n\t"
          "movq $1, %%rdi \n\t"
          "syscall \n\t"
          :
          :"S"(buff), "d"(i)
    );
    return i;
}
