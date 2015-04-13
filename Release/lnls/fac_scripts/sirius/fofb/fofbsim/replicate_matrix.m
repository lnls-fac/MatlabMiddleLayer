% Replicates matrix along the diagonal
function new_A = replicate_matrix(A,n)

new_A = zeros(n*size(A,1),n*size(A,2));

n_lin = size(A,1);
n_col = size(A,2);

for i=1:n
    new_A((i-1)*n_lin+1:i*n_lin, (i-1)*n_col+1:i*n_col) = A;
end