function [ctdata] = centerData(data)

TotN = size(data,1);
totP = size(data,2);

MeanMat = repmat(mean(data), TotN,1);
ctdata = (data - MeanMat);