% test functions HODLR=====================================================
close all
clear;
clc;
addpath('C:\Users\royes\OneDrive\Escritorio\Lab\Neuron_Fall2026\HODLR\Repository\src')
hodlr.hello %Just to test a function
N = 4096;

r = 1;
[P, edges] = geometry.circle(N,r);
[Z, Ei, MidPoints] = mom2d.generateZ(P,edges);
levels = 6;
tol = 1e-7;
starr = round(linspace(1,N+1,2^levels+1));
%% BUILD HODLR 
H = hodlr.buildweak(Z,levels,starr,tol);
%% Add two HODLR matrices
B = hodlr.addition(H,H,tol);
%% Multiply two HODLR matrices
C = hodlr.multiplication(H,H,tol);
%% Factorize LU HODLR 
[L,U] = hodlr.LU(H,tol);
%% Solve Hx=b
hodlr.solve(H,rand(N,1),tol);
%% Visualize a HODLR matrix 
hodlr.spy(B)