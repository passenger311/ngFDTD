#include <stdlib.h>
#include <stdio.h>
int
main() {
  int i;
  
  double* p = (double*)malloc(sizeof(double)*1000000000);
  p[0]=1;
  p[1]=1;
  for(i=2;i<1000000000;i++) {
    p[i] = (p[i-1]+p[i-2]);
  }
  printf("%f\n",p[1000000000-1]);
  free(p);

}
