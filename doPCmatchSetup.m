clear all; clc;

addpath 'C:\Users\Sky\Documents\Research\gasvm\test\lib' -end
javaaddpath({'C:\Users\Sky\Documents\Research\gasvm\test\lib\libsvm.jar'});
%addpath 'c:\Users\sky\Documents\gatech\research_others\YJ\gasvm\test\lib\' -end
%javaaddpath({'c:\Users\sky\Documents\gatech\research_others\YJ\gasvm\test\lib\libsvm.jar'});

%% reading malariaData data 
xlsfname = 'malariaData.xlsx';
xlssheet = 'C';

%data labelY variable_name sample_name score_data loading_data
data = xlsread(xlsfname, xlssheet, 'E4:S853'); %p-by-n
label_data = xlsread(xlsfname, xlssheet, 'E2:S2');%1-by-n
variable_name = xlsread(xlsfname, xlssheet, 'A4:A853');
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E1:S1');
SampleFilter = xlsread(xlsfname, xlssheet, 'E3:S3');
VarFilter = xlsread(xlsfname, xlssheet, 'U4:U853');

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = {'N';'P'};
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

%cutoff_angle = 30;
cutoff_md_quantile = 0.05;

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;


%% reading parkinson data

AsType = 'C';

switch AsType
    case 'A'
        xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\Parkins\A-parkinson.xls';
        xlssheet = 'feature';
        
        data = xlsread(xlsfname, xlssheet, 'E4:DT1811'); %p-by-n
        label_data = xlsread(xlsfname, xlssheet, 'E2:DT2');%1-by-n
        variable_name = xlsread(xlsfname, xlssheet, 'A4:A1811');
        [ndata, sample_name]= xlsread(xlsfname, xlssheet,'E1812:DT1812');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E1:DT1');
        VarFilter = xlsread(xlsfname, xlssheet, 'DW4:DW1811');

    case 'C'
        xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\Parkins\C-Parkinson.xls';
        xlssheet = 'feature';
        
        %data labelY variable_name sample_name score_data loading_data
        data = xlsread(xlsfname, xlssheet, 'E5:DT1255'); %p-by-n
        label_data = xlsread(xlsfname, xlssheet, 'E2:DT2');%1-by-n
        variable_name = xlsread(xlsfname, xlssheet, 'A5:A1255');
        [ndata, sample_name]= xlsread(xlsfname, xlssheet,'E1226:DT1226');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E1:DT1');
        VarFilter = xlsread(xlsfname, xlssheet, 'DW5:DW1255');
end



id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = {'Case';'Control'};
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;



%% reading lung cancer data
xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\LungCancer\EmoryLungCancerV1.xlsx';
xlssheet = 'LCData';

%data labelY variable_name sample_name score_data loading_data
data = xlsread(xlsfname, xlssheet, 'C2:P341'); %p-by-n
label_data = xlsread(xlsfname, xlssheet, 'C342:P342');%1-by-n
[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A2:A341'); %p-by-1 
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'C1:P1');
SampleFilter = ones(1,14);
VarFilter = ones(340,1);

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = {'Control';'Case'};
lbl_value_all = [1 2];

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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%% reading lung cancer data 2nd (June 20)
xlsfname = 'C:\Users\Sky\Documents\Research\LungCancer\ListLungCancerCompdsV4_6_15_11.xlsx';
xlssheet = 'LungCancerData0s';

%data labelY variable_name sample_name score_data loading_data
%data = xlsread(xlsfname, xlssheet, 'C2:BB422'); %p-by-n
data = xlsread(xlsfname, xlssheet, 'BO2:DN422'); %p-by-n
label_data = xlsread(xlsfname, xlssheet, 'C426:BB426');%1-by-n
[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A2:A422'); %p-by-1 
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'C1:BB1');
%SampleFilter = ones(1,52);
%SampleFilter = xlsread(xlsfname, xlssheet, 'C429:BB429');
SampleFilter = xlsread(xlsfname, xlssheet, 'C430:BB430');

VarFilter = ones(421,1);

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = {'Control';'Case'};
lbl_value_all = [1 2];

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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%% reading Coca-Cola data
xlsfname = 'C:\Users\Sky\Documents\Research\LungCancer\Compounds-36s3v.xlsx';
xlssheet = 'data1';

