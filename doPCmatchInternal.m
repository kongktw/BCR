%% pc component selection
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



%% match score and loading in case princomp is not used
clear Params;
Params.score_data = score_data;
Params.loading_data = loading_data;
Params.idPCAll = idPCAll;
Params.label_data = label_data;
Params.lbl_value_all = lbl_value_all;
%Params.curLblnum = curLblnum;
%Params.cutoff_angle = cutoff_angle; %no longer used
Params.cutoff_md_quantile = cutoff_md_quantile;
Params.drawfig = drawfig;
showSampleOrderNum = false;
if showSampleOrderNum
    Params.sample_name = num2str((1:size(sample_name,1))');
else
    Params.sample_name = sample_name;
end

Params.strLabelAll = strLabelAll;
Params.showSampleName = false;
Params.drawOneSigma = drawOneSigma;
Params.drawOneSigma = false;
%Params.siglev = 1;
if exist('highID')
    Params.highID = highID; %indices to highlight in loading plots
end
if exist('redrawfig')
    Params.redrawfig = redrawfig; %redraw figures
end 
    

%Params.curLblnum = 1;
Params.curLblnum = lbl_value_all(1);

[idx_inside1, Angles1, MDistSq1, cutoff_angle1, cutoff_dist1, outlier_id1, sampleInsidePval1]= getVarIndexPCMatchNew(Params);
%% label 2
%Params.curLblnum = 2;
Params.curLblnum = lbl_value_all(2);
%Params.redrawfig = true;
Params.redrawfig = false;
Params.plotallloading = false;

[idx_inside2, Angles2, MDistSq2, cutoff_angle2, cutoff_dist2, outlier_id2, sampleInsidePval2]=getVarIndexPCMatchNew(Params);
%% label 3
Params.curLblnum = lbl_value_all(3);
[idx_inside3, Angles2, MDistSq2, cutoff_angle2, cutoff_dist2, outlier_id2, sampleInsidePval2]=getVarIndexPCMatchNew(Params);
%% svm classification

[resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, drawfigclsf, lbl_value_all, [], [], strLabelAll);
%[resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, drawfigclsf, lbl_value_all);

%% svm classification with needed labels

tpLblidx = find( (label_data == 2) + (label_data == 4));
%[resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, drawfigclsf, lbl_value_all, [], [], {'PD';'Control'});
[resultstat] = getSVMResult(score_data(tpLblidx,:), idPCAll, label_data(tpLblidx)-1, libparam, drawfigclsf, [1 2]);

%% saving inside variables
delete('tp_idx_inside1.csv'); 
delete('tp_idx_inside2.csv');
tpnewc = cell(size(idx_inside1,1)+1, 1);
tpnewc{1} = lbl_value_all(1);
for kk=1:size(idx_inside1,1)
    if iscell( variable_name(idx_inside1(kk)))
        tpnewc(1+kk) = variable_name(idx_inside1(kk));
    else
        tpnewc(1+kk) = num2cell(variable_name(idx_inside1(kk))); 
    end
end
cellwrite('tp_idx_inside1.csv', tpnewc);

tpnewc = cell(size(idx_inside2,1)+1, 1);
tpnewc{1} = lbl_value_all(2);
for kk=1:size(idx_inside2,1)
    if iscell(variable_name(idx_inside2(kk)))
        tpnewc(1+kk) = variable_name(idx_inside2(kk));
    else
        tpnewc(1+kk) = num2cell(variable_name(idx_inside2(kk)));
    end
end

cellwrite('tp_idx_inside2.csv', tpnewc);

%% doing with lbl_value_all
%Params.curLblnum = lbl_value_all(1);
%[idx_inside2, Angles2, MDistSq2, cutoff_angle2, cutoff_dist2, outlier_id2, sampleInsidePval2]=getVarIndexPCMatchNew(Params);

mkstr = '+o*xsd^v<>ph';
rcolall = floor(255*rand(length(lbl_value_all),3))/255;
for uu=1:length(lbl_value_all)
    figure(31); clf; hold on;
    highlightlbl = lbl_value_all(uu);
    for kk=1:length(lbl_value_all)
        tp_idx = find( label_data == lbl_value_all(kk));
        tpcol = rcolall(kk,:);
        plot3(score_data(tp_idx,1), score_data(tp_idx,2), score_data(tp_idx,3), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol);
        if length( find( highlightlbl == lbl_value_all(kk))) > 0
            %text(score_data(tp_idx,1), score_data(tp_idx,2), score_data(tp_idx,3), num2str(kk), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold');
            text(score_data(tp_idx,1), score_data(tp_idx,2), score_data(tp_idx,3), strcat(num2str(kk), '-',num2str(cell2mat(sample_name(tp_idx)))), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold');            
            %text(score_data(tp_idx,1), score_data(tp_idx,2), score_data(tp_idx,3), strcat(num2str(kk), '-',sample_name(tp_idx)), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold');            
        end
        view([56 30]);
    end
    pause(1);
end

%% doing with lbl_value_all with all labels and highlighting a few- atm ms and others


mkstr = '+o*xsd^v<>ph';
%rcolall = floor(255*rand(length(lbl_value_all),3))/255;
if length(lbl_value_all) < 7
    rcolall = [ 0 0 255; 255 0 0; 0 255 0; 0 128 0; 128 0 128; 0 0 0]/255;
else
    rcolall = floor(rand(length(lbl_value_all),3)*255+1)/255;
end

figure(31); clf; hold on;
tp_PCIDs = [1 2 3];
%tp_PCIDs = [2 3 5];
show_lbl_nums = [1 3];


for kk=1:length(lbl_value_all)
    tp_idx = find( label_data == lbl_value_all(kk));
    tpcol = rcolall(kk,:);
    if length( find(show_lbl_nums == lbl_value_all(kk))) > 0
        plot3(score_data(tp_idx(1),tp_PCIDs(1)), score_data(tp_idx(1),tp_PCIDs(2)), score_data(tp_idx(1),tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 11, 'LineWidth', 3);
    else
        plot3(score_data(tp_idx(1),tp_PCIDs(1)), score_data(tp_idx(1),tp_PCIDs(2)), score_data(tp_idx(1),tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 8, 'LineWidth', 1);
    end    
end
%legend('Aortic Pre','Cor. Artery Post', 'Aortic Post', 'Vein Post');
legend(strLabelAll);


for kk=1:length(lbl_value_all)
    tp_idx = find( label_data == lbl_value_all(kk));
    tpcol = rcolall(kk,:);
    if length( find(show_lbl_nums == lbl_value_all(kk))) > 0
        plot3(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 11, 'LineWidth', 3);
    else
        plot3(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 8, 'LineWidth', 1);
    end
    
    for uu=1:length(lbl_value_all)
        highlightlbl = lbl_value_all(uu);
        if length(find(show_lbl_nums == highlightlbl))>0 && length( find( highlightlbl == lbl_value_all(kk))) > 0
            %text(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), num2str(kk), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);            
            tyu = 1;
            if iscell(sample_name(tp_idx))
                text(score_data(tp_idx,tp_PCIDs(1)), tyu+score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), sample_name(tp_idx), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
            else
                tp_d = cell2mat(sample_name(tp_idx));
                if isnumeric(tp_d)
                    text(score_data(tp_idx,tp_PCIDs(1)), tyu+score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), strcat(num2str(kk), '-',num2str(tp_d)), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                else
                    text(score_data(tp_idx,tp_PCIDs(1)), tyu+score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), strcat(num2str(kk), '-',tp_d), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                end
            end
        end
    end
    xlabel(num2str(tp_PCIDs(1)));
    ylabel(num2str(tp_PCIDs(2)));
    zlabel(num2str(tp_PCIDs(3)));
    
    view([56 30]);
end

%% doing with lbl_value_all with all labels - atm vein and others


mkstr = '*os^vx+d<>ph';
%rcolall = floor(255*rand(length(lbl_value_all),3))/255;
if length(lbl_value_all) < 7
    rcolall = [ 0 0 255; 255 0 0; 0 255 0; 0 128 0; 128 0 128; 0 0 0]/255;
else
    rcolall = floor(rand(length(lbl_value_all),3)*255+1)/255;
end

figure(31); clf; hold on;
tp_PCIDs = [1 3 5]; %good for james-cell-AE
tp_PCIDs = [3 4 5]; %good for james-cell-AE
%tp_PCIDs = [2 3 5];
%tp_PCIDs = [1 2 3]; %good for james-cell-C18

%show_lbl_nums = [2 3];
show_lbl_nums = [1 4 5];
ShowText = false;
ShowOtherlbl = false;

for kk=1:length(lbl_value_all)
    tp_idx = find( label_data == lbl_value_all(kk));
    tpcol = rcolall(kk,:);
    
    if length( find(show_lbl_nums == lbl_value_all(kk))) > 0
        plot3(score_data(tp_idx(1),tp_PCIDs(1)), score_data(tp_idx(1),tp_PCIDs(2)), score_data(tp_idx(1),tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 11, 'LineWidth', 3);
    else
        if ShowOtherlbl
            plot3(score_data(tp_idx(1),tp_PCIDs(1)), score_data(tp_idx(1),tp_PCIDs(2)), score_data(tp_idx(1),tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 5, 'LineWidth', 2);
        end
    end
    
end
%legend('Coronary','Vein Pre', 'Vein Post');
if ShowOtherlbl
    legend(strLabelAll);
else
    tplegID = [];
    for rr=1:length(show_lbl_nums)
        tplegID = [tplegID; find(lbl_value_all(:) == show_lbl_nums(rr))];
    end
    
    legend(strLabelAll(tplegID));
end


for kk=1:length(lbl_value_all)
    tp_idx = find( label_data == lbl_value_all(kk));
    tpcol = rcolall(kk,:);
    if length( find(show_lbl_nums == lbl_value_all(kk))) > 0
        plot3(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 11, 'LineWidth', 3);
    else
        if ShowOtherlbl
            plot3(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 5, 'LineWidth', 2);
        end
    end
    
    if ShowText
        for uu=1:length(lbl_value_all)
            highlightlbl = lbl_value_all(uu);
            if length(find(show_lbl_nums == highlightlbl))>0 && length( find( highlightlbl == lbl_value_all(kk))) > 0
                %text(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), num2str(kk), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                tyu = 1;
                if iscell(sample_name(tp_idx))
                    text(score_data(tp_idx,tp_PCIDs(1)), tyu+score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), sample_name(tp_idx), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                else
                    tp_d = cell2mat(sample_name(tp_idx));
                    if isnumeric(tp_d)
                        text(score_data(tp_idx,tp_PCIDs(1)), tyu+score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), strcat(num2str(kk), '-',num2str(tp_d)), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                    else
                        text(score_data(tp_idx,tp_PCIDs(1)), tyu+score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), strcat(num2str(kk), '-',tp_d), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                    end
                end
            end
        end
    end
    xlabel(sprintf('PC%s',num2str(tp_PCIDs(1))));
    ylabel(sprintf('PC%s',num2str(tp_PCIDs(2))));
    zlabel(sprintf('PC%s',num2str(tp_PCIDs(3))));
    
    view([-43 18]);
end


grid on;

view([-90 90]); %good for james-cell-AE
%view([-180 0]); %good for james-cell-C18

%% 2nd round of PCA. Would this help?
idx_union = union(idx_inside1, idx_inside2);
variable_name_2nd = variable_name(idx_union);
data_2nd = data(:,idx_union);

[coeffs_2nd, scores_2nd, latent_2nd,tsquare_2nd] = princomp(data_2nd);
score_data = scores_2nd;
loading_data = coeffs_2nd;

curLblnum = 1;
[idx_inside1_2nd]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll, false, false);

curLblnum = 2;
[idx_inside2_2nd]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll, false, true);
%the rank of score_data can be less than 2.
%plot(1:length(score_data), score_data); hold on;

[resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, drawfigclsf, lbl_value_all);

%% 3rd round of PCA. Would this help?
idx_union = union(idx_inside1_2nd, idx_inside2_2nd);
variable_name_3rd = variable_name_2nd(idx_union);
data_3rd = data_2nd(:,idx_union);

[coeffs_3rd, scores_3rd, latent_3rd, tsquare_3rd] = princomp(data_3rd);
score_data = scores_3rd;
loading_data = coeffs_3rd;

curLblnum = 1;
[idx_inside1_3nd]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll, false, false);

curLblnum = 2;
[idx_inside2_3nd]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll, false, true);
%the rank of score_data can be less than 2.
%plot(1:length(score_data), score_data); hold on;

[resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, drawfigclsf, lbl_value_all, [],[], strLabelAll);

%% 4th round of PCA. Would this help?
idx_union = union(idx_inside1_3nd, idx_inside2_3nd);
variable_name_4th = variable_name_3rd(idx_union);
data_4th = data_3rd(:,idx_union);

[coeffs_4th, scores_4th, latent_4th, tsquare_3rd] = princomp(data_4th);
score_data = scores_4th;
loading_data = coeffs_4th;

curLblnum = 1;
[idx_inside1_4]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll, false, true);

curLblnum = 2;
[idx_inside2_4]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll, false, true);
%the rank of score_data can be less than 2.
%plot(1:length(score_data), score_data); hold on;

[resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, drawfigclsf, lbl_value_all, [],[], strLabelAll);

%% drawing multi-labels 
figure(33); clf; hold on;
drawMultiLabels2D(score_data, label_data, strLabelAll, lbl_value_all);

%% drawing multi-labels separately
figure(331); clf; hold on;
lb_case = 4;
switch lb_case
    case 1
        target_labels_1 = [1];
        target_labels_2 = [4];
    case 2
        target_labels_1 = [3];
        target_labels_2 = [6];
    case 3
        target_labels_1 = [2];
        target_labels_2 = [5];
    case 4
        target_labels_1 = [1 2];
        target_labels_2 = [4 5];
end

label_data_new =label_data;
strLabelAll_new = strLabelAll;
t_id1 = findIndexForVals(label_data, target_labels_1);
t_id2 = findIndexForVals(label_data, target_labels_2);
[tpp_id_in, t_id3] = findIndexForVals(label_data, union(target_labels_1, target_labels_2));
label_data_new(t_id3) = max(label_data) + 1;
strLabelAll_new = {'1st'; '2nd'; 'Other'};
drawMultiLabels2D(score_data, label_data_new, strLabelAll_new);


%% bootstrapping initial

%[data_out, indices, label_data_out] =bootsampleXY(data, false, label_data);
%[data_out, label_data_out, indices] =parabootsampleXY(data, label_data);
[data_out] =bootsampleXY(data);

warning off stats:princomp:colRankDefX
[coeffs, scores, latent,tsquare] = princomp(data_out, 'econ');
score_data = scores;
loading_data = coeffs;

curLblnum = 1;
[idx_inside1, Angles1, MDistSq1]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data_out, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll, showSampleName, drawOneSigma);
curLblnum = 2;
[idx_inside2, Angles2, MDistSq2]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data_out, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll, showSampleName, drawOneSigma);

