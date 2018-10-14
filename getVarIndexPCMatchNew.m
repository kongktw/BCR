function [idx_inside, Angles, MDistSq, cutoff_angle, cutoff_dist, outlier_id, sampleInsidePval, curLbl, idx_filteredOutInfo]=getVarIndexPCMatchNew(Params)


if isfield(Params, 'score_data')
    score_data = Params.score_data;
else
    error('getVarIndexPCMatchNew:argChk', 'score_data is needed');
end

if isfield(Params, 'loading_data')
    loading_data = Params.loading_data;
else    
    error('getVarIndexPCMatchNew:argChk', 'loading_data is needed');
end

if isfield(Params, 'idPCAll')
    idPCAll = Params.idPCAll;
else
    idPCAll = [1 2];
end

if isfield(Params, 'label_data')
    label_data = Params.label_data;
else
    error('getVarIndexPCMatchNew:argChk', 'label_data is needed');
end

if isfield(Params, 'lbl_value_all')
    lbl_value_all = Params.lbl_value_all;
else
    lbl_value_all = unique(label_data)';
end

if isfield(Params, 'highlight_lbl_nums')
    show_lbl_nums = Params.show_lbl_nums;
else
    show_lbl_nums = lbl_value_all;
end

if isfield(Params, 'curLblnum')
    curLblnum = Params.curLblnum;
else
    curLblnum = lbl_value_all(1);
end

if isfield(Params, 'cutoff_angle')
    fprintf('[warning] cutoff_angle is deprecated.\n');
    cutoff_angle = Params.cutoff_angle;
else
    cutoff_angle = 30;
end

if isfield(Params, 'cutoff_md_quantile')
    cutoff_md_quantile = Params.cutoff_md_quantile;
else
    cutoff_md_quantile = 0.40;
end

if isfield(Params, 'drawfig')
    drawfig = Params.drawfig;
else
    drawfig = true;
end

if isfield(Params, 'sample_name')
    sample_name = Params.sample_name;
