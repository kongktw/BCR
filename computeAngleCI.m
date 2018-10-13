function [avgVec, cutoff_angle] = computeAngleCI(scores, response)


[respSort, IDX] = sort(response, 'ascend');
scoresSort = scores(IDX, :);

angleAll = zeros(size(respSort,1),1);
for kk=1:size(respSort,1)
    for pp=kk+1:size(respSort,1)
        tpVec1 = scoresSort(kk,:);
        tpVec2 = scoresSort(pp,:);
        tpDiffNorm = (tpVec2 - tpVec1)/sqrt( (tpVec2 - tpVec1)'*(tpVec2 - tpVec1) );
        angleAll(kk,1) = tpDiffNorm %to-do more here!!
    end
end