%data labelY variable_name sample_name score_data loading_data
%data = xlsread(xlsfname, xlssheet, 'C2:BB422'); %p-by-n
data = xlsread(xlsfname, xlssheet, 'A2:DD332'); %p-by-n
label_data = xlsread(xlsfname, xlssheet, 'A334:DD334');%1-by-n
%[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A2:A422'); %p-by-1 
variable_name = num2str((1:331)'); %p-by-1 
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'A1:DD1');
%SampleFilter = ones(1,52);
%SampleFilter = xlsread(xlsfname, xlssheet, 'C429:BB429');
SampleFilter = xlsread(xlsfname, xlssheet, 'A335:DD335');

VarFilter = ones(331,1);

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = {'Control';'Case'};
lbl_value_all = [1 3];

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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%% reading lung-cancer 3rd (July 5)
xlsfname = 'C:\Users\Sky\Documents\Research\LungCancer\ListLungCancerCompdsV56_30_11.xlsx';
xlssheet = 'data';

%data labelY variable_name sample_name score_data loading_data
%data = xlsread(xlsfname, xlssheet, 'C2:BB422'); %p-by-n
data = xlsread(xlsfname, xlssheet, 'D3:BC340'); %p-by-n
label_data = xlsread(xlsfname, xlssheet, 'C1:BC1');%1-by-n
[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'B3:B340'); %p-by-1 
%variable_name = num2str((1:331)'); %p-by-1 
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'D2:BC2');
%SampleFilter = ones(1,52);
%SampleFilter = xlsread(xlsfname, xlssheet, 'C429:BB429');
SampleFilter = ones(52,1);

%VarFilter = ones(331,1);
VarFilter = xlsread(xlsfname, xlssheet, 'A3:A340');

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = {'Control';'Case'};
lbl_value_all = [1 2];

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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;


%% reading lung-cancer & breast-cancer 4th (July 13)
load C:\Users\Sky\Documents\Research\LungCancer\BLcomm.mat
%save('BLcomm.mat', 'rt_comm', 'vn_comm', 'data_comm', 'label_comm', 'sname_comm');
 
data = data_comm'; %n-by-p
label_data = label_comm'; %n-by-1
variable_name = vn_comm; %p-by-1
sample_name = sname_comm'; %n-by-1

[I J] = ind2sub( size(data), find( isnan( data(:)) ));
for kk=1:length(I)
    data(I(kk), J(kk)) = 0;
end

isAutoScalse = true;
isFillExpect = false;
%isFillExpect = false;
if isFillExpect
    [data] = fillDataWithExpect(data);
end
if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

% 1 - control(B), 2 - BC, 3- Control (L), 4 - LC
strLabelAll = {'ContB';'BC';'ContL';'LC'};
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

% xlim([-3 8])
% ylim([-5 10])
% zlim([-10 12])


%% reading James WT, TG 
xlsfname = 'C:\Users\Sky\Documents\Research\James\WTandTG.xlsx';

% xlssheet = 'AE';
% %AE
% %data labelY variable_name sample_name score_data loading_data
% %data = xlsread(xlsfname, xlssheet, 'C2:BB422'); %p-by-n
% data = xlsread(xlsfname, xlssheet, 'C3:AM1486'); %p-by-n
% label_data = xlsread(xlsfname, xlssheet, 'C1:AM1');%1-by-n
% [ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A3:A1486'); %p-by-1 
% if length(variable_name) == 0
%     %variable_name = num2str(ndata);
%     variable_name  = cell(size(ndata,1),1);
%     for yy=1:size(ndata,1)
%         variable_name(yy) = num2cell(ndata(yy));
%     end    
% end
% %it can be of a string type. Let us use a cell type. March 17 2011
% [ndata, sample_name]= xlsread(xlsfname, xlssheet, 'C2:AM2');
% if length(sample_name) == 0
%     sample_name  = cell(size(ndata,1),1);
%     for yy=1:size(ndata,2)
%         sample_name(yy) = num2cell(ndata(yy));
%     end    
% end
% %SampleFilter = xlsread(xlsfname, xlssheet, 'C429:BB429');
% SampleFilter = ones(length(label_data),1);
% VarFilter = xlsread(xlsfname, xlssheet, 'AO3:AO1486');


xlssheet = 'C18';
%AE
%data labelY variable_name sample_name score_data loading_data
data = xlsread(xlsfname, xlssheet, 'C2:BB422'); %p-by-n
data = xlsread(xlsfname, xlssheet, 'C3:AN1112'); %p-by-n
label_data = xlsread(xlsfname, xlssheet, 'C1:AN1');%1-by-n
[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A3:A1112'); %p-by-1 
if length(variable_name) == 0
    variable_name  = cell(size(ndata,1),1);
    for yy=1:size(ndata,1)
        variable_name(yy) = num2cell(ndata(yy));
    end    
end
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'C2:AN2');
if length(sample_name) == 0
    sample_name  = cell(size(ndata,1),1);
    for yy=1:size(ndata,2)
        sample_name(yy) = num2cell(ndata(yy));
    end    

end
%SampleFilter = xlsread(xlsfname, xlssheet, 'C429:BB429');
SampleFilter = ones(length(label_data),1);
VarFilter = xlsread(xlsfname, xlssheet, 'AP3:AP1112');


id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;
isFillExpect = false;
%isFillExpect = false;
if isFillExpect
    [data] = fillDataWithExpect(data);
end
if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end



P = size(data,2);
N = size(data,1);

strLabelAll = {'WT';'TG'};
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;



%% reading HD
xlsfname = 'C:\Users\Sky\Documents\Research\HD\HDPilotFile.xlsx';


%colname = 'AE';
colname = 'C18';

switch (colname)
    case 'AE'
        xlssheet = 'AE_Features';
        %AE -> PC 3, 4
        %data labelY variable_name sample_name score_data loading_data
        data = xlsread(xlsfname, xlssheet, 'E3:CB3905'); %p-by-n
        label_data = xlsread(xlsfname, xlssheet, 'E1:CB1');%1-by-n
        [ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A3:A3905'); %p-by-1
        if length(variable_name) == 0
            variable_name  = cell(size(ndata,1),1);
            for yy=1:size(ndata,1)
                variable_name(yy) = num2cell(ndata(yy));
            end
        end
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E2:CB2');
        if length(sample_name) == 0
            sample_name  = cell(size(ndata,1),1);
            for yy=1:size(ndata,2)
                sample_name(yy) = num2cell(ndata(yy));
            end
            
        end
        SampleFilter = xlsread(xlsfname, xlssheet, 'E3906:CB3906');
        VarFilter = xlsread(xlsfname, xlssheet, 'CD3:CD3905');
    case 'C18'
        xlssheet = 'C18_Features';
        
        %C18 -> PC 2, 4
        %data labelY variable_name sample_name score_data loading_data
        data = xlsread(xlsfname, xlssheet, 'E3:CB3464'); %p-by-n
        label_data = xlsread(xlsfname, xlssheet, 'E1:CB1');%1-by-n
        [ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A3:A3464'); %p-by-1
        if length(variable_name) == 0
            variable_name  = cell(size(ndata,1),1);
            for yy=1:size(ndata,1)
                variable_name(yy) = num2cell(ndata(yy));
            end
        end
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E2:CB2');
        if length(sample_name) == 0
            sample_name  = cell(size(ndata,1),1);
            for yy=1:size(ndata,2)
                sample_name(yy) = num2cell(ndata(yy));
            end
            
        end
        SampleFilter = xlsread(xlsfname, xlssheet, 'E3465:CB3465');
        VarFilter = xlsread(xlsfname, xlssheet, 'CD3:CD3464');
end


id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = false;
isFillExpect = false;
%isFillExpect = false;
if isFillExpect
    [data] = fillDataWithExpect(data);
end
if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

% docentering = true;
% if docentering
%     [data] = centerData(data); %n-by-p
% end

P = size(data,2);
N = size(data,1);

strLabelAll = {'Control';'HD'};
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%% reading HD without fasting
xlsfname = 'C:\Users\Sky\Documents\Research\HD\HDPilotFileVer2-Nonfasting.xlsx';


%colname = 'AE';
colname = 'C18';

switch (colname)
    case 'AE'
        xlssheet = 'AE_Features';
        %AE -> PC 3, 4
        %data labelY variable_name sample_name score_data loading_data
        data = xlsread(xlsfname, xlssheet, 'E3:CB3905'); %p-by-n
        label_data = xlsread(xlsfname, xlssheet, 'E3912:CB3912');%1-by-n
        [ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A3:A3905'); %p-by-1
        if length(variable_name) == 0
            variable_name  = cell(size(ndata,1),1);
            for yy=1:size(ndata,1)
                variable_name(yy) = num2cell(ndata(yy));
            end
        end
        %it can be of a string type. Let us use a cell type. March 17 2011
        %[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E3913:CB3913');
        %[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E3911:CB3911'); %PersonNumber
        [ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E3914:CB3914'); %SinceHD
        if length(sample_name) == 0
            sample_name  = cell(size(ndata,1),1);
            for yy=1:size(ndata,2)
                sample_name(yy) = num2cell(ndata(yy));
            end
            
        end
        SampleFilter = xlsread(xlsfname, xlssheet, 'E3907:CB3907');
        VarFilter = xlsread(xlsfname, xlssheet, 'CD3:CD3905');
    case 'C18'
        xlssheet = 'C18_Features';
        
        %C18 -> PC 2, 4
        %data labelY variable_name sample_name score_data loading_data
        data = xlsread(xlsfname, xlssheet, 'E3:CB3464'); %p-by-n
        label_data = xlsread(xlsfname, xlssheet, 'E3471:CB3471');%1-by-n
        [ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A3:A3464'); %p-by-1
        if length(variable_name) == 0
            variable_name  = cell(size(ndata,1),1);
            for yy=1:size(ndata,1)
                variable_name(yy) = num2cell(ndata(yy));
            end
        end
        %it can be of a string type. Let us use a cell type. March 17 2011
        %[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E3472:CB3472');
        %[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E3470:CB3470'); %Person-num
        [ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E3473:CB3473'); %SinceTime
        if length(sample_name) == 0
            sample_name  = cell(size(ndata,1),1);
            for yy=1:size(ndata,2)
                sample_name(yy) = num2cell(ndata(yy));
            end
        end
        SampleFilter = xlsread(xlsfname, xlssheet, 'E3466:CB3466');
        VarFilter = xlsread(xlsfname, xlssheet, 'CD3:CD3464');
end


id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;
isFillExpect = false;
%isFillExpect = false;
if isFillExpect
    [data] = fillDataWithExpect(data);
end
if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end



P = size(data,2);
N = size(data,1);

strLabelAll = {'Control';'HD'};
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;



%% reading alcohol


%colname = 'alcohol';
%colname = 'nonalcohol';
colname = 'wild';

switch (colname)
    case 'alcohol'
        xlsfname = 'C:\Users\Sky\Documents\Research\Alcohol\serum-alcohol.xlsx';
        xlssheet = 'alcohol';
        %idPCAll = [1 2];
        %data labelY variable_name sample_name score_data loading_data
        data = xlsread(xlsfname, xlssheet, 'E5:AB1399'); %p-by-n
        label_data = xlsread(xlsfname, xlssheet, 'E3:AB3');%1-by-n
        [ndata, ntext, variable_name] = xlsread(xlsfname, xlssheet, 'A5:A1399'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_name]= xlsread(xlsfname, xlssheet, 'E1:AB1');
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
        data = xlsread(xlsfname, xlssheet, 'E5:BD1399'); %p-by-n
        label_data = xlsread(xlsfname, xlssheet, 'E3:BD3');%1-by-n
        [ndata, ntext, variable_name] = xlsread(xlsfname, xlssheet, 'A5:A1399'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_name]= xlsread(xlsfname, xlssheet, 'E1:BD1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E4:BD4');
        VarFilter = xlsread(xlsfname, xlssheet, 'BF5:BF1399');
        strLabelAll = {'tg';'wt'};
    case 'wild'
        xlsfname = 'C:\Users\Sky\Documents\Research\Alcohol\serum-wild.xlsx';
        xlssheet = 'wild';
        %idPCAll = [1 4]; 1	4	0.979	0.931	0.917
        data = xlsread(xlsfname, xlssheet, 'E5:AZ1399'); %p-by-n
        label_data = xlsread(xlsfname, xlssheet, 'E3:AZ3');%1-by-n
        [ndata, ntext, variable_name] = xlsread(xlsfname, xlssheet, 'A5:A1399'); %p-by-1        
        %it can be of a string type. Let us use a cell type. March 17 2011
        [ndata, ntext, sample_name]= xlsread(xlsfname, xlssheet, 'E1:AZ1');
        SampleFilter = xlsread(xlsfname, xlssheet, 'E4:AZ4');
        VarFilter = xlsread(xlsfname, xlssheet, 'BB5:BB1399');
        strLabelAll = {'NonAC';'AC'};
end


id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;
isFillExpect = false;
%isFillExpect = false;
if isFillExpect
    [data] = fillDataWithExpect(data);
end
if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end


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
cutoff_md_quantile = 0.10;

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;


%% reading muscadine data

clear all; clc;
xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\muscadiine\Mus\ModelC18_010511.xls';
xlssheet = 'DataUsed';

%data labelY variable_name sample_name score_data loading_data
data = xlsread(xlsfname, xlssheet, 'E4:CF5788'); %p-by-n
label_data = xlsread(xlsfname, xlssheet, 'E3:CF3');%1-by-n
[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A4:A5788'); %p-by-1 
if length(variable_name) == 0
    variable_name = num2cell(ndata);
end
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E1:CF1');
if length(sample_name) == 0
    sample_name = num2str(ndata);
end
SampleFilter = xlsread(xlsfname, xlssheet, 'E5796:CF5796');%1-by-n
VarFilter = xlsread(xlsfname, xlssheet, 'CH4:CH5788');%p-by-1

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = {'0';'1';'2';'3';'4';'5'};
%lbl_value_all = [1 2 3 4 5 6];
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;


%% reading asthma data

clear all; clc;
xlsfname = 'G:\Pulmonary\Research\Jones Lab\Sky\asthma\C-sky-fea.xls';
xlssheet = 'feature09';

%data labelY variable_name sample_name score_data loading_data
data = xlsread(xlsfname, xlssheet, 'E3:W1894'); %p-by-n
label_data = xlsread(xlsfname, xlssheet, 'E1:W1');%1-by-n
[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A3:A1894'); %p-by-1 
if length(variable_name) == 0
    variable_name = num2cell(ndata);
end
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E2:W2');
if length(sample_name) == 0
    sample_name = num2str(ndata);
end
SampleFilter = xlsread(xlsfname, xlssheet, 'E1895:W1895');%1-by-n
VarFilter = xlsread(xlsfname, xlssheet, 'Y3:Y1894');%p-by-1

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = {'0';'1';'2';'3';'4';'5'};
%lbl_value_all = [1 2 3 4 5 6];
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%% reading asthma data of visit 2

clear all; clc;
xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\asthma\C-visit2-fea.xls';
xlssheet = 'C-pir';

%data labelY variable_name sample_name score_data loading_data
data = xlsread(xlsfname, xlssheet, 'E3:W2563'); %p-by-n
label_data = xlsread(xlsfname, xlssheet, 'E2:W2');%1-by-n
[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A3:A2563'); %p-by-1 
if length(variable_name) == 0
    variable_name = num2cell(ndata);
end
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E1:W1');
if length(sample_name) == 0
    sample_name = num2str(ndata);
end
SampleFilter = xlsread(xlsfname, xlssheet, 'E2564:W2564');%1-by-n
VarFilter = xlsread(xlsfname, xlssheet, 'Y3:Y2563');%p-by-1

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = {'0';'1';'2';'3';'4';'5'};
%lbl_value_all = [1 2 3 4 5 6];
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%% reading AE GT-CHD common features

clear all; clc;
xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\CHD\description\CHD_Genetic\features_AE.xlsx';
xlssheet = 'Sheet1';

%data labelY variable_name sample_name score_data loading_data
data = xlsread(xlsfname, xlssheet, 'E3:AJD2995'); %p-by-n

%label_data = xlsread(xlsfname, xlssheet, 'E1:AJD1');%1-by-n
[ndata, label_data] = xlsread(xlsfname, xlssheet, 'E1:AJD1');%1-by-n
if length(label_data) == 0
    label_data = num2cell(ndata);
end

[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A3:A2995'); %p-by-1 
if length(variable_name) == 0
    variable_name = num2cell(ndata);
end
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'E2:AJD2');
if length(sample_name) == 0
    sample_name = num2str(ndata);
end
SampleFilter = xlsread(xlsfname, xlssheet, 'E2997:AJD2997');%1-by-n
VarFilter = xlsread(xlsfname, xlssheet, 'AJF3:AJF2995');%p-by-1

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

if iscell(label_data)
    label_data = cell2mat(label_data);
    if isstr(label_data)
        label_data = str2num(label_data);
    end
end

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = label_data;
%lbl_value_all = [1 2 3 4 5 6];
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%% reading ATM-data-SAurabh

clear all; clc;
xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\ATM\sky-atm.xlsx';
xlssheet = 'Sheet1';

%data labelY variable_name sample_name score_data loading_data
data = xlsread(xlsfname, xlssheet, 'B4:Y12499'); %p-by-n

%label_data = xlsread(xlsfname, xlssheet, 'E1:AJD1');%1-by-n
[ndata, label_data] = xlsread(xlsfname, xlssheet, 'B3:Y3');%1-by-n
if length(label_data) == 0
    label_data = num2cell(ndata);
end

[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A4:A12499'); %p-by-1 
if length(variable_name) == 0
    variable_name = num2cell(ndata);
end
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'B1:Y1');
if length(sample_name) == 0
    sample_name = num2str(ndata);
end
SampleFilter = ones(1, size(data,2));%1-by-n
VarFilter = xlsread(xlsfname, xlssheet, 'Z4:Z12499');%p-by-1

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

if iscell(label_data)
    label_data = cell2mat(label_data);
    if isstr(label_data)
        label_data = str2num(label_data);
    end
end

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = label_data;
if ~isstr(strLabelAll)
    strLabelAll = num2str(strLabelAll);
end
%lbl_value_all = [1 2 3 4 5 6];
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;


%% reading ATM-data-khan

clear all; clc;
xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\ATM\sky-kahn.xlsx';
xlssheet = 'Sheet1';

%data labelY variable_name sample_name score_data loading_data
data = xlsread(xlsfname, xlssheet, 'B4:AV12482'); %p-by-n

%label_data = xlsread(xlsfname, xlssheet, 'E1:AJD1');%1-by-n
[ndata, label_data] = xlsread(xlsfname, xlssheet, 'B3:AV3');%1-by-n
if length(label_data) == 0
    label_data = num2cell(ndata);
end

[ndata, variable_name] = xlsread(xlsfname, xlssheet, 'A4:A12482'); %p-by-1 
if length(variable_name) == 0
    variable_name = num2cell(ndata);
end
%it can be of a string type. Let us use a cell type. March 17 2011
[ndata, sample_name]= xlsread(xlsfname, xlssheet, 'B1:AV1');
if length(sample_name) == 0
    sample_name = num2str(ndata);
end
SampleFilter = ones(1, size(data,2));%1-by-n
VarFilter = xlsread(xlsfname, xlssheet, 'AX4:AX12482');%p-by-1

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

dataOld = data;
label_dataOld = label_data;
variable_nameOld = variable_name;
%variable_name = char(variable_name);
sample_nameOld = sample_name;

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

if iscell(label_data)
    label_data = cell2mat(label_data);
    if isstr(label_data)
        label_data = str2num(label_data);
    end
end

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

strLabelAll = label_data;
if ~isstr(strLabelAll)
    strLabelAll = num2str(strLabelAll);
end
%lbl_value_all = [1 2 3 4 5 6];
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%% reading ATM-data-ms-Saurabh

clear all; clc;
xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\ATM\ATM_MS-sky.xls';
xlssheet = 'odd-run';

%data labelY variable_name sample_name score_data loading_data
dataOld = xlsread(xlsfname, xlssheet, 'B7:AO5811'); %p-by-n

%label_data = xlsread(xlsfname, xlssheet, 'E1:AJD1');%1-by-n
[ndata, label_dataOld] = xlsread(xlsfname, xlssheet, 'B3:AO3');%1-by-n
if length(label_dataOld) == 0
    label_dataOld = num2cell(ndata);
end

[ndata, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A7:A5811'); %p-by-1 
if length(variable_nameOld) == 0
    variable_nameOld = num2cell(ndata);
end
%it can be of a string type. Let us use a cell type. March 17 2011
%[ndata, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B5812:AO5812');
[ndata, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B5814:AO5814');
if length(sample_nameOld) == 0
    %sample_nameOld = num2str(ndata);
    sample_nameOld = cell(size(ndata));
    for pp=1:length(ndata)
        sample_nameOld{1,pp} = ndata(pp);
    end
end
SampleFilter = xlsread(xlsfname, xlssheet, 'B1:AO1');%1-by-n
VarFilter = xlsread(xlsfname, xlssheet, 'AS7:AS5811');%p-by-1

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

if iscell(label_data)
    label_data = cell2mat(label_data);
    if isstr(label_data)
        label_data = str2num(label_data);
    end
end

isFillingMissing = true;
if isFillingMissing
    [data] = fillDataWithExpect(data,0);
end

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

% strLabelAll = label_data;
% if ~isstr(strLabelAll)
%     strLabelAll = num2str(strLabelAll);
% end
%strLabelAll = unique(label_data);
strLabelAll = {'1';'2';'3';'4'};

%lbl_value_all = [1 2 3 4 5 6];
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;

%% reading ATM-data-nmr-vein

clear all; clc;
xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\ATM\atm-nmr.xlsx';
xlssheet = 'Sheet1';

%data labelY variable_name sample_name score_data loading_data
dataOld = xlsread(xlsfname, xlssheet, 'AW2:BY12784'); %p-by-n

%label_data = xlsread(xlsfname, xlssheet, 'E1:AJD1');%1-by-n
[ndata, label_dataOld] = xlsread(xlsfname, xlssheet, 'AW12794:BY12794');%1-by-n
if length(label_dataOld) == 0
    label_dataOld = num2cell(ndata);
end

[ndata, variable_nameOld] = xlsread(xlsfname, xlssheet, 'A2:A12784'); %p-by-1 
if length(variable_nameOld) == 0
    variable_nameOld = num2cell(ndata);
end
%it can be of a string type. Let us use a cell type. March 17 2011
%[ndata, sample_nameOld]= xlsread(xlsfname, xlssheet, 'B5812:AO5812');
[ndata, sample_nameOld]= xlsread(xlsfname, xlssheet, 'AW1:BY1');
if length(sample_nameOld) == 0
    %sample_nameOld = num2str(ndata);
    sample_nameOld = cell(size(ndata));
    for pp=1:length(ndata)
        sample_nameOld{1,pp} = ndata(pp);
    end
end
SampleFilter = xlsread(xlsfname, xlssheet, 'AW12796:BY12796');%1-by-n
VarFilter = xlsread(xlsfname, xlssheet, 'CB2:CB12784');%p-by-1

id_sample = find( SampleFilter == 1);
id_var = find( VarFilter == 1);

data = dataOld(id_var, id_sample)'; %n-by-p
label_data = label_dataOld(1, id_sample)'; %n-by-1
variable_name = variable_nameOld(id_var, 1); %p-by-1
sample_name = sample_nameOld(1, id_sample)'; %n-by-1

if iscell(label_data)
    label_data = cell2mat(label_data);
    if isstr(label_data)
        label_data = str2num(label_data);
    end
end

isFillingMissing = true;
if isFillingMissing
    [data] = fillDataWithExpect(data,0);
end

isAutoScalse = true;

if isAutoScalse
    [data] = normalizeData(data); %n-by-p
end

P = size(data,2);
N = size(data,1);

% strLabelAll = label_data;
% if ~isstr(strLabelAll)
%     strLabelAll = num2str(strLabelAll);
% end
%strLabelAll = unique(label_data);
strLabelAll = {'1';'2';'3';'4'};

%lbl_value_all = [1 2 3 4 5 6];
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

libparam.ktype ='radial';
libparam.degree = 3;
libparam.gamma = 0.005;
libparam.C = 10;
drawfigclsf = true;
%% loading scores and loadings previously

clear all; clc;
xlsfname = 'C:\Documents and Settings\klee30\My Documents\Research\ATM\sky-venous1-score-load.xlsx';
xlssheet = 'score';

%data labelY variable_name sample_name score_data loading_data
score_data = xlsread(xlsfname, 'score', 'B2:H27'); %p-by-n
loading_data = xlsread(xlsfname, 'loading', 'B2:H9736'); %p-by-n

[ndata, label_data] = xlsread(xlsfname, 'score', 'J2:J27');%1-by-n
if length(label_data) == 0
    %label_data = num2cell(ndata);
    label_data = ndata;
end

[ndata, sample_name]= xlsread(xlsfname, 'loading', 'A2:A9736');
if length(sample_name) == 0
    %sample_nameOld = num2str(ndata);
    sample_name = cell(size(ndata));
    for pp=1:length(ndata)
        sample_name{pp,1} = ndata(pp);
    end
end

[ndata, variable_name]= xlsread(xlsfname, 'loading', 'A2:A9736');
if length(variable_name) == 0
    variable_name = num2cell(ndata);
end

strLabelAll = {'1';'2';'3'};
lbl_value_all = [1 2 3];

%% loading scores and loadings 2nd

clear all; clc;
xlsfname = 'C:\Users\Sky\Documents\Research\vitamine\OPLS_DA.xlsx';

%ctype = 'unfilterOPLS';
ctype = 'filterOPLS';
%ctype = 'amd_cfh';

switch ctype
    case 'unfilterOPLS'
        %data labelY variable_name sample_name score_data loading_data
        score_data = xlsread(xlsfname, 'unfiltered_score', 'B2:J47'); %p-by-n
        loading_data = xlsread(xlsfname, 'unfiltered_loading', 'B2:J11981'); %p-by-n
        
        [label_data] = xlsread(xlsfname, 'unfiltered_score', 'L2:L27');%1-by-n
        [ndata, ntxt, sample_name]= xlsread(xlsfname, 'unfiltered_score', 'A2:A47');
        [ndata, ntxt, variable_name]= xlsread(xlsfname, 'unfiltered_loading', 'A2:A11981');
        
        
        strLabelAll = {'b';'a'};
        %{
        axis square
        ylim([-0.035 0.035]*1e-5)
        xlim([-0.03 0.03]*1e-5)
        %}
    case 'filterOPLS'
        %data labelY variable_name sample_name score_data loading_data
        score_data = xlsread(xlsfname, 'filtered_score', 'B2:K44'); %p-by-n
        loading_data = xlsread(xlsfname, 'filtered_loading', 'B2:K7270'); %p-by-n
        
        [label_data] = xlsread(xlsfname, 'filtered_score', 'M2:M44');%1-by-n
        [ndata, ntxt, sample_name]= xlsread(xlsfname, 'filtered_score', 'A2:A44');
        [ndata, ntxt, variable_name]= xlsread(xlsfname, 'filtered_loading', 'A2:A7270');
        
        
        strLabelAll = {'b';'a'};
        %{
        axis square
        ylim([-0.06 0.06]*1e-5)
        xlim([-0.03 0.03]*1e-5)
        %}
    case 'amd_cfh'
        xlsfname = 'C:\Users\Sky\Documents\Research\AMD\Gene-Sky.xlsx';
        
        score_data = xlsread(xlsfname, 'CFH_score', 'B2:K111'); %p-by-n
        loading_data = xlsread(xlsfname, 'CFH_loading', 'B2:K1169'); %p-by-n
        
        [label_data] = xlsread(xlsfname, 'CFH_score', 'L2:L111')';%1-by-n
        [ndata, ntxt, sample_name]= xlsread(xlsfname, 'CFH_score', 'A2:A111');
        [ndata, ntxt, variable_name]= xlsread(xlsfname, 'CFH_loading', 'A2:A1169');
        
        fdrmz = xlsread(xlsfname, 'CFH_loading', 'P1:P94');%1-by-n
        strLabelAll = {'CFH CC';'CFH TT+TC'};
end
lbl_value_all = unique(label_data)';

saveresult = false;
resultshname = 'InFeature';
drawfig = true;
showSampleName = true;
drawOneSigma = false;

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

idPCAll = [1 2];

loading_data = loading_data/ 1e5;

highID =[]; %indices to highlight in loading plots

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


%% loading data using a switch statement


%ctype = 'james-cell-AE';
%ctype = 'james-cell-C18';
ctype = 'PD-Sep-C18';
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
%ctype = 'malaria_c';


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
        
        fdrmz = xlsread(xlsfname, 'sigFtr_C', 'D1:D25');%1-by-n
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

isAutoScalse = true;
isFillExpect = false;

if isFillExpect
    [data] = fillDataWithExpect(data);
end
if isAutoScalse
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
%cutoff_md_quantile = 0.10;
cutoff_md_quantile = 0.05;

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
