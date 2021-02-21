#include "solute.h"

void Solute :: init(int n) {
  num = n;
  cudaMallocHost(&q, num * sizeof(double));
  cudaMallocHost(&r, num * 3 * sizeof(double));
//  cudaMallocHost(&sig, num * sizeof(double));
//  cudaMallocHost(&eps, num * sizeof(double));
//  q = new double[num];
  sig = new double[num];
  eps = new double[num];
//  r = new double[num * 3];
}

void Solute :: setup_mpi() {
  MPI_Bcast(q, num, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast(sig, num, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast(eps, num, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast(r, num * 3, MPI_DOUBLE, 0, MPI_COMM_WORLD);
}

void Solute :: setup_cuda() {
  cudaMalloc(&dq, num * sizeof(double));
  cudaMalloc(&dr, num * sizeof(double3));
  cudaMemcpy(dq, q, num * sizeof(double), cudaMemcpyDefault);
  cudaMemcpy(dr, r, num * sizeof(double3), cudaMemcpyDefault);
}
