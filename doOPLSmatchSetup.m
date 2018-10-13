clear all; clc;

%addpath 'C:\Users\Sky\Documents\Research\OPLS\osc\matlab' -end

%addpath 'C:\Users\Sky\Documents\Research\gasvm\test\lib' -end
%javaaddpath({'C:\Users\Sky\Documents\Research\gasvm\test\lib\libsvm.jar'});
javaaddpath({'C:\Users\Sky\Documents\Research\PCAMatching\matlab\libsvm.jar'});


%% reading data

%colname = 'alcohol';
%colname = 'nonalcohol';
%colname = 'wild';
%colname = 'vitamin-bin';
%colname = 'muscadine-0and1A';
%colname = 'muscadine-3and4A';

%colname = 'muscadine-0and3C' %code 1
%colname = 'muscadine-2and5C' %code 2
%colname = 'muscadine-1and4C' %code 3
%colname = 'muscadine-01and34C' %code 4
%colname = 'muscadine-0and1C' %code 5
%colname = 'muscadine-3and4C'; %code 6
%colname = 'PD-Sep-C18';
% colname = 'PD-SlowVSRap-Sep-C18';
% colname = 'PD-prombrot-Sep-C18';
% colname = 'PD-sum-Sep-C18';
% colname = 'amd-test5';
% colname = 'amd-gr12';
% colname = 'amd_cfh';
%colname = 'Neujahar_c18';
%colname = 'filterVit6';
colname = 'unfilterVit6';
%colname = 'James-AE-mitochon-TxWT';

%default setup for the number of orthogonal components (nOrthcomp) and that of
%predictive components (ncomp)
nOrthcomp = 1;
ncomp = 10;

