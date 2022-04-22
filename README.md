### 3D-RISM-CUDA-MPI

#### Install for Cygnus 

module load gcc/8.3.1

module load openmpi/gdr/4.1.2/gcc8.3.1-cuda11.6.2-ucx1.7.0

cd /PathTo3D-RISM-CUDA-MPI/src-cuda-mpi

make

#### PERFORMACE

Input: example-cygnus/test2.inp

Solute: RBD(SARS-CoV-2)-ACE2(Human) 12877 atoms

Solvent: 0.2 M NaCl aqueous solution (water: Tip3p model)

Cell: 256^3 Angstrom^3 (512^3 grids)

<pre>
# of Node (GPU)	GPUDirect [s]	no GPUDirect [s]
1 (4)		413.9	  	1862.6
2 (8)  		660.3		 931.1
4 (16) 		469.8		 532.7
8 (32) 		262.6		 272.8
16 (64)		203.9		 126.5
32 (128)	108.3		  65.5
64 (256)	 59.2		  33.8
</pre>
(Performed on Cygnus in University of Tsukuba, https://www.ccs.tsukuba.ac.jp/eng/supercomputers/)

#### REFERENCE
[1] Yutaka Maruyama, Fumio Hirata

J. Chem. Theory Comput. 2012, 8, 3015-3021

Modified Anderson Method for Accelerating 3D-RISM Calculations Using Graphics Processing Unit

https://doi.org/10.1021/ct300355r

https://pubs.acs.org/doi/abs/10.1021/ct300355r

[2] Yutaka Maruyama, Norio Yoshida, Hiroto Tadano, Daisuke Takahashi, Mitsuhisa Sato, Fumio Hirata

J. Comp. Chem. 2014, 35, 1347-1355

Massively parallel implementation of 3D‐RISM calculation with volumetric 3D‐FFT

https://doi.org/10.1002/jcc.23619
 
https://onlinelibrary.wiley.com/doi/abs/10.1002/jcc.23619