%[resultstat] = getSVMResult(score_data, idPCAll, label_data_out, libparam, drawfigclsf, lbl_value_all);

%% bootstrapping structure
B = 10;

bootstrapVar = false;
if bootstrapVar
    clstats_acc_all = -1*ones(B,P);
    clstats_bac_all = -1*zeros(B,P);
else
    clstats_acc_all = -1*ones(B,N);
    clstats_bac_all = -1*zeros(B,N);
end

for bb=1:B
    if bootstrapVar
        [data_out, indices] =bootsampleXY(data);
        nonSlected = 1:N;
    else
        keepAgain = 1;
        while keepAgain == 1
            [data_out, indices, label_data_out] = bootsampleXY(data, false, label_data);
            keepAgain = length(lbl_value_all) - length(unique(label_data_out));
        end
        nonSlected = ones(N,1);
        nonSlected(indices) = 0;
        nonSlectedID = find(nonSlected);
    end
    
    warning off stats:princomp:colRankDefX
    [coeffs, scores, latent,tsquare] = princomp(data_out, 'econ');
    score_data = scores;
    loading_data = coeffs;    
    
    testylabel = label_data(nonSlectedID);
    if bootstrapVar
        testX = data(:, indices);
    else
        testX = data(nonSlectedID, :);
    end    
    testXScore = testX*coeffs(:, idPCAll);    
    
    drawfigTP = false;
    for tt=1:length(lbl_value_all)
        curLblnum = lbl_value_all(tt);
        [idx_inside_t, Angles_t, MDistSq_t]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data_out, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfigTP, sample_name, strLabelAll, showSampleName, drawOneSigma);
        lbl_angle(curLblnum).v = Angles_t;
        lbl_dist(curLblnum).v = MDistSq_t;
    end
    [resultstat] = getSVMResult(score_data, idPCAll, label_data_out, libparam, drawfigTP, lbl_value_all, testylabel, testXScore);
    
    lbl_angle_all(bb).lbl_angle = lbl_angle;
    lbl_dist_all(bb).lbl_dist = lbl_dist;
    
    clstats_acc_all(bb, indices) = resultstat.accuracyTest;
    clstats_bac_all(bb, indices) = resultstat.bacTest;    
    
    fprintf('bac: %.4f \n', resultstat.bacTest);
