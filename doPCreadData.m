clear all; clc;

%addpath 'C:\Users\Sky\Documents\Research\gasvm\test\lib' -end
javaaddpath({'C:\Users\Sky\Documents\Research\PCAMatching\matlab\libsvm.jar'}); %later it will be deprecated.

%% loading data using a switch statement; come from doPCmatchSetup.m

%ctype = 'james-cell-AE';
%ctype = 'james-cell-C18';
%ctype = 'PD-Sep-C18';
%ctype = 'Ritz_AEftrs20';
%ctype = 'Ritz_AEftrs20_afterNorm';
%ctype = 'Ritz_AEftrs20_afterNorm_lbl0vs12';
%ctype = 'Ritz_C18ftrs20';
%ctype = 'Ritz_C18ftrs20_afterNormal';
%ctype = 'Ritz_C18ftrs20_afterNormal_lbl0vs12';
%ctype = 'amd-a-injection2';
%ctype = 'amd-a-injection1';
%ctype = 'GregNMR';
%ctype = 'Neujahar_c18';
ctype = 'malaria_c';


switch (ctype)
    case 'james-cell-AE'
        xlsfname = 'C:\Users\Sky\Documents\Research\James\AEfeatures-Cellextract.xlsx';
        xlssheet = 'AllSamples';
        %AE -> PC 3, 4
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E3:BX3726'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E1:BX1');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A3:A3726'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E2:BX2');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E3727:BX3727');
        VarFilter = xlsread(xlsfname, xlssheet, 'BZ3:BZ3726');
        strLabelAll = {'Control';'MB20';'MB50';'PQ20';'PQ50';'PQMB'};
    case 'james-cell-C18'
        xlsfname = 'C:\Users\Sky\Documents\Research\James\C18features-Cellextract.xlsx';
        xlssheet = 'AllSamples';
        %AE -> PC 3, 4
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E3:BX5746'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E1:BX1');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A3:A5746'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E2:BX2');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E5747:BX5747');
        VarFilter = xlsread(xlsfname, xlssheet, 'BZ3:BZ5746');
        strLabelAll = {'Control';'MB20';'MB50';'PQ20';'PQ50';'PQMB'};
    case 'PD-Sep-C18'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\Ritz_C18ftrs_091311_sky.xls';
        xlssheet = 'ready-p';
        %AE -> PC 3, 4
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'B2:GR6712'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'B6715:GR6715');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A6712'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B1:GR1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'B6714:GR6714');
        VarFilter = xlsread(xlsfname, xlssheet, 'GT2:GT6712');
        strLabelAll = {'Control';'PD12'};
    case 'Ritz_AEftrs20'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\proposal\Ritz_NEW\AE\Ritz_AEftrs20.xlsx';
        xlssheet = 'Ritz-AEftrs';
        %AE -> PC 3, 4
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E2:HN6609'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E6612:HN6612');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A6609'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:HN1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E6611:HN6611');
        VarFilter = xlsread(xlsfname, xlssheet, 'HS2:HS6609');
        strLabelAll = {'Run1';'Run2'};
    case 'Ritz_AEftrs20_afterNorm'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\proposal\Ritz_NEW\AE\Ritz_AEftrs20.xlsx';
        xlssheet = 'normftrs';
        %AE -> PC 3, 4
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E2:HN6609'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E6612:HN6612');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A6609'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:HN1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E6611:HN6611');
        VarFilter = xlsread(xlsfname, xlssheet, 'HQ2:HQ6609');
        strLabelAll = {'Run1';'Run2'};
    case 'Ritz_AEftrs20_afterNorm_lbl0vs12'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\proposal\Ritz_NEW\AE\Ritz_AEftrs20.xlsx';
        xlssheet = 'normftrs';
        %AE -> PC 3, 4
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E2:HN6609'); %p-by-n
        %label_dataOld = xlsread(xlsfname, xlssheet, 'E6615:HN6615');%1-by-n; status 0 vs. 1 and 2
        label_dataOld = xlsread(xlsfname, xlssheet, 'E6618:HN6618');%1-by-n; status 0, 1, 2
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A6609'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:HN1');
        
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E6614:HN6614');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E6616:HN6616'); %sum_pesticides_gt_7
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E6617:HN6617'); %pqmbrot > 1
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E6620:HN6620'); %pqmbrot > 1 & status 1 and 2 only
        VarFilter = xlsread(xlsfname, xlssheet, 'HQ2:HQ6609');
        %strLabelAll = {'Control';'PD'};
        %strLabelAll = {'PD-slow';'PD-rapid'};
        strLabelAll = {'Control';'PD-slow';'PD-rapid'};
    case 'Ritz_C18ftrs20'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\proposal\Ritz_NEW\C18\Ritz_C18ftrs20.xlsx';
        xlssheet = 'resultVLgood';
        
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E2:HM7399'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E7402:HM7402');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A7399'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:HM1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E7401:HM7401');
        VarFilter = xlsread(xlsfname, xlssheet, 'HR2:HR7399');
        strLabelAll = {'Run1';'Run2'};
    case 'Ritz_C18ftrs20_afterNormal'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\proposal\Ritz_NEW\C18\Ritz_C18ftrs20.xlsx';
        xlssheet = 'normftrs';
        
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E2:HM7399'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E7402:HM7402');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A7399'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:HM1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E7401:HM7401');
        VarFilter = xlsread(xlsfname, xlssheet, 'HP2:HP7399');
        strLabelAll = {'Run1';'Run2'};
    case 'Ritz_C18ftrs20_afterNormal_lbl0vs12'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\proposal\Ritz_NEW\C18\Ritz_C18ftrs20.xlsx';
        xlssheet = 'normftrs';
        
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E2:HM7399'); %p-by-n
        %label_dataOld = xlsread(xlsfname, xlssheet, 'E7407:HM7407');%1-by-n; %0 vs. 1 and 2
        label_dataOld = xlsread(xlsfname, xlssheet, 'E7410:HM7410');%1-by-n; %0, 1, 2
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A7399'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:HM1');
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E7406:HM7406');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E7408:HM7408'); %sum_pesticides_gt_7
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E7409:HM7409'); %pqmbrot_gt_1
        VarFilter = xlsread(xlsfname, xlssheet, 'HP2:HP7399');
        %strLabelAll = {'Control';'PD'};
        %strLabelAll = {'PD-slow';'PD-rapid'};
        strLabelAll = {'Control';'PD-slow';'PD-rapid'};
    case 'amd-a-injection2'
        xlsfname = 'C:\Users\Sky\Documents\Research\AMD\feature09-A.xlsx';
        xlssheet = 'a-injection2';
        
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E5:AZ3962');
        %label_dataOld = xlsread(xlsfname, xlssheet, 'E7407:HM7407');%1-by-n; %0 vs. 1 and 2
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:AZ3');%1-by-n; %0, 1, 2
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A5:A3962'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:AZ1');
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E7406:HM7406');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E4:AZ4'); %sum_pesticides_gt_7
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E7409:HM7409'); %pqmbrot_gt_1
        VarFilter = xlsread(xlsfname, xlssheet, 'BB5:BB3962');
        strLabelAll = {'t-1';'t-2'};
        %idPCAll = [7 8];
    case 'amd-a-injection1'
        xlsfname = 'C:\Users\Sky\Documents\Research\AMD\feature09-A.xlsx';
        xlssheet = 'a-injection2';
        
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E5:AZ3962');
        %label_dataOld = xlsread(xlsfname, xlssheet, 'E7407:HM7407');%1-by-n; %0 vs. 1 and 2
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:AZ3');%1-by-n; %0, 1, 2
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A5:A3962'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:AZ1');
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E7406:HM7406');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E3964:AZ3964'); %sum_pesticides_gt_7
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E7409:HM7409'); %pqmbrot_gt_1
        VarFilter = xlsread(xlsfname, xlssheet, 'BB5:BB3962');
        strLabelAll = {'t-1';'t-2'};
        %idPCAll = [5 8];
    case 'GregNMR'
        xlsfname = 'C:\Users\Sky\Documents\Research\SAA\GredHealthyDeadData.xlsx';
        xlssheet = 'Sheet1';
        
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'C4:AT8195');
        %label_dataOld = xlsread(xlsfname, xlssheet, 'E7407:HM7407');%1-by-n; %0 vs. 1 and 2
        label_dataOld = xlsread(xlsfname, xlssheet, 'C2:AT2');%1-by-n; %0, 1, 2
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'B4:B8195'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'C3:AT3');
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E7406:HM7406');
        SampleFilter = xlsread(xlsfname, xlssheet, 'C1:AT1'); %sum_pesticides_gt_7
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E7409:HM7409'); %pqmbrot_gt_1
        VarFilter = xlsread(xlsfname, xlssheet, 'AU4:AU8189');
        strLabelAll = {'Healthy';'ICU'};
    case 'Neujahar_c18'
        xlsfname = 'C:\Users\Sky\Documents\Research\PCRselection\Neujahr_c18_102011.xlsx';
        xlssheet = 'act';
        
        dataOld = xlsread(xlsfname, xlssheet, 'E2:EB7069'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E7072:EB7072');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A7069'); %p-by-1        
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:EB1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E7071:EB7071'); %using all
        %SampleFilter = xlsread(xlsfname, xlssheet, 'E7074:EB7074'); %using only label 2
        VarFilter = xlsread(xlsfname, xlssheet, 'ED2:ED7069');
        responseOld = xlsread(xlsfname, xlssheet, 'E7073:EB7073');%1-by-n
        strLabelAll = {'No';'Yes'};
    case 'malaria_c'
        xlsfname = 'malariaData.xlsx';
        xlssheet = 'C';
        
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E4:S853'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E2:S2');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A4:A853');
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:S1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E3:S3');
        VarFilter = xlsread(xlsfname, xlssheet, 'U4:U853');
        strLabelAll = {'N';'P'};
        
        %fdrmz = xlsread(xlsfname, 'sigFtr_C', 'D1:D25');%1-by-n %Sky,
        %double-check this.
        fdrmz = xlsread(xlsfname, 'sigFtr_C', 'B1:B25');%1-by-n
