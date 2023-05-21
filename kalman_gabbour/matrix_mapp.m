function[X] = matrix_mapp(n)

lmax = 0;
%%%order allignment
for i=1:n
    if mod(n,2^i) == n
        lmax = i-1;
        break;
    end
end

X = 1;

for i=1:lmax
    %%%%%%main LIS process operation
    X = X*level_matrix(n,i);
end