end

%% bootstrapping many time
% idPCAll_candidate = cell(14,1);
% idPCAll_candidate(1,1) = {{'1'}};
% idPCAll_candidate(2,1) = {{'2'}};
% idPCAll_candidate(3,1) = {{'3'}};
% idPCAll_candidate(4,1) = {{'4'}};
% idPCAll_candidate(5,1) = {{'1';'2'}};
% idPCAll_candidate(6,1) = {{'1';'3'}};
% idPCAll_candidate(7,1) = {{'1','4'}};
% idPCAll_candidate(8,1) = {{'2','3'}};
% idPCAll_candidate(9,1) = {{'2','4'}};
% idPCAll_candidate(10,1) = {{'3','4'}};
% idPCAll_candidate(11,1) = {{'1','2', '3'}};
% idPCAll_candidate(12,1) = {{'1','2', '4'}};
% idPCAll_candidate(13,1) = {{'2','3', '4'}};
% idPCAll_candidate(14,1) = {{'1', '2','3', '4'}};
%idPCAll_candidate = idPCAll_candidate(1:9,1);

% idPCAll_candidate = cell(5,1);
% idPCAll_candidate(1,1) = {{'1'}};
% idPCAll_candidate(2,1) = {{'1';'2'}};
% idPCAll_candidate(3,1) = {{'1','2', '3'}};
% idPCAll_candidate(4,1) = {{'1', '2','3', '4'}};
% idPCAll_candidate(5,1) = {{'1', '2','3', '4', '5'}};
% idPCAll_candidate(6,1) = {{'1', '2','3', '4', '5', '6'}};


