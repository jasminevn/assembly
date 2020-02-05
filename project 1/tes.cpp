#include <iostream>

int max = 50000;
int min = 5000;

tmp = 0;

for ( int i = 2; i < max; i++){
  for(int j =  2; j <max; j++){
    if(pow(i,j) <= max && pow(i,j) >=min)
      tmp +=1;
  }
  cout >> tmp;
}
