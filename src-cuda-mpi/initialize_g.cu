#include <thrust/device_vector.h>
#include <thrust/copy.h>
#include <thrust/sequence.h>
#include <thrust/sort.h>
#include "rism3d.h"

void RISM3D :: initialize_g() {
  __global__ void setg(double3 * dgv, double * dg2, 
		       double bx, double by, double bz,
		       int nx, int ny, int nz, int xx, int yy);
  void index(double * &, int * &, int);

  indga = new int[ce -> mgrid];
  double * g2 = new double[ce -> mgrid];
  int * indg2 = new int[ce -> mgrid];

  double * dg2;
  cudaMalloc(&dgv, ce -> mgrid * sizeof(double3));
  cudaMalloc(&dg2, ce -> mgrid * sizeof(double));

  setg <<< gk, bk >>> (dgv, dg2, ce -> box[0], ce -> box[1], ce -> box[2],
		      ce -> grid[0], ce -> grid[1], ce -> grid[2], 
		      ce -> xks, ce -> yks);

  cudaMemcpyAsync(g2, dg2, ce -> mgrid * sizeof(double), cudaMemcpyDefault);
  thrust::device_vector<int> indg(ce -> mgrid);
  thrust::device_ptr<double> dg2_ptr(dg2);
  thrust::sequence(indg.begin(), indg.end());
  thrust::sort_by_key(dg2_ptr, dg2_ptr + ce -> mgrid, indg.begin());  
  thrust::copy(indg.begin(), indg.end(), indg2);
  //  index(g2, indg2, ce -> mgrid);

  double ga2o = - 1.0;
  nga = 0;

  for (int igk = 0; igk < ce -> mgrid; ++igk) {
    int igs = indg2[igk];
    double ga2 = g2[igs];
    if (ga2 > ga2o) {
      ++nga;
      ga . push_back (sqrt(ga2));
      ga2o = ga2;
    }
    indga[igs] = nga - 1;
  }

  cudaFree(dg2);
  delete[] g2;
  delete[] indg2;
}


__global__ void setg(double3 * dgv, double * dg2, 
		     double bx, double by, double bz,
		     int nx, int ny, int nz, int xx, int yy) {
  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  dgv[ip].x = 2.0 * M_PI * (threadIdx.x + xx - nx / 2.0 + 0.5) / bx;
  dgv[ip].y = 2.0 * M_PI * (blockIdx.x + yy - ny / 2.0 + 0.5) / by;
  dgv[ip].z = 2.0 * M_PI * (blockIdx.y - nz / 2.0 + 0.5) / bz;
  dg2[ip] = dgv[ip].x * dgv[ip].x + dgv[ip].y * dgv[ip].y 
    + dgv[ip].z * dgv[ip].z;
}
