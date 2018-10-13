%% pc component selection; came from doPCmatchInternal.m
%1st round of PCA
idPCAll = [1 2];
%idPCAll = [1 3];

%idPCAll = [1 2 3];
%idPCAll = [3 6]; %AE, without fasting
%idPCAll = [2 4];
%idPCAll = [1 4];
[coeffs, scores, latent,tsquare] = princomp(data);
score_data = scores;
loading_data = coeffs;

useExactCorrelation = false;
if useExactCorrelation
    TotVarLimit = 0.99;
    maxLatentID = max(find( cumsum(latent)./sum(latent) < TotVarLimit));    
    fprintf('For %.3f as the limit of total variation, the %d-th latent (eigenvalue) is a cut-off.\n', TotVarLimit, maxLatentID);
    fprintf('idPCAll should contain no more than %d.\n', maxLatentID);
    latentPart = [latent(1:maxLatentID); ones(length(latent) - maxLatentID,1)];
    score_data = score_data * diag(latentPart.^(-1/2));
    loading_data = loading_data * diag(latentPart.^(1/2));
end

cumsumLatent = cumsum(latent);
cumsumLatent(1:10)/sum(latent)

maxPCIDnum = 8;
%gplotmatrix(scores(:, 1:maxPCIDnum), scores(:, 1:maxPCIDnum), label_data, 'br', [], [], 'hist');
gplotmatrix(scores(:, 1:maxPCIDnum), [], label_data, 'brg', [], [], 'hist');
%gplotmatrix(score_data(:, 1:maxPCIDnum), [], label_data, 'brg', [], [], 'hist');

if exist('response')
    lbl_value_all = unique(label_data)';
    
    %right now it deals with two labels
    cls0 = find(label_data == lbl_value_all(1));
    cls1 = find(label_data == lbl_value_all(2));
    
    figure(19); clf; hold on;
    xlabel(sprintf('PC %d', idPCAll(1))); ylabel(sprintf('PC %d', idPCAll(2)));
    scatter(scores(cls0,idPCAll(1)), scores(cls0,idPCAll(2)), 90, response(cls0), '^','filled');
    scatter(scores(cls1,idPCAll(1)), scores(cls1,idPCAll(2)), 90, response(cls1), 's','filled');
    %scatter(scores(cls0,idPCAll(1)), scores(cls0,idPCAll(2)), 90, sqrt(response(cls0)), '^','filled');
    %scatter(scores(cls1,idPCAll(1)), scores(cls1,idPCAll(2)), 90, sqrt(response(cls1)), 's','filled');
    colorbar
    %plot(T(cls0,1), XS(cls0,1), 'ob', 'MarkerSize', 13); 
    %plot(T(cls1,1), XS(cls1,1), 'sr', 'MarkerSize', 13); 
    %computeAngleCI(scores(:,idPCAll), response);
end
