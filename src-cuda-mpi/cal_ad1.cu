#include <thrust/device_vector.h>
#include "rism3d.h"

__constant__ double3 dv;
__constant__ int3 grid;

void RISM3D :: cal_ad1(double * & du) {
  __global__ void ad1(double * ds, double2 * dguv, double * dsig, 
		       double * deps,  double3 * dr, double * qu,
		       double qv, int natu, int iv, int iu, int yy, int zz, 
		       double lambda);

  int ng = ce -> mgrid;

  cudaMemcpyToSymbol(dv, ce -> dr, sizeof(double3));
  cudaMemcpyToSymbol(grid, ce -> grid, sizeof(int3));

  double * ds;
  cudaMalloc(&ds, gr.x * gr.y * sizeof(double));

#pragma omp parallel for
  for (int iu = 0; iu < su -> num; ++iu) {
    du[iu] = 0.0;
  }

  for (int iv = 0; iv < sv -> natv; ++iv) {
    for (int iu = 0; iu < su -> num; ++iu) {
      ad1 <<< gr, br, br.x * sizeof(double) >>> 
	(ds, dguv + (iv * ng), dsig, deps, su -> dr, su -> dq, sv -> qv[iv], 
	 su -> num, iv, iu, ce -> ystart, ce -> zstart, lambda);

      thrust::device_ptr<double> ds_ptr(ds);
      double s = thrust::reduce(ds_ptr, ds_ptr + gr.x * gr.y);
      du[iu] += s * sv -> rhov[iv];
    }
  }
  cudaFree(ds);
}

__global__ void ad1(double * ds, double2 * dguv, double * dsig, 
		   double * deps,  double3 * dr, double * qu,
                   double qv, int natu, int iv, int iu, int yy, int zz, 
 		   double lambda) {
  extern __shared__ double sdata[];
  const double cc = hartree * bohr * avogadoro;

  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;
  int iuv = iu + iv * natu;

  double dx = ((int)threadIdx.x - grid.x / 2) * dv.x - dr[iu].x;
  double dy = ((int)blockIdx.x + yy - grid.y / 2) * dv.y - dr[iu].y;
  double dz = ((int)blockIdx.y + zz - grid.z / 2) * dv.z - dr[iu].z;
  double r2 = dx * dx + dy * dy + dz * dz;
  double r1 = sqrt(r2);

  if (r1 < dsig[iuv] * lambda * 0.5) {
    sdata[threadIdx.x] = 0.0;
  } else {
    double rs2i = dsig[iuv] * dsig[iuv] / r2;
    double rs6i = rs2i * rs2i * rs2i;
    double ulj = deps[iuv] * 24.0 * rs6i * (2.0 * rs6i - 1.0) / lambda
      * dguv[ip].x;
    sdata[threadIdx.x] = ulj;
  }
  __syncthreads();

  for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1) {
    if (threadIdx.x < s) {
      sdata[threadIdx.x] += sdata[threadIdx.x + s];
    }
    __syncthreads();
  }
  if (threadIdx.x == 0) {
    ds[blockIdx.x + blockIdx.y * gridDim.x] = sdata[0];
  }
}
