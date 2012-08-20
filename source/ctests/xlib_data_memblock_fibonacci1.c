#include <stdlib.h>
#include <stdio.h>

int
main() {

  int i, cnt;
  int N = 1000000;
  double* p = (double*)malloc(sizeof(double)*N);
  p[0]=1;
  p[1]=1;
  
  for(cnt=0;cnt<10;cnt++) {

    for(i=2;i<N;i++) {
      p[i] = (p[i-1]+p[i-2]);
    }
    for(i=N-3;i>=0;i--) {
      p[i] = (p[i+2]-p[i+1]);
    }
    for(i=2;i<N;i++) {
      p[i] = (p[i-1]+p[i-2]);
    }
    for(i=N-3;i>=0;i--) {
      p[i] = (p[i+2]-p[i+1]);
    }
    
  }
    
  printf("%f\n",p[N-1]);
  free(p);

}
