%% match score and loading in case princomp is not used; from doPCmatchInternal.m
clear Params
Params.score_data = score_data;
Params.loading_data = loading_data;
Params.idPCAll = idPCAll;
Params.label_data = label_data;
Params.lbl_value_all = lbl_value_all;
%Params.curLblnum = curLblnum;
%Params.cutoff_angle = cutoff_angle; %no longer used
Params.cutoff_md_quantile = cutoff_md_quantile;
Params.drawfig = drawfig;
showSampleOrderNum = false;
if showSampleOrderNum
    Params.sample_name = num2str((1:size(sample_name,1))');
else
    Params.sample_name = sample_name;
end

Params.strLabelAll = strLabelAll;
Params.showSampleName = false;
%Params.showSampleName = true;
%Params.drawOneSigma = drawOneSigma;
%Params.drawOneSigma = true;
Params.drawOneSigma = false;

Params.scale = 1000;



if exist('highID')
    Params.highID = highID; %indices to highlight in loading plots; from the variable of fdrmz
end

if exist('redrawfig')
    Params.redrawfig = redrawfig; %redraw figures
end
    

%Params.curLblnum = 1;
Params.curLblnum = lbl_value_all(1);

[idx_inside1, Angles1, MDistSq1, cutoff_angle1, cutoff_dist1, outlier_id1, sampleInsidePval1]= getVarIndexPCMatchNewFigureWith(Params);