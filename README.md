# Hmatrix-MATLAB
This is a repossitory with useful functions to work with different H-matrix formats in MATLAB.

# September 16, 2026 update:
Now this functions take a dense matrix and perform different opperations with it after transform it to HODLR format. Relying in SVD factorization for low-rank blocks. 

src is a folder containing :

+hodlr : 

1) buildWeak.m : This function builts a HODLR matrix (H-matrix, weak admissibility) from a dense matrix.
2)  matvec.m : HODLR matrix - vector multiplication function
3)  addition.m : HODLR matrix - HODLR matrix addition function
4)  multiplication.m : HODLR matrix - HODLR matrix addition function
5)  scale.m : HODLR matrix - scalar multiplication function
6)  solve.m : Function to solve a HODLR matrix system (Hx=b) using LU factorization of H.
7)  LU.m : LU factorization of a HODLR matrix 
8) HODLR_to_dense.M : Densifies HODLR matrix 
9) spy.m : Visualize a HODLR matrix

+geometry : 

1) circle: generates a circle and outputs the set of points and connectivity edge list

+mom2d : 

1) generateZ: This function generates the impedance matrix for a 2D MoM problem: An incident field E0 with TMz polarization with a PEC infinitely long cylinder

tests is a folder containing :

1) test_all_the_functions.m: Just implements all functions in +hodlr folder


   
