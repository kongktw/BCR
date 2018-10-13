%% testing DOSC with pls; came from doOPLSmatchSetup.m
% isAutoScale = true;
% if isAutoScale
%     zdata = zscore(data);
% else
%     zdata = data;
% end

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
