%% label 2; came from doPCmatchInternal.m
%Params.curLblnum = 2;
Params.curLblnum = lbl_value_all(2);

% Params.redrawfig = false;
% %Params.redrawfig = true;
% %Params.plotallloading = true;
% Params.plotallloading = false;

%Params.redrawfig = false;
%Params.drawOneSigma = true;

[idx_inside2, Angles2, MDistSq2, cutoff_angle2, cutoff_dist2, outlier_id2, sampleInsidePval2]=getVarIndexPCMatchNewFigure(Params);
