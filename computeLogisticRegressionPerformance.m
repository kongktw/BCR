function [accuracy pvalue1 pvalue2] = computeLogisticRegressionPerformance(dataX, Y)

try
[B,dev,stats] =mnrfit(dataX,Y);
phat = mnrval(B,dataX);
yhat = (phat(:,1) < phat(:,2))*1 + 1;
accuracy = sum(Y == yhat)/length(yhat);

mdl = fitglm(dataX, Y == 2, 'linear','distr','binomial','link','logit');
dt_table = devianceTest(mdl);
pvalue1 = 1 - chi2cdf(dt_table{1,1} - dt_table{2,1},size(dataX,2));
pvalue2 = coefTest(mdl);
catch Exception
    accuracy = -2;
    pvalue1 = -2;
    pvalue2 = -2;
end


% [B,dev,stats] =mnrfit(dataX,Y);
% phat = mnrval(B,dataX);
% yhat = (phat(:,1) < phat(:,2))*1 + 1;
% accuracy = sum(Y == yhat)/length(yhat);
% 
% mdl = fitglm(dataX, Y == 2, 'linear','distr','binomial','link','logit');
% dt_table = devianceTest(mdl);
% pvalue1 = 1 - chi2cdf(dt_table{1,1} - dt_table{2,1},size(dataX,2));
% pvalue2 = coefTest(mdl);

