1. Synthetic Layers Data and Tests
(1) test_simulationTest1.m
 three layers + noise layer
(2) test_simulationTest2.m
 two layers + noise layer
(3) test_simulationTest3.m
 one layer + noise layer
(4) test_simulationTest4.m
 noise layer


2. getVarIndexPCMatchNew.m
%
% the main implementation of the PCLS logic.
% The major parameters set by Params are as follows:
% Params.score_data : the score matrix (n-by-k)
%
% Params.loading_data : the loading matrix (p-by-k). By default, it is recommended to be the first predictive component and the first
% orthogonal component. 
%
% Params.idPCAll : the indices of the used components in loading_data. By default, it is
% set by [1 2].
%
% Params.label_data: the class label information
%
% Params.lbl_value_all: the unique label letters in label_data. By default,
% it is recommended to be set by lbl_value_all = unique(label_data)'
%
% Params.curLblnum: the label among Params.lbl_value_all to draw an ellipsoid for the scores
%
% Params.show_lbl_nums: the the label among Params.lbl_value_all to
% highlight in the figure
%
% Params.cutoff_angle (deprecated): it will be calculated and replaced by the scores inside. 
%
% Params.cutoff_md_quantile: The (covariance) magnitude in terms of the top-quantile percentage to select variables by.  By default, it is recommended to be set by cutoff_md_quantile = 0.05
% 
% Params.filterIndvLevel: the post filtering step by logistic regression
% (default) or simple regression (usually for numerical variables). By
% defautl, it is recommended to be set by Params.filterIndvLevel = 0.1;
%
% Params.alpha: to remove outliers when drawing an ellipsoid for stability.
% As an internal parameter, it can be 0.01 or 0.05.
%
% 
% idx_inside : the selected variable indices
%
% 
% The followings parameters are for the visualization purpose.
% Params.drawfig
% Params.drawfig2
% Params.sample_name
% Params.strLabelAll
% Params.showSampleName
% Params.drawOneSigma
% Params.showVarName
% Params.showArrows
% Params.redrawfig
% Params.showMessage
% 


3. TG-WT metabolomics application
(1)  AE-WTvsTGmitochondria-males.xlsx
It contains the TG-WT metabolomics data.

(2) test_AE_WT.m
doOPCreadData
doOPCInitialCheckup
doFirstLabelMatch
doSecondLabelMatch
doSaveTwoLabelsMatch



(3) the individual flows of test_AE_WT.m are as follows.
1) doOPCreadData.m
 It defines a dataset to be used in the PCLS. Refer to the sample Excel file (AE-WTvsTGmitochondria-males.xlsx).
2) doOPCInitialCheckup.m
 It performs direct-orthgonal signal correction for the dataset and defines the parameters of the PCLS.
3) doFirstLabelMatch.m
 It matches the scores with the first label and find associated variables.
4) doSecondLabelMatch.m
 It matches the scores with the second label and find associated variables..
5) doSaveTwoLabelsMatch.m
 It saves the variables for the two labels.

%doMatchForGraph.m %to draw a figure with both significant-labeled loading data
%dir *.csv  %to see the saved files



(4) the usual PCLS steps are as follows. Please refer to test_simulationTest1.m.


idPCAll = [1 2];

[Z,W,Pv,T] = dosc(data,label_data,1,1E-3);
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] = plsregress(Z,label_data,1);

score_data = [T XS];
loading_data = [Pv XL]/1e5;


drawfigclsf = false;
drawfig = false;
showSampleName = true;
drawOneSigma = false;

Params.score_data = score_data;
Params.loading_data = loading_data;
Params.idPCAll = idPCAll;
Params.label_data = label_data;
Params.lbl_value_all = unique(label_data)';
Params.cutoff_md_quantile = tpcurlev; % Out of 64, 20/28 found.

Params.drawfig = drawfig;
Params.sample_name = sample_name;
Params.strLabelAll = strLabelAll;
Params.showSampleName = showSampleName;
Params.drawOneSigma = drawOneSigma;
Params.alpha = curalpha;
Params.filterIndvLevel = 0.1;
Params.dataXorig = data;
Params.filterIndvMethod = 'LinearRegression';

doPCLS_PCDrawing = false;
if doPCLS_PCDrawing
    Params.drawfig = true;
    Params.showSampleName = false;
    Params.highID = 1:30;

    Params.redrawfig = true
end

Params.curLblnum = 1;
[idx_inside1, Angles1, MDistSq1, cutoff_angle1, cutoff_dist1, outlier_id1, sampleInsidePval1, curLbl1, idx_filteredOutInfo1]= getVarIndexPCMatchNew(Params);

Params.curLblnum = 2;
[idx_inside2, Angles2, MDistSq2, cutoff_angle2, cutoff_dist2, outlier_id2, sampleInsidePval2, curLbl2, idx_filteredOutInfo2]= getVarIndexPCMatchNew(Params);


%Then, idx_inside1 contains the indices of the selected variables for label 1, idx_inside2 for label 2.
