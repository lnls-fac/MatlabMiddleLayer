% Replicate a M x N dynamic system expressend on a state-space
% representation. The resulting system is a nM x nN system.
function [A,B,C,D] = replicate_ss(A,B,C,D,n)

A = replicate_matrix(A,n);
B = replicate_matrix(B,n);
C = replicate_matrix(C,n);
D = replicate_matrix(D,n);