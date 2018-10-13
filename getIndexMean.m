function [meanvec] = getIndexMean(indmat, datamat)

if nargin < 2
    indmat = [ 0 0 1 1;
               1 0 1 0;
               0 1 1 1;
               1 1 1 1;
               1 1 1 0;];
    datamat = [ 2 4 6 8;
                2 4 6 8;
                2 4 6 8;
                2 4 6 8;
                2 4 6 8];
end

n_col = sum(indmat,2);

t_sum = sum( indmat.*datamat, 2);

meanvec = t_sum ./ n_col;