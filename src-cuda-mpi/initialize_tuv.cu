#include <iostream>
#include <fstream>
#include <string>

#include "rism3d.h"

void RISM3D :: initialize_tuv () {
  __global__ void init_tuv(double * dt, double * fr, double q);

  if (myrank == 0) {
    cout << "synthesizing initial estimate for Tuv ..." << endl ;
  }

  for (int iv = 0; iv < sv -> natv; ++iv) {
    init_tuv <<< gr, br >>> (dt + (iv * ce -> mgrid), dfr, sv -> qv[iv]);
  }
} 

__global__ void init_tuv(double * dt, double * fr, double q) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x 
    + blockIdx.y * blockDim.x * gridDim.x;
  dt[ip] = q * fr[ip];
}