else
    sample_name = num2str( (1:size(score_data,1))' );
end

if isfield(Params, 'strLabelAll')
    strLabelAll = Params.strLabelAll;
else
    strLabelAll = num2str(label_data);
end

if isfield(Params, 'showSampleName')
    showSampleName = Params.showSampleName;
else
    showSampleName = false;
end

if isfield(Params, 'drawOneSigma')
    drawOneSigma = Params.drawOneSigma;
else
    drawOneSigma = true;
end

%deprecated, but used in the plotting
if isfield(Params, 'siglev')
    siglev = Params.siglev;
else
    siglev = 1;
end

if isfield(Params, 'showVarName')
    showVarName = Params.showVarName;
else
    showVarName = false;
end

if isfield(Params, 'showArrows')
    showArrows = Params.showArrows;
else
    showArrows = false;
end

if isfield(Params, 'alpha')
    alpha = Params.alpha;
else
    alpha = 0.05;
end

if isfield(Params, 'highID')
    highID = Params.highID;
else
    highID = [];
end

if isfield(Params, 'highIDmany')
    highIDmany = Params.highIDmany;
else
    highIDmany = [];
end

if isfield(Params, 'redrawfig')
    redrawfig = Params.redrawfig;
else
    redrawfig = true;
end

if isfield(Params, 'plotallloading')
    plotallloading = Params.plotallloading;
else
    plotallloading = true;
end

if isfield(Params, 'showMessage')
    showMessage = Params.showMessage;
else
    showMessage = false;
end

if isfield(Params, 'filterIndvLevel')
    filterIndvLevel = Params.filterIndvLevel;
else
    filterIndvLevel = -1; %meaning no filtering
end

if isfield(Params, 'filterIndvMethod') %Added on Oct/06/2018
    filterIndvMethod = Params.filterIndvMethod;
else
    filterIndvMethod = 'LogisticRegression'; %meaning no filtering
end

if isfield(Params, 'markSignificant')
    markSignificant = Params.markSignificant;
else
    markSignificant = true; %meaning no filtering
end

if isfield(Params, 'useOverallDist')
    useOverallDist = Params.useOverallDist;
else
    useOverallDist = true; %meaning the use of all loadings
end

if filterIndvLevel > 0
    dataXorig = Params.dataXorig;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


curLbl = find( label_data == curLblnum); %find idx where label = curLblnum (1 or 2)

%finding scores expressed in curLbl and idPCAll
X = [];
for kk=1:length(idPCAll)
    X = [X score_data(curLbl,idPCAll(kk))]; % save 1st and 2nd columns of score data relating label 1 to X
end

%centering the scores and preparing the covariance matrix (CovX)
Xmean = mean(X,1);
Xcent = X-repmat(Xmean, size(X,1),1); % demeaning
CovX = Xcent'*Xcent/(size(X,1)-1); %2x2 covariance matrix

%finding loadings expressed in idPCAll
current_loading = [];
for kk=1:length(idPCAll)
    current_loading = [current_loading loading_data(:,idPCAll(kk))]; % save loading vetors of 1st and 2nd loading variables, 1000x2 matrix
end

%computing distances between loadings and scores
doLoadingCenter = false; %test to see how it affects
if doLoadingCenter
    loading_data_center = current_loading-repmat(Xmean, size(current_loading,1),1);
else
    loading_data_center = current_loading;
end

useMahal = true;
if (useMahal == true)
    %Sky: when  size(X,1) <= size(X,2), we should not use mahal
    if size(X,1) <= size(X,2)
        MDistSq = Eucldistance(loading_data_center(:,:)', mean(X,1)');
    else
        MDistSq = mahal(loading_data_center,X); 
    end
    %MDistSq = Eucldistance(loading_data_center(:,:)', mean(X,1)');
else
    InvCox = CovX^(-1);
    MDistSq = zeros(size(current_loading,1),1);
    for kk=1:size(current_loading,1)
        MDistSq(kk) = loading_data_center(kk,:)*InvCox*loading_data_center(kk,:)';
    end
end


%computing an angle between the centeroid and each of loadings
Angles = zeros(size(current_loading,1),1);
XmeanNorm = Xmean / norm(Xmean);
for kk=1:size(current_loading,1)
    Angles(kk) = acos(sum(XmeanNorm.*current_loading(kk,:))/norm(current_loading(kk,:))); % calculate arccos between each loading and average of loadings, 1000x1,range is 0 to 3.14
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%finding the thresholding angle within a siglev level

%computing distances within points in the label (curLbl)
%better use mahalobis distances here!
if (useMahal == true)
    %Sky: when  size(X,1) <= size(X,2), we should not use mahal
    if size(X,1) <= size(X,2)
        MDistSqX = Eucldistance(X(:,:)', mean(X,1)');
    else
        MDistSqX = mahal(X,X); 
        %(X(1,:)-Xmean)*InvCox*(X(1,:)-Xmean)' - mahal(X(1,:),X)
    end    
else
    InvCox = CovX^(-1);
    MDistSqX = zeros(size(X,1),1);
    for kk=1:size(X,1)
        MDistSqX(kk) = (X(kk,:)-Xmean)*InvCox*(X(kk,:)-Xmean)';
    end   
end


%id_X_within = find( sqrt(MDistSqX) < siglev ); %no longer used
id_X_within = find( MDistSqX < chi2inv(1-alpha,length(idPCAll)) );  
%we can use this as a way of outliers detection: Applied Multivariate
%Statistical Analysis 6th Edition, p 459.
%Let us record chi2cdf(dist,length(idPCAll))
%Check out that the distance between the centeroid and one observation
%follows a chi-square distribution with a degree of freedom length(idPCAll).
%better to use Hotelling's T? Yes, but they are equivalent in this
%since \bar{x} is replaced by x (n=1). This is how MATLAB implements it.


id_X_outside = find( MDistSqX >= chi2inv(1-alpha,length(idPCAll)) ); % find scores of labels that are tested and outside of CI
outlier_id = curLbl(id_X_outside); 
sampleInsidePval = 1-chi2cdf(MDistSqX, length(idPCAll)); % calculate  p-values of distance between label and score that are tested

Angles_score_within = zeros(length(id_X_within),1);
for kk=1:length(id_X_within)
    Angles_score_within(kk) = acos(sum(XmeanNorm.*X(id_X_within(kk),:))/norm(X(id_X_within(kk),:))); 
end

%fstat = (size(X,1)- size(X,2))/(size(X,1)-1)/size(X,2)*size(X,1)*mahal(X,X); %~ F_{p,n-p} = F_{size(X,2), size(X,1) - size(X,2)}
cutoff_angle = max(Angles_score_within) * 180 / pi; % convert the max of the above to angle
%cutoff_angle = 30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


try
    if length(cutoff_angle) > 0
        idx_inside_angle = find( Angles < cutoff_angle/180*pi);
        %useOverallDist = true;
        %useOverallDist = false;
        if useOverallDist
            cutoff_dist = quantile(MDistSq, cutoff_md_quantile);
        else
            cutoff_dist = quantile(MDistSq(idx_inside_angle), cutoff_md_quantile);
        end
        
        %idx_inside = find( (Angles < cutoff_angle/180*pi) .* (MDistSq < quantile(MDistSq,cutoff_md_quantile)) );
        idx_inside = find( (Angles < cutoff_angle/180*pi) .* (MDistSq < cutoff_dist) );
        %fprintf('Cutting dist: %.4f \n', quantile(MDistSq,cutoff_md_quantile));
        if showMessage
            fprintf('Cutting angle: %.4f \n', cutoff_angle);
            fprintf('# of inside features %d for label %d\n',length(idx_inside), curLblnum);
        end
        
        if filterIndvLevel > 0
            %RegPvalues = zeros(size(idx_inside,1),1);
            %fprintf('Here we go about filterIndvLevel\n');
            idx_inside_filtered = [];
            idx_filteredOutInfo = struct('variables', [], 'pvalues', []); %added 2018/10/04
            %idx_filteredOutInfo.variables = [];
            %idx_filteredOutInfo.pvalues =[];
            for kk=1:size(idx_inside,1)
                if strcmp(filterIndvMethod, 'LinearRegression')
                    [tb,tbint,tr,trint,tstats] = regress(label_data,[ones(size(dataXorig,1),1)  dataXorig(:,idx_inside(kk))]);
                    %RegPvalues(kk) = tstats(3);
                    %fprintf('pval:%.4f\n', tstats(3));
                    if tstats(3) < filterIndvLevel
                        idx_inside_filtered = [idx_inside_filtered; idx_inside(kk)];
                    else
                        idx_filteredOutInfo.variables = [idx_filteredOutInfo.variables; idx_inside(kk)];
                        idx_filteredOutInfo.pvalues = [idx_filteredOutInfo.pvalues; tstats(3)];
                    end
                else %default : LogisticRegression
                    %[tb,tbint,tr,trint,tstats] = regress(label_data,[ones(size(dataXorig,1),1)  dataXorig(:,idx_inside(kk))]);
                    [B,dev,stats] =mnrfit(dataXorig(:,idx_inside(kk)),label_data);
                    if stats.p < filterIndvLevel
                        idx_inside_filtered = [idx_inside_filtered; idx_inside(kk)];
                    else
                        idx_filteredOutInfo.variables = [idx_filteredOutInfo.variables; idx_inside(kk)];
                        idx_filteredOutInfo.pvalues = [idx_filteredOutInfo.pvalues; tstats(3)];
                    end
                end
            end
            idx_inside = idx_inside_filtered;
        end
    else
        idx_inside_angle = [];
        cutoff_dist = 0;
        idx_inside = [];
    end
catch exception
    fprintf('Here we go. No angle?\n');
end


if drawfig && (length(idPCAll) == 2) && size(X,1) > 1
    
    lbl1_value = lbl_value_all(1);
    lbl2_value = lbl_value_all(2);
    
    idLB1 = find( label_data == lbl1_value);
    idLB2 = find( label_data == lbl2_value);

    [U1,S1,V1] = svd(CovX);    
    
    %targetLongRadiusSQ = max(var(current_loading(idx_inside,1)), var(current_loading(idx_inside,2)));
    targetLongRadiusSQ = max(var(current_loading(idx_inside,:)));
    
    siglevLoad = 2;
    S1_loading = siglevLoad*sqrt(targetLongRadiusSQ);
    S2_loading = siglevLoad*sqrt(targetLongRadiusSQ/S1(1,1)*S1(2,2));
    m1_loading = mean(current_loading(idx_inside,1));
    m2_loading = mean(current_loading(idx_inside,2));
    ang = atan( U1(2,1)/U1(1,1) );
    idPC1 = idPCAll(1);
    idPC2 = idPCAll(2);
    strLabel1 = strLabelAll(1);
    strLabel2 = strLabelAll(2);
    lw = 2;
    set(0, 'DefaultAxesFontSize', 15);
    set(0, 'DefaultAxesFontName', 'Arial');
    fs = 15;
    msize = 10;
    %cc_color = [213 92 199]/255;
    cc_color = [119 62 97]/255;

    tp_rot = [cos(cutoff_angle/180*pi) -sin(cutoff_angle/180*pi);sin(cutoff_angle/180*pi) cos(cutoff_angle/180*pi)];    
    tp_rot_i = [cos(cutoff_angle/180*pi) sin(cutoff_angle/180*pi);-sin(cutoff_angle/180*pi) cos(cutoff_angle/180*pi)];    

%     figure(11); clf;
%     plot(score_data(idLB1(1),idPC1), score_data(idLB1(1),idPC2), 'bo', 'MarkerSize', msize); hold on;
%     plot(score_data(idLB2(1),idPC1), score_data(idLB2(1),idPC2), 'rx', 'MarkerSize', msize);
%     legend(char(strLabel1), char(strLabel2), 'Location', 'NorthEast');
%     
%     plot(score_data(idLB1,idPC1), score_data(idLB1,idPC2), 'bo', 'MarkerSize', msize); hold on;
%     plot(score_data(idLB2,idPC1), score_data(idLB2,idPC2), 'rx', 'MarkerSize', msize);
    
    mkstr = '*oxs^v+d<>ph';
    %rcolall = floor(255*rand(length(lbl_value_all),3))/255;
    if length(lbl_value_all) < 7
        rcolall = [ 0 0 255; 255 0 0; 0 255 0; 0 128 0; 128 0 128; 0 0 0]/255;
    else
        rcolall = floor(rand(length(lbl_value_all),3)*255+1)/255;
    end
    
    figure(31); 
    if redrawfig
        clf;    
    end
    hold on;
    title('Scores');    
    %tp_PCIDs = [1 3 5];
    tp_PCIDs = idPCAll;
    %tp_PCIDs = [2 3 5];
    %show_lbl_nums = [2 3];
    %show_lbl_nums = [2 3];
    ShowText = false;
    
    for kk=1:length(lbl_value_all)
        tp_idx = find( label_data == lbl_value_all(kk));
        tpcol = rcolall(kk,:);
        if length( find(show_lbl_nums == lbl_value_all(kk))) > 0
            plot(score_data(tp_idx(1),tp_PCIDs(1)), score_data(tp_idx(1),tp_PCIDs(2)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 11, 'LineWidth', 3);
        else
            plot(score_data(tp_idx(1),tp_PCIDs(1)), score_data(tp_idx(1),tp_PCIDs(2)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 5, 'LineWidth', 2);
        end
    end
    %legend('Coronary','Vein Pre', 'Vein Post');
    %legend(num2str(Params.lbl_value_all'));
    legend(strLabelAll);
    for kk=1:length(lbl_value_all)
        tp_idx = find( label_data == lbl_value_all(kk));
        tpcol = rcolall(kk,:);
        if length( find(show_lbl_nums == lbl_value_all(kk))) > 0
            plot(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 11, 'LineWidth', 3);
        else
            plot(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 5, 'LineWidth', 2);
        end
        
        if ShowText
            for uu=1:length(lbl_value_all)
                highlightlbl = lbl_value_all(uu);
                if length(find(show_lbl_nums == highlightlbl))>0 && length( find( highlightlbl == lbl_value_all(kk))) > 0
                    %text(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), num2str(kk), 'FontSize', 15, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                    tyu = 1;
                    tyx = 1;
                    tpFsz = 15;
                    if iscell(sample_name(tp_idx))
                        text(tyx+score_data(tp_idx,tp_PCIDs(1)), tyu+score_data(tp_idx,tp_PCIDs(2)), sample_name(tp_idx), 'FontSize', tpFsz, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                    else
                        tp_d = cell2mat(sample_name(tp_idx));
                        if isnumeric(tp_d)
                            text(tyx+score_data(tp_idx,tp_PCIDs(1)), tyu+score_data(tp_idx,tp_PCIDs(2)), strcat(num2str(kk), '-',num2str(tp_d)), 'FontSize', tpFsz, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                        else
                            text(tyx+score_data(tp_idx,tp_PCIDs(1)), tyu+score_data(tp_idx,tp_PCIDs(2)), strcat(num2str(kk), '-',tp_d), 'FontSize', tpFsz, 'FontName', 'Arial', 'FontWeight', 'bold', 'Color', tpcol);
                        end
                    end
                end
            end
        end
        xlabel(num2str(tp_PCIDs(1)));
        ylabel(num2str(tp_PCIDs(2)));        
        
        %view([-43 18]);
    end

    
    if showSampleName
        tyu = 0;
        tyx = 1;
        tpFsz = 15;
        %Sky: I wonder why it worked previously. Check out if the
        %size(score_data, 1) is the same as that of sample_name!
        text(tyx+score_data(:, idPC1), tyu+score_data(:,idPC2), sample_name, 'FontSize', tpFsz);
    end    
    title('Scores');    
    %plot(score_data(idLB1,idPC1), score_data(idLB1,idPC2), 'b.', 'MarkerSize', msize); hold on;
    %plot(score_data(idLB2,idPC1), score_data(idLB2,idPC2), 'r.', 'MarkerSize', msize); hold on;
    axis equal
    if drawOneSigma
        ellipse( siglev*sqrt(S1(1,1)), siglev*sqrt(S1(2,2)), ang, Xmean(1), Xmean(2), 'k');
    end
    %arrow([0 0],[Xmean(1) Xmean(2)],'EdgeColor','b','FaceColor','b', 'Width', 2, 'Length', 17, 'LineStyle',':');
    %arrow([0 0],(tp_rot*[Xmean(1) Xmean(2)]')','EdgeColor','b','FaceColor','b', 'Width', 2, 'Length', 17, 'LineStyle','--');
    %arrow([0 0],(tp_rot_i*[Xmean(1) Xmean(2)]')','EdgeColor','b','FaceColor','b', 'Width', 2, 'Length', 17, 'LineStyle','--');
    if showArrows
        arrow([0 0], [Xmean(1) Xmean(2)],'EdgeColor','k','FaceColor',cc_color, 'Width', 2, 'Length', 17, 'LineStyle','-');
        arrow([0 0],(tp_rot*[Xmean(1) Xmean(2)]')','EdgeColor','k','FaceColor','m', 'Width', 2, 'Length', 17, 'LineStyle','-');
        arrow([0 0],(tp_rot_i*[Xmean(1) Xmean(2)]')','EdgeColor','k','FaceColor','m', 'Width', 2, 'Length', 17, 'LineStyle','-');
    end

        
    figure(22); 
    if redrawfig
        clf;    
    end
    if length(highIDmany) >0 
        tpColList = 'rbkmc';
        tpMarList = 'sd^vp';
        
%         for ee=1:length(highIDmany)
%             tphighID = highIDmany(ee).id;
%             ttpCol = tpColList(mod(ee-1,length(tpColList))+1);
%             ttpMar = tpMarList(mod(ee-1,length(tpMarList))+1);
%             if length(tphighID) > 0
%                 for uu=1:1
%                     plot(current_loading(tphighID(uu),1), current_loading(tphighID(uu),2), ttpMar, 'MarkerSize', msize, 'color', ttpCol, 'MarkerFaceColor', ttpCol); hold on;
%                 end
%             end
%         end

        
        tpID_actually_drawn = []; %Sep-08-2018, Sky. the vector for a certain id can be zero. We need to collect the id's whose vector is non-zero length.
        for ee=1:length(highIDmany)
            tphighID = highIDmany(ee).id;
            if length(tphighID) > 0 %Sep-08-2018, Sky. the vector for a certain id can be zero. We need to collect the id's whose vector is non-zero length.
                tpID_actually_drawn = [tpID_actually_drawn ee];
                ttpCol = tpColList(mod(ee-1,length(tpColList))+1);
                ttpMar = tpMarList(mod(ee-1,length(tpMarList))+1);
    %             for uu=1:length(tphighID)
    %                 plot(current_loading(tphighID(uu),1), current_loading(tphighID(uu),2), ttpMar, 'MarkerSize', msize, 'color', ttpCol, 'MarkerFaceColor', ttpCol); hold on;
    %             end
                plot(current_loading(tphighID,1), current_loading(tphighID,2), ttpMar, 'MarkerSize', msize, 'color', ttpCol, 'MarkerFaceColor', ttpCol); hold on;
            end
        end
        %legend( num2str( (1:length(highIDmany))' ) );
        legend( num2str( (1:length(tpID_actually_drawn))' ) );
    end

    if plotallloading
        plot(current_loading(:,1), current_loading(:,2), 'g.', 'MarkerSize', msize); hold on;
    end

    if length(highID) >0 
        for uu=1:length(highID)
            plot(current_loading(highID(uu),1), current_loading(highID(uu),2), 's', 'MarkerSize', msize, 'color', 'r', 'MarkerFaceColor', 'r'); hold on;
        end
    end

    
    title(sprintf('Loadings with %d inside features',length(idx_inside)));
    color_orange = [255 140 0]/255;
    if markSignificant
        plot(current_loading(idx_inside,1), current_loading(idx_inside,2), 'o', 'MarkerSize', msize+1, 'LineWidth', lw, 'Color', color_orange); hold on;
    end
    if drawOneSigma
        ellipse( S1_loading, S2_loading, ang, m1_loading, m2_loading, 'k');
    end    
    %arrow([0 0],[m1_loading m2_loading],'EdgeColor','b','FaceColor','b', 'Width', 4, 'Length', 17);
    tp_scaled_mean = norm([m1_loading m2_loading])/norm([Xmean(1) Xmean(2)])*[Xmean(1) Xmean(2)];
    if showArrows
        arrow([0 0], tp_scaled_mean,'EdgeColor','k','FaceColor',cc_color, 'Width', 2, 'Length', 17, 'LineStyle',':');
        %arrow([0 0], [m1_loading m2_loading],'EdgeColor','k','FaceColor',cc_color, 'Width', 2, 'Length', 17, 'LineStyle','-');
        arrow([0 0],(tp_rot*tp_scaled_mean')','EdgeColor','k','FaceColor','m', 'Width', 2, 'Length', 17, 'LineStyle','-');
        arrow([0 0],(tp_rot_i*tp_scaled_mean')','EdgeColor','k','FaceColor','m', 'Width', 2, 'Length', 17, 'LineStyle','-');
    end
    %showVarName = false;
    if showVarName
        %Sky: I wonder why it worked previously. Check out if the
        %size(score_data, 1) is the same as that of sample_name!
        var_name = (1:size(current_loading, 1))';
        text(current_loading(idx_inside,1), current_loading(idx_inside,2), num2str(var_name(idx_inside)));
    end        
    axis equal
    xlabel(num2str(tp_PCIDs(1)));
    ylabel(num2str(tp_PCIDs(2)));    
 
end



if drawfig && (length(idPCAll) == 3) && size(X,1) > 1
    
    lbl1_value = lbl_value_all(1);
    lbl2_value = lbl_value_all(2);
    
    idLB1 = find( label_data == lbl1_value);
    idLB2 = find( label_data == lbl2_value);

    [U1,S1,V1] = svd(CovX);    
    
    %targetLongRadiusSQ = max(var(current_loading(idx_inside,1)), var(current_loading(idx_inside,2)));
    targetLongRadiusSQ = max(var(current_loading(idx_inside,:)));
    
    siglevLoad = 2;
    S1_loading = siglevLoad*sqrt(targetLongRadiusSQ);
    S2_loading = siglevLoad*sqrt(targetLongRadiusSQ/S1(1,1)*S1(2,2));
    m1_loading = mean(current_loading(idx_inside,1));
    m2_loading = mean(current_loading(idx_inside,2));
    ang = atan( U1(2,1)/U1(1,1) );
    idPC1 = idPCAll(1);
    idPC2 = idPCAll(2);
    idPC3 = idPCAll(3);
    
    strLabel1 = strLabelAll(1);
    strLabel2 = strLabelAll(2);
    lw = 2;
    set(0, 'DefaultAxesFontSize', 15);
    set(0, 'DefaultAxesFontName', 'Arial');
    fs = 15;
    msize = 10;
    %cc_color = [213 92 199]/255;
    cc_color = [119 62 97]/255;

        
    
    mkstr = '*os^vx+d<>ph';
    %rcolall = floor(255*rand(length(lbl_value_all),3))/255;
    %mkstr = '*os^vx+d<>ph';
    %rcolall = [255 0 0; 0 0 255; 0 128 0; 0 0 0]/255;
    rcolall = [0 0 0; 255 0 0; 0 128 0; 0 0 255;]/255;
    
    figure(31); 
    if redrawfig
        clf;
    end

    hold on;
    title('Scores');    
    %tp_PCIDs = [1 3 5];
    tp_PCIDs = idPCAll;
    %tp_PCIDs = [2 3 5];
    %show_lbl_nums = [2 3];
    %show_lbl_nums = [2 4];
    ShowText = false;
    
    for kk=1:length(lbl_value_all)
        tp_idx = find( label_data == lbl_value_all(kk));
        tpcol = rcolall(kk,:);
        if length( find(show_lbl_nums == lbl_value_all(kk))) > 0
            plot3(score_data(tp_idx(1),tp_PCIDs(1)), score_data(tp_idx(1),tp_PCIDs(2)), score_data(tp_idx(1),tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 11, 'LineWidth', 3);
        else
            plot3(score_data(tp_idx(1),tp_PCIDs(1)), score_data(tp_idx(1),tp_PCIDs(2)), score_data(tp_idx(1),tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 5, 'LineWidth', 2);
        end
    end
    %legend('Coronary','Vein Pre', 'Vein Post');
    %legend(num2str(Params.lbl_value_all'));
    legend(strLabelAll);


    
    for kk=1:length(lbl_value_all)
        tp_idx = find( label_data == lbl_value_all(kk));
        tpcol = rcolall(kk,:);
        if length( find(show_lbl_nums == lbl_value_all(kk))) > 0
            plot3(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 11, 'LineWidth', 3);
        else
            plot3(score_data(tp_idx,tp_PCIDs(1)), score_data(tp_idx,tp_PCIDs(2)), score_data(tp_idx,tp_PCIDs(3)), mkstr(mod( kk, length(mkstr))+1), 'Color', tpcol, 'MarkerSize', 5, 'LineWidth', 2);
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
    end
    
    
    grid on;
%     tmg = (max(score_data(tp_idx,tp_PCIDs(1))) - min(score_data(tp_idx,tp_PCIDs(1))))*0.;
%     drawXYZplane(...
%         [min(score_data(tp_idx,tp_PCIDs(1)))-tmg max(score_data(tp_idx,tp_PCIDs(1)))+tmg], ...
%         [min(score_data(tp_idx,tp_PCIDs(2)))-tmg max(score_data(tp_idx,tp_PCIDs(2)))+tmg], ...
%         [min(score_data(tp_idx,tp_PCIDs(3)))-tmg max(score_data(tp_idx,tp_PCIDs(3)))+tmg]);

%     drawXYZplane(...
%         [-100 150], ...
%         [-60 50], ...
%         [-40 30]);

    view([-38 28]);
    xlabel(num2str(tp_PCIDs(1)));
    ylabel(num2str(tp_PCIDs(2)));
    zlabel(num2str(tp_PCIDs(3)));
    
    figure(22); 
    if redrawfig
        clf;    
    end

    if plotallloading
        plot3(current_loading(:,1), current_loading(:,2), current_loading(:,3), 'g.', 'MarkerSize', msize); hold on;
    end
    
    if length(highID) >0 
        for uu=1:length(highID)
            plot3(current_loading(highID(uu),1), current_loading(highID(uu),2), current_loading(highID(uu),3), 's', 'MarkerSize', msize, 'color', 'r', 'MarkerFaceColor', 'r'); hold on;
        end
    end

    if length(highIDmany) >0 
        tpColList = 'rbkmc';
        tpMarList = 'sd^vp';
        for ee=1:length(highIDmany)
            tphighID = highIDmany(ee).id;
            ttpCol = tpColList(mod(ee-1,length(tpColList))+1);
            ttpMar = tpMarList(mod(ee-1,length(tpMarList))+1);
            for uu=1:length(tphighID)
                plot3(current_loading(tphighID(uu),1), current_loading(tphighID(uu),2), current_loading(tphighID(uu),3), ttpMar, 'MarkerSize', msize, 'color', ttpCol, 'MarkerFaceColor', ttpCol); hold on;
            end
        end
    end
    
    title(sprintf('Loadings with %d inside features',length(idx_inside)));
    color_orange = [255 140 0]/255;
    if markSignificant
        plot3(current_loading(idx_inside,1), current_loading(idx_inside,2), current_loading(idx_inside,3), 'o', 'MarkerSize', msize+1, 'LineWidth', lw, 'Color', color_orange); hold on;
    end
    axis equal
    grid on;
    view([-38 28]);
 
end



