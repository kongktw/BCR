
clear all; clc;




%% reading data; came from doOPLSmatchSetup.m


%colname = 'James-AE-mitochon-TxWT';
colname = 'James-AE-mitochon-TxWTall';


%default setup for the number of orthogonal components (nOrthcomp) and that of
%predictive components (ncomp)
nOrthcomp = 1;
ncomp = 10;

switch (colname)

    case 'James-AE-mitochon-TxWT'
        %xlsfname = 'C:\Users\qsoltow\Desktop\matlab\AE-WTvsTGmitochondria-males.xlsx';
        xlsfname = 'AE-WTvsTGmitochondria-males.xlsx';        
        xlssheet = 'data';
        
        dataOld = xlsread(xlsfname, xlssheet, 'C3:S1486'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'C1:S1');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A3:A1486'); %p-by-1        
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'C2:S2');
        SampleFilter = ones(1, size(dataOld,2));
        VarFilter = xlsread(xlsfname, xlssheet, 'T3:T1486');
        
        strLabelAll = {'WT';'Tx'};
        
        nOrthcomp = 1; %three orthogonal components are enough
        ncomp = 10;        
    case 'James-AE-mitochon-TxWTall'
        xlsfname = 'AE-WTvsTGmitochondria-males.xlsx';  
        xlssheet = 'dataall';
        
        dataOld = xlsread(xlsfname, xlssheet, 'C3:AM1486'); %p-by-n
        label_dataOld = xlsread(xlsfname, xlssheet, 'C1:AM1');%1-by-n
        [ndata, ntext, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A3:A1486'); %p-by-1        
        [ndata, ntext, sample_nameOld]= xlsread(xlsfname, xlssheet, 'C2:AM2');
        SampleFilter = ones(1, size(dataOld,2));
        VarFilter = xlsread(xlsfname, xlssheet, 'AN3:AN1486');
        
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


isAutoScale = true;
if isAutoScale
    zdata = zscore(data);
else
    zdata = data;
end
