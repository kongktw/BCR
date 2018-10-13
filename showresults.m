% Example of how to use DOSC
% Data used is from Eigenvector Technology Homepage
% http://software.eigenvector.com/Data/SWRI/index.html
% and is called viscgcatest.
% The zipfile from their webpage should be downloaded and extracted
%   ==========================================================================
%   Copyright 2005 Biosystems Data Analysis Group ; Universiteit van Amsterdam
%   ==========================================================================

clear all

% There are 6 different data sets and all data sets consists of two 
% sets which either can be used to calibration set or test set.

load viscgatest
xmeans = mean([v_sd_hl; v_sd_ll_a]);
X = [v_sd_hl; v_sd_ll_a] - ones(136,1)*xmeans;
ymean = mean([v_y_hl; v_y_ll_a]);
Y = [v_y_hl; v_y_ll_a] - ymean;

Xtest = v_sd_ll_b - ones(116,1)*xmeans;
Ytest = v_y_ll_b - ymean;

% Only use part of the spectrum
X = X(:,100:305);Xtest = Xtest(:,100:305);

[Z,W,P,T] = dosc(X,Y,2,1E-3);
[Ztest,Ttest] = dosc_pred(Xtest,W,P);

% Make figures
figure; 
subplot(221);plot(X');title('Calib data')
subplot(222);plot(Z');title('Dosc corrected calib data')
subplot(223);plot(Xtest');title('Test data')
subplot(224);plot(Ztest');title('Dosc corrected Test data')

figure;
Xcorr = corrcoef([X Y]);
Zcorr = corrcoef([Z Y]);
plot(Xcorr(1:end-1,end),'b-');hold on
plot(Zcorr(1:end-1,end),'r:')

figure;
plot(T(:,1),T(:,2),'bo');
hold on
plot(Ttest(:,1),Ttest(:,2),'r*')
title('DOSC scores of calib (o) and Test (*) data')

%%
