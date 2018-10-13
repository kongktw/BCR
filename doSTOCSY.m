xlsfname = 'malariaData.xlsx';
xlssheet = 'C';
%idPCAll = [1 4]; 1	4	0.979	0.931	0.917
dataOld = xlsread(xlsfname, xlssheet, 'E4:S853'); %p-by-n\\
label_dataOld = xlsread(xlsfname, xlssheet, 'E2:S2'); %p-by-1
[variable_nameOld] = xlsread(xlsfname, xlssheet, 'A4:A853'); %p-by-1

SampleFilter = xlsread(xlsfname, xlssheet, 'E3:S3');
VarFilter = xlsread(xlsfname, xlssheet, 'U4:U853');

idSample = find(SampleFilter == 1);
idVar = find(VarFilter ==1);

data = dataOld(idVar, idSample)';
label_data = label_dataOld(:, idSample)';
variable_name = variable_nameOld(idVar,:);

curalpha = 0.05; %alpha level for testing correlation coefficients
tpcurlev = 0.05; %taking the top (tpcurlev) of the OPLS coefficients
N = size(data,1);
P = size(data,2);
%% doSTOCSY
[Z,W,Pv,T] = dosc(data,label_data,1,1E-3);
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] = plsregress(Z,label_data,1);
%loading XL
%pval_target = 0.05;
pval_target = curalpha;
tval = tinv(1-pval_target/2, N-2);
r_target = sqrt(tval^2/(N-2)/(1+tval^2/(N-2)));
corr_all = zeros(P,1);
for mm=1:P
    corr_all(mm,1) =  corr( data(:,mm), label_data );
end
corr_allP = abs(corr_all);
xl_target = quantile( abs(XL(:,1)), 1 - tpcurlev);
isSigbySTOCSY = (corr_allP > r_target) .* ( abs(XL(:,1)) > xl_target) ;
idSTOCSYfound = find( isSigbySTOCSY);

%% drawing the outcome
doShowSTOCSY = true;
if doShowSTOCSY
    figure(14); clf; hold on;
    color_line(1:P, XL(:,1), corr_allP);
    colorbar;
    xlabel('Variables');
    ylabel('O-PLS coefficients');
    xlim([1 P]);
    %ylim([-7 7]);
    %plot([40 40], [-8 8], '--g', 'linewidth', 3);
    %set(gca, 'XTick', [0 40 100 200 300 400]);
    %set(gca, 'XTickLabel', {'0','40','100','200','300','400'});
end
delete 'outcomeSTOCSY.csv';
%var_name 1stLoading corr abs(corr) sig_corr top
tpOutcome = [variable_name XL(:,1) corr_all corr_allP (corr_allP > r_target) isSigbySTOCSY];
csvwrite('outcomeSTOCSY.csv',tpOutcome);