idPCAll_candidate = cell(2,1);
idPCAll_candidate(1,1) = {{'1'}};
idPCAll_candidate(2,1) = {{'1';'2'}};

B = 10;
ResultAll = struct([]);

for uu=1:length(idPCAll_candidate)
    tpc_cand = idPCAll_candidate(uu,1);
    tpc_inner = tpc_cand{1,1};
    idPCAll = [];
    for uuu=1:length(tpc_inner)
        idPCAll = [idPCAll str2num(char(tpc_inner(uuu)))];
    end
    
    bootstrapVar = false;
    if bootstrapVar
        clstats_acc_all = -1*ones(B,P);
        clstats_bac_all = -1*zeros(B,P);
    else
        clstats_acc_all = -1*ones(B,N);
        clstats_bac_all = -1*zeros(B,N);
    end
    clstats_acc_avg = zeros(B,1);
    clstats_bac_avg = zeros(B,1);    
    
    for bb=1:B
        if bootstrapVar
            [data_out, indices] =bootsampleXY(data);
            nonSlected = 1:N;
        else
            keepAgain = 1;
            while keepAgain == 1
                [data_out, indices, label_data_out] = bootsampleXY(data, false, label_data);
                keepAgain = length(lbl_value_all) - length(unique(label_data_out));
            end
            nonSlected = ones(N,1);
            nonSlected(indices) = 0;
            nonSlectedID = find(nonSlected);
        end
        
        warning off stats:princomp:colRankDefX
        [coeffs, scores, latent,tsquare] = princomp(data_out, 'econ');
        score_data = scores;
        loading_data = coeffs;
        
        testylabel = label_data(nonSlectedID);
        if bootstrapVar
            testX = data(:, indices);
        else
            testX = data(nonSlectedID, :);
        end
        testXScore = testX*coeffs(:, idPCAll);
        
        drawfigTP = false;
        for tt=1:length(lbl_value_all)
            curLblnum = lbl_value_all(tt);
            [idx_inside_t, Angles_t, MDistSq_t]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data_out, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfigTP, sample_name, strLabelAll, showSampleName, drawOneSigma);
            lbl_angle(curLblnum).v = Angles_t;
            lbl_dist(curLblnum).v = MDistSq_t;
        end
        [resultstat] = getSVMResult(score_data, idPCAll, label_data_out, libparam, drawfigTP, lbl_value_all, testylabel, testXScore);
        
        lbl_angle_all(bb).lbl_angle = lbl_angle;
        lbl_dist_all(bb).lbl_dist = lbl_dist;
        clstats_acc_all(bb, indices) = resultstat.accuracyTest;
        clstats_bac_all(bb, indices) = resultstat.bacTest;
        clstats_acc_avg(bb,1) = resultstat.accuracyTest;
        clstats_bac_avg(bb,1) = resultstat.bacTest;
    end
    
    ResultAll(uu).lbl_angle_all =lbl_angle_all;
    ResultAll(uu).lbl_dist_all =lbl_dist_all;
    ResultAll(uu).clstats_acc_all =clstats_acc_all;
    ResultAll(uu).clstats_bac_all =clstats_bac_all;
    
    ResultAll(uu).clstats_acc_avg =clstats_acc_avg;
    ResultAll(uu).clstats_bac_avg =clstats_bac_avg;        