switch (colname)
    case 'alcohol'
        xlsfname = 'C:\Users\Sky\Documents\Research\Alcohol\serum-alcohol.xlsx';
        xlssheet = 'alcohol';
        %idPCAll = [1 2];
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E5:AB1399'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:AB3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A5:A1399'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:AB1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E4:AB4');
        VarFilter = xlsread(xlsfname, xlssheet, 'AD5:AD1399');
        strLabelAll = {'tg';'wt'};
    case 'nonalcohol'
        xlsfname = 'C:\Users\Sky\Documents\Research\Alcohol\serum-nonalcohol.xlsx';
        xlssheet = 'nonalcohol';
        %PC 2 4 or PC 4 6
        %idPCAll = [2 4]; 2	4	0.904	0.809	0.813
        %idPCAll = [4 6]; 4	6	0.827	0.83	0.802
        %data labelY variable_name sample_name score_data loading_data
        dataOld = xlsread(xlsfname, xlssheet, 'E5:BD1399'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:BD3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A5:A1399'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:BD1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E4:BD4');
        VarFilter = xlsread(xlsfname, xlssheet, 'BF5:BF1399');
        strLabelAll = {'tg';'wt'};
    case 'wild'
        xlsfname = 'C:\Users\Sky\Documents\Research\Alcohol\serum-wild.xlsx';
        xlssheet = 'wild';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E5:AZ1399'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:AZ3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A5:A1399'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:AZ1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E4:AZ4');
        VarFilter = xlsread(xlsfname, xlssheet, 'BB5:BB1399');
        strLabelAll = {'NonAC';'AC'};
    case 'vitamin-bin'
        xlsfname = 'C:\Users\Sky\Documents\Research\vitamine\data\bin_all-a.xlsx';
        xlssheet = 'dataScaled';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'B3:AV7614'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'B1:V1');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A3:A7614'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B2:V2');
        SampleFilter = ones(1, size(dataspecOld,2));
        VarFilter = ones(size(dataOld,1),1);
        strLabelAll = {'GR1';'GR2'};
    case 'muscadine-0and1A'
        xlsfname = 'C:\Users\Sky\Documents\Research\muscadiine\Mus\A_mus.xlsx';
        xlssheet = 'DataUsed2';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'C3:CD2061'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'C4:CD4');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A5:A2061'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'C2:CD2');
        SampleFilter = xlsread(xlsfname, xlssheet, 'C2074:CD2074');
        VarFilter = xlsread(xlsfname, xlssheet, 'CF5:CF2061');
        strLabelAll = {'GR0';'GR1'};
        nOrthcomp = 3; %three orthogonal components are enough
        ncomp = 10;
    case 'muscadine-3and4A'
        xlsfname = 'C:\Users\Sky\Documents\Research\muscadiine\Mus\A_mus.xlsx';
        xlssheet = 'DataUsed2';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'C3:CD2061'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'C4:CD4');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A5:A2061'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'C2:CD2');
        SampleFilter = xlsread(xlsfname, xlssheet, 'C2075:CD2075');
        VarFilter = xlsread(xlsfname, xlssheet, 'CF5:CF2061');
        strLabelAll = {'GR3';'GR4'};
        nOrthcomp = 3; %three orthogonal components are enough
        ncomp = 10;
    case 'muscadine-0and3C' %code 1
        xlsfname = 'C:\Users\Sky\Documents\Research\muscadiine\Mus\ModelC18_010511.xls';
        xlssheet = 'DataUsed';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E4:CF5788'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:CF3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A4:A5788'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:CF1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E5803:CF5803'); %code 1
        VarFilter = xlsread(xlsfname, xlssheet, 'CH4:CH5788');
        strLabelAll = {'GR0';'GR3'};
        nOrthcomp = 3; %three orthogonal components are enough
        ncomp = 10;

    case 'muscadine-2and5C' %code 2
        xlsfname = 'C:\Users\Sky\Documents\Research\muscadiine\Mus\ModelC18_010511.xls';
        xlssheet = 'DataUsed';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E4:CF5788'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:CF3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A4:A5788'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:CF1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E5804:CF5804'); %code 2
        VarFilter = xlsread(xlsfname, xlssheet, 'CH4:CH5788');
        strLabelAll = {'GR2';'GR5'};
        nOrthcomp = 3; %three orthogonal components are enough
        ncomp = 10;
    case 'muscadine-1and4C' %code 3
        xlsfname = 'C:\Users\Sky\Documents\Research\muscadiine\Mus\ModelC18_010511.xls';
        xlssheet = 'DataUsed';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E4:CF5788'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:CF3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A4:A5788'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:CF1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E5805:CF5805'); %code 3
        VarFilter = xlsread(xlsfname, xlssheet, 'CH4:CH5788');
        strLabelAll = {'GR1';'GR4'};
        nOrthcomp = 3; %three orthogonal components are enough
        ncomp = 10;
    case 'muscadine-1and4C-2nd' %code 3
        xlsfname = 'C:\Users\Sky\Documents\Research\muscadiine\Mus\ModelC18_010511.xls';
        xlssheet = 'DataUsed';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E4:CF5788'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:CF3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A4:A5788'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:CF1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E5805:CF5805'); %code 3
        VarFilter = xlsread(xlsfname, xlssheet, 'CH4:CH5788');
        strLabelAll = {'GR0-1';'GR3-4'};
        nOrthcomp = 3; %three orthogonal components are enough
        ncomp = 10;
    case 'muscadine-01and34C' %code 4
        xlsfname = 'C:\Users\Sky\Documents\Research\muscadiine\Mus\ModelC18_010511.xls';
        xlssheet = 'DataUsed';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E4:CF5788'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E5807:CF5807');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A4:A5788'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:CF1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E5806:CF5806'); %code 4
        VarFilter = xlsread(xlsfname, xlssheet, 'CH4:CH5788');
        strLabelAll = {'GR0-1';'GR3-4'};
        nOrthcomp = 3; %three orthogonal components are enough
        ncomp = 10;
    case 'muscadine-0and1C' %code 5
        xlsfname = 'C:\Users\Sky\Documents\Research\muscadiine\Mus\ModelC18_010511.xls';
        xlssheet = 'DataUsed';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E4:CF5788'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:CF3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A4:A5788'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:CF1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E5801:CF5801'); %code 5
        VarFilter = xlsread(xlsfname, xlssheet, 'CH4:CH5788');
        strLabelAll = {'GR0';'GR1'};
        nOrthcomp = 3; %three orthogonal components are enough
        ncomp = 10;
    case 'muscadine-3and4C' %code 6
        xlsfname = 'C:\Users\Sky\Documents\Research\muscadiine\Mus\ModelC18_010511.xls';
        xlssheet = 'DataUsed';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E4:CF5788'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:CF3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A4:A5788'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:CF1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E5802:CF5802');
        VarFilter = xlsread(xlsfname, xlssheet, 'CH4:CH5788');
        strLabelAll = {'GR3';'GR4'};
        nOrthcomp = 3; %three orthogonal components are enough
        ncomp = 10;
    case 'PD-Sep-C18'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\Ritz_C18ftrs_091311_sky.xls';
        xlssheet = 'ready-p';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'B2:GR6712'); %p-by-n\\
        label_dataOld = xlsread(xlsfname, xlssheet, 'B6715:GR6715');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A6712'); %p-by-1
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B1:GR1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'B6714:GR6714');
        VarFilter = xlsread(xlsfname, xlssheet, 'GT2:GT6712');
        strLabelAll = {'Control';'PD12'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;
    case 'PD-SlowVSRap-Sep-C18'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\Ritz_C18ftrs_091311_sky.xls';
        xlssheet = 'ready-p';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'B2:GR6712'); %p-by-n\\
        label_dataOld = xlsread(xlsfname, xlssheet, 'B6718:GR6718');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A6712'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B1:GR1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'B6717:GR6717');
        VarFilter = xlsread(xlsfname, xlssheet, 'GT2:GT6712');
        strLabelAll = {'PD-Slow';'PD-Rap'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;
    case 'PD-prombrot-Sep-C18'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\Ritz_C18ftrs_091311_sky.xls';
        xlssheet = 'ready-p';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'B2:GR6712'); %p-by-n\\
        label_dataOld = xlsread(xlsfname, xlssheet, 'B6720:GR6720');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A6712'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B1:GR1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'B6714:GR6714');
        VarFilter = xlsread(xlsfname, xlssheet, 'GT2:GT6712');
        strLabelAll = {'NoPQ';'AnyPQ'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;
    case 'PD-sum-Sep-C18'
        xlsfname = 'C:\Users\Sky\Documents\Research\PD\Ritz_C18ftrs_091311_sky.xls';
        xlssheet = 'ready-p';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'B2:GR6712'); %p-by-n\\
        label_dataOld = xlsread(xlsfname, xlssheet, 'B6722:GR6722');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A6712'); %p-by-1
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B1:GR1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'B6714:GR6714');
        VarFilter = xlsread(xlsfname, xlssheet, 'GT2:GT6712');
        strLabelAll = {'SumLT5';'SumGT6'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;
    case 'amd-a-injection2'
        xlsfname = 'E:\YJ\AMD\feature09-A.xlsx';
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
        strLabelAll = {'t-1';'t-2';'t-3'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;
    case 'amd-test5'
        xlsfname = 'C:\Users\Sky\Documents\Research\AMD\AMD_A_real.xlsx';
        xlssheet = 'delete-samples';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E6:EG1685'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E1689:EG1689');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A6:A1685'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E5:EG5');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E1690:EG1690');
        VarFilter = xlsread(xlsfname, xlssheet, 'EI6:EI1685');
        strLabelAll = {'Control';'AMD'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;  
    case 'amd-gr12'
        xlsfname = 'C:\Users\Sky\Documents\Research\AMD\AMD_A_real.xlsx';
        xlssheet = 'delete-samples';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'E6:EG1685'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E3:EG3');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A6:A1685'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E5:EG5');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E1:EG1');
        VarFilter = xlsread(xlsfname, xlssheet, 'EI6:EI1685');
        strLabelAll = {'Control';'AMD'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;
    case 'amd_cfh'
        xlsfname = 'C:\Users\Sky\Documents\Research\AMD\Gene-Sky.xlsx';
        xlssheet = 'dataall';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        dataOld = xlsread(xlsfname, xlssheet, 'B2:ED1169'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'B1172:ED1172');%1-by-n
        %label_dataOld = xlsread(xlsfname, xlssheet, 'B1174:ED1174');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A1169'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B1:ED1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'B1175:ED1175');
        VarFilter = xlsread(xlsfname, xlssheet, 'EG2:EG1169');
        fdrmz = xlsread(xlsfname, 'CFH_loading', 'P1:P94');%1-by-n
        strLabelAll = {'CFH TT+TC';'CFH CC'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;        
    case 'Neujahar_c18'
        xlsfname = 'C:\Users\Sky\Documents\Research\PCRselection\Neujahr_c18_102011.xlsx';
        xlssheet = 'act';
        
        dataOld = xlsread(xlsfname, xlssheet, 'E2:EB7069'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'E7072:EB7072');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A7069'); %p-by-1        
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'E1:EB1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E7071:EB7071');
        VarFilter = xlsread(xlsfname, xlssheet, 'ED2:ED7069');
        responseOld = xlsread(xlsfname, xlssheet, 'E7073:EB7073');%1-by-n
        strLabelAll = {'No';'Yes'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;        
    case 'filterVit6'
        xlsfname = 'G:\Pulmonary\Research\Jones Lab\Sky\bin_1st_2nd combined.xls';
        xlssheet = 'factored-pir';
        
        dataOld = xlsread(xlsfname, xlssheet, 'B2:AR7613'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'B7614:AR7614');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A7613'); %p-by-1        
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B1:AR1');
        SampleFilter = ones(1, size(dataOld,2));
        VarFilter = ones(size(dataOld,1),1);
        
        strLabelAll = {'b';'a'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;        
        %cutoff_md_quantile=0.01
        
    case 'unfilterVit6'
        xlsfname = 'G:\Pulmonary\Research\Jones Lab\Sky\VB_preprocessed2_del082711.xls';
        xlssheet = 'factored-pi';
        
        dataOld = xlsread(xlsfname, xlssheet, 'B2:AU12934'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'B12935:AU12935');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A12934'); %p-by-1        
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B1:AU1');
        SampleFilter = ones(1, size(dataOld,2));
        VarFilter = ones(size(dataOld,1),1);
        
        strLabelAll = {'b';'a'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;        
        %cutoff_md_quantile=0.01
    case 'James-AE-mitochon-TxWT'
        xlsfname = 'C:\Users\Sky\Documents\Research\PCAMatching\ref\jamesWTTG\AE-WTvsTGmitochondria-males.xlsx';
        xlssheet = 'data';
        
        dataOld = xlsread(xlsfname, xlssheet, 'C3:S1486'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'C1:S1');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A3:A1486'); %p-by-1        
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'C2:S2');
        SampleFilter = ones(1, size(dataOld,2));
        VarFilter = xlsread(cfname, cshname, 'T3:T1486');
        
        strLabelAll = {'WT';'Tx'};
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;        
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

lbl_value_all = unique(label_data)';

%right now it deals with two labels
cls0 = find(label_data == lbl_value_all(1));
cls1 = find(label_data == lbl_value_all(2));

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

%% testing DOSC with pls
zdata = zscore(data);

%temporal setup for the sake of testing.
%Override them only when it is testing.
%nOrthcomp = 3; %three orthogonal components are enough
%ncomp = 10;
tpResponseToUse = label_data;
if exist('response')
    tpResponseToUse = response;
end

[Z,W,Pv,T] = dosc(zdata,tpResponseToUse,nOrthcomp,1E-3);
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] = plsregress(Z,label_data,ncomp);
fprintf('The percentage of variance by orthogonal:%.5f\n', 1-trace(Z*Z')/trace(zdata*zdata'));
%PCTVAR has the 1st row for X variation and the 2nd row for Y variation

figure(11); clf;
plot(T(cls0,1), XS(cls0,1), 'or'); hold on;
plot(T(cls1,1), XS(cls1,1), 'xb');
xlabel('1st Orthogonal Component'); ylabel('1st Predictive Component');

figure(12); clf;
plot(XS(cls0,1), XS(cls0,2), 'or'); hold on;
plot(XS(cls1,1), XS(cls1,2), 'xb');
xlabel('1st Predictive Component'); ylabel('2nd Predictive Component');


if nOrthcomp > 1
    figure(13); clf;
    plot(T(cls0,1), T(cls0,2), 'or'); hold on;
    plot(T(cls1,1), T(cls1,2), 'xb');
    xlabel('1st Orthogonal Component'); ylabel('2nd Orthogonal Component');
end
figure(21); clf;
%plot(zscore(P), zscore(XL(:,1)),'.');
plot(Pv(:,1), XL(:,1),'.');
% doPCMatching related setup

P = size(data,2);
N = size(data,1);

%strLabelAll = {'tg';'wt'};
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
%cutoff_md_quantile = 0.10;
cutoff_md_quantile = 0.05;

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%old setup at default
% idPCAll = [1 2];
% score_data = [T XS];
% loading_data = [Pv XL]/1e5;
% %score_data = [T(:,1) XS(:,1)];
% %loading_data = [Pv, XL(:,1)]/1e5;
%new setup at default
idPCAll = [1 2];
%includeOrthComp = false;
includeOrthComp = true;
if includeOrthComp
    score_data = [T XS];
    loading_data = [Pv XL]/1e5;
else
    score_data = [XS];
    loading_data = [XL]/1e5;
end

%uncomment and use the following only when it needs to override the above
% switch (colname)
%     case 'muscadine-0and1A'
%         idPCAll = [1 2];
%         score_data = [XS];
%         loading_data = [XL]/1e5;
%     case 'muscadine-3and4A'
%         idPCAll = [1 2];
%         score_data = [XS];
%         loading_data = [XL]/1e5;
% end

if exist('response')
    figure(19); clf; hold on;
    xlabel('1st Orthogonal Component'); ylabel('1st Predictive Component');
    %scatter(T(:,1), XS(:,1), 8, response, 'filled');
    %scatter(T(:,1), XS(:,1), 70, sqrt(response), 's','filled', 'MarkerEdgeColor', 'k');
    %scatter(T(:,1), XS(:,1), 70, sqrt(response), '^','filled');
    scatter(T(cls0,1), XS(cls0,1), 90, sqrt(response(cls0)), '^','filled');
    scatter(T(cls1,1), XS(cls1,1), 90, sqrt(response(cls1)), 's','filled');
    colorbar
    %plot(T(cls0,1), XS(cls0,1), 'ob', 'MarkerSize', 13); 
    %plot(T(cls1,1), XS(cls1,1), 'sr', 'MarkerSize', 13); 
end



