function [datanorm] = normalizeData(data)

TotN = size(data,1);
totP = size(data,2);

MeanMat = repmat(mean(data), TotN,1);
stdv = std(data);
stdv(find(stdv==0)) = 1; %let us replace 0 with 1
InvStdMat = repmat(stdv.^(-1), TotN,1);
datanorm = (data - MeanMat).*InvStdMat;