#include <iostream>
#include "rism3d.h"

void RISM3D :: set_device(int dn) {
/*
  if (procs > 1) {
    int gpu_num;
    cudaGetDeviceCount(&gpu_num);
    devid = myrank%gpu_num;
  } else {
    devid = dn;
    cout << "Set device " << devid << endl ;
  }
*/
  devid = dn;
//  cudaSetDevice(devid);
} 