end


id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1
if exist('responseOld')
    response = responseOld(1,id_sample)'; %n-by-1
end

isAutoScale = true;
isFillExpect = false;

if isFillExpect
    [data] = fillDataWithExpect(data);
end
if isAutoScale
    [data] = normalizeData(data); %n-by-p
end


P = size(data,2);
N = size(data,1);


%lbl_value_all = [1 2];
lbl_value_all = unique(label_data)';

saveresult = false;
resultshname = 'InFeature';
drawfig = true;
showSampleName = true;
drawOneSigma = true;

%graphical setting
lw = 2;
set(0, 'DefaultAxesFontSize', 15);
set(0, 'DefaultAxesFontName', 'Arial');
fs = 15;
msize = 8;

cutoff_angle = 30;
cutoff_md_quantile = 0.10;
%cutoff_md_quantile = 0.01;
%cutoff_md_quantile = 0.05;

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

highID =[]; %indices to highlight in loading plots
redrawfig = true; %redraw figures

if exist('fdrmz')
    inputmz = cell2mat(variable_name);
    highID = [];
    for kk=1:size(fdrmz,1)
        tpDiff = abs( inputmz - fdrmz(kk));
        tpid = find( tpDiff == min(tpDiff) );
        %inputmz(tpid)- fdrmz(kk)
        highID = [highID; tpid];
    end
end