end

    
%% bootstrapping with data of two labels

% idPCAll_candidate = cell(5,1);
% idPCAll_candidate(1,1) = {{'1'}};
% idPCAll_candidate(2,1) = {{'1';'2'}};
% idPCAll_candidate(3,1) = {{'1','2', '3'}};
% idPCAll_candidate(4,1) = {{'1', '2','3', '4'}};
% idPCAll_candidate(5,1) = {{'1', '2','3', '4', '5'}};
% idPCAll_candidate(6,1) = {{'1', '2','3', '4', '5', '6'}};

% idPCAll_candidate = cell(14,1);
% idPCAll_candidate(1,1) = {{'1'}};
% idPCAll_candidate(2,1) = {{'2'}};
% idPCAll_candidate(3,1) = {{'3'}};
% idPCAll_candidate(4,1) = {{'4'}};
% idPCAll_candidate(5,1) = {{'1';'2'}};
% idPCAll_candidate(6,1) = {{'1';'3'}};
% idPCAll_candidate(7,1) = {{'1','4'}};
% idPCAll_candidate(8,1) = {{'2','3'}};
% idPCAll_candidate(9,1) = {{'2','4'}};
% idPCAll_candidate(10,1) = {{'3','4'}};
% idPCAll_candidate(11,1) = {{'1','2', '3'}};
% idPCAll_candidate(12,1) = {{'1','2', '4'}};
% idPCAll_candidate(13,1) = {{'2','3', '4'}};
% idPCAll_candidate(14,1) = {{'1', '2','3', '4'}};

% idPCAll_candidate = cell(2,1);
% idPCAll_candidate(1,1) = {{'1'}};
% idPCAll_candidate(2,1) = {{'1';'2'}};

idPCAll_candidate = cell(1,1);
idPCAll_candidate(1,1) = {{'1';'2'}};


%B = 2000;
B = 10;
lambda = log(N)/N; %we refer to Bayesian estimation of the number of principal components. It needs to be extened with supervised/semi-supervised model selection.
cutoff_md_quantile = 0.10;

Params.B = B;
Params.idPCAll_candidate = idPCAll_candidate;
Params.data = data;
Params.label_data = label_data;
Params.lbl_value_all = lbl_value_all;
Params.cutoff_angle = cutoff_angle;
Params.cutoff_md_quantile = cutoff_md_quantile;
Params.sample_name = sample_name;
Params.strLabelAll = strLabelAll;
Params.showSampleName = showSampleName;
Params.drawOneSigma = drawOneSigma;
Params.lambda = lambda;
Params.libparam = libparam;
Params.drawfig = false;
Params.cutoff_cor_quantile = 0.50;

[ret_var_all, bestid, ResultAll, pSample, classRates, sampleNumbers, id_outlier] = findBestPCmatching(Params);

%% looking into classification rates for the existence of a sample
figure();
boxplot(classRates, sampleNumbers);
tp_idx = find( sampleNumbers == 14);
figure();
hist(classRates(tp_idx))

    %% testing for generated sample data
sum( ret_var_all(1).v < 28 ) + sum( ret_var_all(2).v < 28 )
%% looking into an empirical distribution of angles
pc_num = 2; %1 and 2
lbl_num = 1; 
%var_num = 20;
var_num = 70;
all_angles = [];

