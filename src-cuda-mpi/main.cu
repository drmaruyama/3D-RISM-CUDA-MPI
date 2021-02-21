#include <iostream>
#include <fstream>
#include <unistd.h>
#include "rism3d.h"

int main (int argc, char * argv[]) {
  RISM3D * system;
  int ch, cu, dn;

  system = new RISM3D;

  while ((ch = getopt(argc, argv, "c:l:e:")) != -1) {
    switch (ch){
    case 'c':
      cu = atoi(optarg);
      break;
    case 'l':
      system -> set_ad (atof(optarg), 1);
      break;
    case 'e':
      system -> set_ad (atof(optarg), 2);
      break;
    }
  }
  if (argc == 1) {
    cout << "No parameter file!" << endl ;
    return (1) ;
  }

#ifdef OPENMPI
  dn = atoi(getenv("OMPI_COMM_WORLD_LOCAL_RANK"));
#endif
#ifdef MVAPICH
  dn = atoi(getenv("MV2_COMM_WORLD_LOCAL_RANK"));
#endif

  cudaSetDevice(dn);

  MPI_Init(&argc, &argv);
  //  int provided;
  //  MPI_Init_thread(&argc, &argv, MPI_THREAD_FUNNELED, &provided);

  system -> initialize(argv[optind], dn);
  system -> iterate();
  system -> output();    

  MPI_Finalize();
  return(0);
}
