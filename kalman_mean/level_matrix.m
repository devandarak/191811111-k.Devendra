function[X] = level_matrix(n,level)

% main work of LIS..here decomposed portion (wavelet coefficient not taken)
% we considering non zero elements  which is above zero and assigning them into some modified
% values in each row and colums

if level == 1
    for col = 1:n/2
        X((col-1)*2 +1,col) = 1/sqrt(2);
        X((col-1)*2 +2,col) = 1/sqrt(2);    
    end

    for col = n/2+1:n
        X((col-1)*2 +1 - n,col) = 1/sqrt(2);
        X((col-1)*2 +2 - n ,col) = -1/sqrt(2);    
    end
else
    ac = n/(2.^(level-1));
    X = level_matrix(ac,1);
    for i = ac+1:n
        X(i,i) = 1;
    end
end