for bb=1:B    
    tv = ResultAll(pc_num).lbl_angle_all(bb).lbl_angle(lbl_num).v;
    all_angles = [all_angles; tv(var_num)*180/pi];
end
%histn(all_angles, 0, 100, 3)
histn(all_angles); hold on;
plot( mean(all_angles), 0, 'ro', 'LineWidth', 3');
plot([cutoff_angle cutoff_angle], [0 3e-5], 'r--', 'LineWidth', 2);
xlim([-10 140]);
ylim([0 3e-5]);

%% looking into an empirical distribution of distances
pc_num = 2; %1 and 2
lbl_num = 1; 
%var_num = 20;
%var_num = 70;
var_num = 718;
all_dists = [];

for bb=1:B    
    tv = ResultAll(pc_num).lbl_dist_all(bb).lbl_dist(lbl_num).v;
    all_dists = [all_dists; tv(var_num)];
end
%histn(all_angles, 0, 100, 3)
histn(all_dists); hold on;
histn(all_dists, 0, 30, 20); hold on;
plot( mean(all_angles), 0, 'ro', 'LineWidth', 3');
plot([cutoff_angle cutoff_angle], [0 3e-5], 'r--', 'LineWidth', 2);
xlim([-10 140]);
ylim([0 3e-5]);

%% 2nd round of PCA. Would this help? again
idx_union = union(ret_var_all(1).v, ret_var_all(2).v);
idPCAll = [1 2];
variable_name_2nd = variable_name(idx_union);
data_2nd = data(:,idx_union);

[coeffs_2nd, scores_2nd, latent_2nd,tsquare_2nd] = princomp(data_2nd);
score_data = scores_2nd;
loading_data = coeffs_2nd;

curLblnum = 1;
[idx_inside1_2nd]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll, false, false);

curLblnum = 2;
[idx_inside2_2nd]=getVarIndexPCMatch(score_data, loading_data, idPCAll, label_data, lbl_value_all, curLblnum, cutoff_angle, cutoff_md_quantile, drawfig, sample_name, strLabelAll);
%the rank of score_data can be less than 2.
%plot(1:length(score_data), score_data); hold on;

[resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, drawfigclsf, lbl_value_all);



%%

if saveresult
    %variable_name index
    sig_feature = [variable_name(idx_inside) idx_inside];
    warning off MATLAB:xlswrite:AddSheet
    xlswrite(cfname, {'variable','index'}, resultshname, 'A1');
    xlswrite(cfname, sig_feature, resultshname, 'A2');
end


%% pc component selection 2nd (finding)
%1st round of PCA
%idPCAll = [1 2];
%idPCAll = [1 3];
%idPCAll = [1 4];
%idPCAll = [2 3];
%idPCAll = [2 4];
%idPCAll = [2 5];
%idPCAll = [1 5];
%idPCAll = [2 5];
%idPCAll = [1 3 5];
fid = fopen('tp2-vitamine-bin.txt', 'w');
for uu=1:10
    for kk=uu+1:10
        idPCAll = [uu kk];
        [coeffs, scores, latent,tsquare] = princomp(data);
        score_data = scores;
        loading_data = coeffs;
        
        
        Params.score_data = score_data;
        Params.loading_data = loading_data;
        Params.idPCAll = idPCAll;
        Params.label_data = label_data;
        Params.lbl_value_all = lbl_value_all;
        %Params.curLblnum = curLblnum;
        Params.cutoff_angle = cutoff_angle;
        Params.cutoff_md_quantile = cutoff_md_quantile;
        Params.drawfig = drawfig;
        Params.sample_name = sample_name;
        Params.strLabelAll = strLabelAll;
        Params.showSampleName = false;
        Params.drawOneSigma = drawOneSigma;
        Params.siglev = 1;
        
        Params.curLblnum = 1;
        [idx_inside1, Angles1, MDistSq1, cutoff_angle1, cutoff_dist1, outlier_id1, sampleInsidePval1]= getVarIndexPCMatchNew(Params);
        
        libparam.ktype = 'radial';
        [resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, false, lbl_value_all);
        libparam.ktype = 'lda';
        [resultstatL] = getSVMResult(score_data, idPCAll, label_data, libparam, false, lbl_value_all);
        libparam.ktype = 'qda';
        [resultstatQ] = getSVMResult(score_data, idPCAll, label_data, libparam, false, lbl_value_all);
        %fprintf(fid, '[Accuracy] %d %d %d: %.3f\n', uu, kk, ee, resultstat.accuracyTest);
        fprintf(fid, '%d,%d,%.3f,%.3f,%.3f\n', uu, kk, resultstat.accuracyTest, resultstatL.accuracyTest, resultstatQ.accuracyTest);
        %fprintf('%d,%d,%d,%.3f\n', uu, kk, ee, resultstat.accuracyTest);
        
        %pause(1);
        %w = waitforbuttonpress;
    end
end
fclose(fid);

%% pc component selection 3rd (finding - 3 components)
%1st round of PCA
%idPCAll = [1 2];
%idPCAll = [1 3];
%idPCAll = [1 4];
%idPCAll = [2 3];
%idPCAll = [2 4];
%idPCAll = [2 5];
%idPCAll = [1 5];
%idPCAll = [2 5];
%idPCAll = [1 3 5];
%fid = fopen('tp3Sel.txt', 'w');
for uu=1:20
    for kk=uu+1:20
        for ee=kk+1:20
        idPCAll = [uu kk ee];
[coeffs, scores, latent,tsquare] = princomp(data);
score_data = scores;
loading_data = coeffs;


Params.score_data = score_data;
Params.loading_data = loading_data;
Params.idPCAll = idPCAll;
Params.label_data = label_data;
Params.lbl_value_all = lbl_value_all;
%Params.curLblnum = curLblnum;
Params.cutoff_angle = cutoff_angle;
Params.cutoff_md_quantile = cutoff_md_quantile;
Params.drawfig = drawfig;
Params.sample_name = sample_name;
Params.strLabelAll = strLabelAll;
Params.showSampleName = false;
Params.drawOneSigma = drawOneSigma;
Params.siglev = 1;

Params.curLblnum = 1;
[idx_inside1, Angles1, MDistSq1, cutoff_angle1, cutoff_dist1, outlier_id1, sampleInsidePval1]= getVarIndexPCMatchNew(Params);
[resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, drawfigclsf, lbl_value_all);
%fprintf(fid, '[Accuracy] %d %d %d: %.3f\n', uu, kk, ee, resultstat.accuracyTest);
fprintf('[Accuracy] %d %d %d: %.3f\n', uu, kk, ee, resultstat.accuracyTest);
%pause(1);
%w = waitforbuttonpress;
        end
    end
end
%fclose(fid);

%% pc component selection 2nd (finding) with a few labels
%1st round of PCA
%idPCAll = [1 2];
%idPCAll = [1 3];
%idPCAll = [1 4];
%idPCAll = [2 3];
%idPCAll = [2 4];
%idPCAll = [2 5];
%idPCAll = [1 5];
%idPCAll = [2 5];
%idPCAll = [1 3 5];
fid = fopen('tp2BL2.txt', 'w');
for uu=1:20
    for kk=uu+1:20
        idPCAll = [uu kk];
[coeffs, scores, latent,tsquare] = princomp(data);
score_data = scores;
loading_data = coeffs;


Params.score_data = score_data;
Params.loading_data = loading_data;
Params.idPCAll = idPCAll;
Params.label_data = label_data;
Params.lbl_value_all = lbl_value_all;
%Params.curLblnum = curLblnum;
Params.cutoff_angle = cutoff_angle;
Params.cutoff_md_quantile = cutoff_md_quantile;
Params.drawfig = drawfig;
Params.sample_name = sample_name;
Params.strLabelAll = strLabelAll;
Params.showSampleName = false;
Params.drawOneSigma = drawOneSigma;
Params.siglev = 1;

Params.curLblnum = 1;
[idx_inside1, Angles1, MDistSq1, cutoff_angle1, cutoff_dist1, outlier_id1, sampleInsidePval1]= getVarIndexPCMatchNew(Params);

sellblid = find( (label_data == 2) + (label_data==4));

libparam.ktype = 'radial';
[resultstat] = getSVMResult(score_data(sellblid,:), idPCAll, label_data(sellblid,1), libparam, false, unique(label_data(sellblid,1)));
libparam.ktype = 'lda';
[resultstatL] = getSVMResult(score_data(sellblid,:), idPCAll, label_data(sellblid,1), libparam, false, unique(label_data(sellblid,1)));
libparam.ktype = 'qda';
[resultstatQ] = getSVMResult(score_data(sellblid,:), idPCAll, label_data(sellblid,1), libparam, false, unique(label_data(sellblid,1)));
%fprintf(fid, '[Accuracy] %d %d %d: %.3f\n', uu, kk, ee, resultstat.accuracyTest);
fprintf(fid, '%d,%d,%.3f,%.3f,%.3f\n', uu, kk, resultstat.accuracyTest, resultstatL.accuracyTest, resultstatQ.accuracyTest);
%fprintf('%d,%d,%d,%.3f\n', uu, kk, ee, resultstat.accuracyTest);

%pause(1);
%w = waitforbuttonpress;
    end
end
fclose(fid);

%% simple confusion matrix with two label cases
tplba = [label_data resultstat.predict_label];

[length(find( (tplba(:,1) == lbl_value_all(1)).*(tplba(:,2) == lbl_value_all(1)))) ...
length(find( (tplba(:,1) == lbl_value_all(1)).*(tplba(:,2) == lbl_value_all(2))));
length(find( (tplba(:,1) == lbl_value_all(2)).*(tplba(:,2) == lbl_value_all(1)))) ...
length(find( (tplba(:,1) == lbl_value_all(2)).*(tplba(:,2) == lbl_value_all(2))))]

%% 2nd round of PCA. Using SVMs
idx_union = union(idx_inside1, idx_inside2);
variable_name_2nd = variable_name(idx_union);
data_2nd = data(:,idx_union);

testylabel = label_data; testX = data_2nd;
[predict_label, resultstat, dec_values, model] = skyLibsvm(label_data, data_2nd, libparam, testylabel, testX);
fprintf('accuracy: %.4f\n', resultstat.accuracyTest);

pvalall = zeros( size(data_2nd,2), 1);
for uu=1:size(data_2nd,2)
    %[h, pval] = ttest(data_2nd(:,uu), label_data); %do unpaired t-tests.

    tdata = data(:,uu);
    tp_id = find( tdata ~= 0);
    ttdata = tdata(tp_id);
    ttlbl = label_data(tp_id);
    ttdata1 = ttdata( find( ttlbl == 1) );
    ttdata2 = ttdata( find( ttlbl == 2) );

    [h, pval] = ttest2(ttdata1, ttdata2);
    pvalall(uu) = pval;
end
f_pv = [pvalall (1:size(data_2nd,2))'];
[sig_feature, cutpvalue] = getFDRSig(f_pv, 0.05);


variable_name_2ndAll = cell(length(idx_union),4);
for uu=1:length(idx_union)
    variable_name_2ndAll(uu,1) = variable_name_2nd(uu,1);
    variable_name_2ndAll(uu,2) = num2cell(idx_union(uu));
    variable_name_2ndAll(uu,3) = num2cell(pvalall(uu));
    variable_name_2ndAll(uu,4) = num2cell(0);
end
for uu=1:size( sig_feature(:,2),1)
    variable_name_2ndAll(sig_feature(uu,2),4) = num2cell(1);
end
%cellwrite('tpC18.txt', variable_name_2ndAll)
%% boxplot checking
for kk=1:length(idx_union)
    tdata = data(:,idx_union(kk));
    tp_id = find( tdata ~= 0);
    %boxplot(tdata(tp_id), label_data(tp_id));
    %pause(0.2);
    [h, pval] = ttest(tdata(tp_id), label_data(tp_id)); %do unpaired t-tests.
    ttdata = tdata(tp_id);
    ttlbl = label_data(tp_id);
    ttdata1 = ttdata( find( ttlbl == 1) );
    ttdata2 = ttdata( find( ttlbl == 2) );
    ttmean1 = mean(ttdata1);
    ttmean2 = mean(ttdata2);
    ttsig1 = std(ttdata1);
    ttsig2 = std(ttdata2);
    tn1 = length(ttdata1);
    tn2 = length(ttdata2);
    [h, pval] = ttest2(ttdata1, ttdata2);
    ttsigp = ((tn1-1)*ttsig1 + (tn2-1)*ttsig2)/ (tn1+tn2-2);
    tval = (ttmean1- ttmean2)/ (ttsigp*sqrt(1/tn1+1/tn2));
    cpv = 2*(1- tcdf( abs(tval), tn1+tn2-2));
    fprintf('pval:%.5f, tval:%.3f, c-pval:%.5f\n', pval, tval, cpv);
end


%% pc component selection 2nd with OPLS-DA
%1st round of PCA
%idPCAll = [1 2];
delete *.txt;
fid = fopen('tp2-vitamine-bin-OPLS-mean.txt', 'w');
maxCompNum = 20;
for uu=1:maxCompNum
    for kk=uu+1:maxCompNum
        idPCAll = [uu kk];
        %[coeffs, scores, latent,tsquare] = princomp(data);
        %score_data = scores;
        %loading_data = coeffs;
        
        
        Params.score_data = score_data;
        Params.loading_data = loading_data;
        Params.idPCAll = idPCAll;
        Params.label_data = label_data;
        Params.lbl_value_all = lbl_value_all;
        %Params.curLblnum = curLblnum;
        Params.cutoff_angle = cutoff_angle;
        Params.cutoff_md_quantile = cutoff_md_quantile;
        Params.drawfig = drawfig;
        Params.sample_name = sample_name;
        Params.strLabelAll = strLabelAll;
        Params.showSampleName = false;
        Params.drawOneSigma = drawOneSigma;
        Params.siglev = 1;
        
        Params.curLblnum = lbl_value_all(1);
        [idx_inside1, Angles1, MDistSq1, cutoff_angle1, cutoff_dist1, outlier_id1, sampleInsidePval1]= getVarIndexPCMatchNew(Params);
        
        libparam.ktype = 'radial';
        [resultstat] = getSVMResult(score_data, idPCAll, label_data, libparam, false, lbl_value_all);
        libparam.ktype = 'lda';
        [resultstatL] = getSVMResult(score_data, idPCAll, label_data, libparam, false, lbl_value_all);
        libparam.ktype = 'qda';
        [resultstatQ] = getSVMResult(score_data, idPCAll, label_data, libparam, false, lbl_value_all);
        %fprintf(fid, '[Accuracy] %d %d %d: %.3f\n', uu, kk, ee, resultstat.accuracyTest);
        fprintf(fid, '%d,%d,%.3f,%.3f,%.3f\n', uu, kk, resultstat.accuracyTest, resultstatL.accuracyTest, resultstatQ.accuracyTest);
        %fprintf('%d,%d,%d,%.3f\n', uu, kk, ee, resultstat.accuracyTest);
        
        %pause(1);
        %w = waitforbuttonpress;
    end
end
fclose(fid);
