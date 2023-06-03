#include <iostream>
#include <fstream>
#include "rism3d.h"
#include "extension.h"

void RISM3D :: output_euv(double * & euv) {

  cout << "outputting euv to file:  " << fname + exteuv << "  ..." << endl;

  ofstream out_file;
  out_file.open ((fname + exteuv).c_str());

  double dv = ce -> dv;

  for (size_t iu = 0; iu < su -> num; ++iu) {
    double euva = 0.0;
    size_t i = iu * sv -> natv;
    for (size_t iv = 0; iv < sv -> natv; ++iv) {
      euva += euv[i + iv];
    }
    out_file << fixed << dv * euva;
    for (size_t iv = 0; iv < sv -> natv; ++iv) {
      out_file << " " << fixed << dv * euv[i + iv];
    }
    out_file << endl;
  }

  cout << "done." << endl;

  out_file.close();
} 
