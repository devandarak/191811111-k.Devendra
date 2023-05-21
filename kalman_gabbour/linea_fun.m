function[D] = linea_fun(P,eps,num)

origSz = size(P);

e1 = mod(origSz(1),num);
if e1~=0
    P(origSz(1)+ num - e1,1) = 0;
end

e2 = mod(origSz(2),num);
if e2~=0
    P(1,origSz(2)+ num - e2) = 0;
end

sz = size(P);

X = matrix_mapp(num);
Xt = X';

zcount = 0;
compZ = 0;

for m=0:num:(sz(1)-num)
    for n=0:num:(sz(2)-num)

        for i=1:(num)
            for j=1:(num)
                E(i,j) = P(m+i,n+j);
            end
        end
        %%%%%refinement and quantiztion portion
  
        T = Xt*double(E)*X;

        for i = 1:num
            for j = 1:num
                if abs(T(i,j)) < eps
                     T(i,j) = 0.0;
                     zcount = zcount + 1;
                end
            end
        end

        compZ = compZ + countzeros(T);
       
        R = X*T*Xt;

        for i=1:(num)
            for j=1:(num)
                S(m+i,n+j) = R(i,j); 
            end
        end
            

    end
        
end
S = uint8(S);
origZ = countzeros(P);
compZ = compZ - origSz(1) * (num-e1) - origSz(2) * (num-e2) - (num-e2)*(num-e1);

for i=1:origSz(1)
    for j=1:origSz(2)
        D(i,j) = S(i,j);
    end
end
