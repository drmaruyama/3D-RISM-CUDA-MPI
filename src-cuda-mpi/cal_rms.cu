#include <thrust/transform_reduce.h>
#include <thrust/functional.h>
#include <thrust/device_vector.h>
#include "rism3d.h"

template <typename T>
struct square {
  __host__ __device__ T operator()(const T &x) const { 
    return x * x;
  }
};


double RISM3D :: cal_rms () {
  __global__ void reduce0(double * ds, double * dtr);

  square<double> uop;
  thrust::plus<double> bop;
  thrust::device_ptr<double> dtr_ptr(dtr);
  double rms = thrust::transform_reduce(dtr_ptr, dtr_ptr 
				+ sv -> natv * ce -> mgrid, uop, 0.0, bop);
  double rms00;
  MPI_Allreduce(&rms, &rms00, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
  rms = sqrt (rms00 / (ce -> ngrid * sv -> natv));
  return rms;
}

__global__ void reduce0(double * ds, double * dtr) {
  extern __shared__ double sdata[];

  unsigned int ip = threadIdx.x + blockIdx.x * blockDim.x
    + blockIdx.y * blockDim.x * gridDim.x;

  sdata[threadIdx.x] = dtr[ip] * dtr[ip];
  __syncthreads();

  for (unsigned int s = blockDim.x / 2; s > 32; s >>= 1) {
    if (threadIdx.x < s) {
      sdata[threadIdx.x] += sdata[threadIdx.x + s];
    }
    __syncthreads();
  }
  if (threadIdx.x < 32) {
    volatile double *smem = sdata;
    smem[threadIdx.x] += smem[threadIdx.x + 32];
    __syncwarp();
    smem[threadIdx.x] += smem[threadIdx.x + 16];
    __syncwarp();
    smem[threadIdx.x] += smem[threadIdx.x + 8];
    __syncwarp();
    smem[threadIdx.x] += smem[threadIdx.x + 4];
    __syncwarp();
    smem[threadIdx.x] += smem[threadIdx.x + 2];
    __syncwarp();
    smem[threadIdx.x] += smem[threadIdx.x + 1];
  }
  if (threadIdx.x == 0) ds[blockIdx.x + blockIdx.y * gridDim.x] = sdata[0];
}

