#include <iostream>
#include <fstream>
#include "rism3d.h"
#include "extension.h"

void RISM3D :: output_ad(double * & du) {

  std::stringstream ss;
  ss << fname << "-" << adswitch << "-" << lambda;

  cout << "outputting ad to file:  " << ss.str() << "  ..." << endl;

  ofstream out_file;
  out_file.open (ss.str().c_str());

  double dv = ce -> dv / kcal2J;
  for (int iu = 0; iu < su -> num; ++iu) {
    out_file << du[iu] * dv << endl;
  }

  cout << "done." << endl;

  out_file.close();
} 
