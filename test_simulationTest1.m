%% generation of data and test of the chosen methods
clear all; clc;
N = 200;
P = 1000;
label_data = (rand(N,1) > 0.4) + 1;

strLabelAll = {'Control';'Case'}; 
lbl_value_all = [1 2];
data = zeros(N, P);
variable_name = (1:P)'; 
sample_name = strcat('sp-',num2str((1:N)'));

idx_1 = find( label_data == 1);
idx_2 = find( label_data == 2);

curalpha = 0.05;
alllevels = [0.01 0.03 0.05 0.07 0.10 0.15 0.20];
TotITER = 1000; 
noise_controls = [0.1 0.05 0.03  -1];


%%
for ww=1:length(noise_controls)
    noiselevel = noise_controls(ww);
    for rr=1:length(alllevels)
        tpcurlev = alllevels(rr);         
      
        resultFDR1 = zeros(TotITER,1);
        resultFDR2 = zeros(TotITER,1);
        resultFDR3 = zeros(TotITER,1);
        resultFDR4 = zeros(TotITER,1);
        resultFDR4est = struct([]);
        resultVarFDR = zeros(P,1);
        

        resultFDRlogistic1 = zeros(TotITER,1);
        resultFDRlogistic2 = zeros(TotITER,1);
        resultFDRlogistic3 = zeros(TotITER,1);
        resultFDRlogistic4 = zeros(TotITER,1);
        resultFDRlogistic4est = struct([]);
        resultVarFDRlogistic = zeros(P,1);

        resultOPCM1 = zeros(TotITER,1);
        resultOPCM2 = zeros(TotITER,1);
        resultOPCM3 = zeros(TotITER,1);
        resultOPCM4 = zeros(TotITER,1);
        resultOPCM4est = struct([]);
        resultVarOPCM = zeros(P,1);
        resultOPCM_filtered = struct([]); %%2018/10/04
        
        resultSTOCSY1 = zeros(TotITER,1);
        resultSTOCSY2 = zeros(TotITER,1);
        resultSTOCSY3 = zeros(TotITER,1);
        resultSTOCSY4 = zeros(TotITER,1);
        resultSTOCSY4est = struct([]);
        resultVarSTOCSY = zeros(P,1);
        
        doFDR1test = false; %%2018/10/04
        doFDR2test = false; %%2018/10/04
        doPCLS2test = true; %%2018/10/04
        doSTOCSY2test = false; %%2018/10/04
        
        for uu=1:TotITER
            % a new way to settle three layers
            for kk=1:P
                if kk >= 1 && kk <= 4 
                    data(idx_1, kk) = 3 + rand( length(idx_1), 1);
                    data(idx_2, kk) = 1 + rand( length (idx_2), 1);
                elseif kk >= 5 && kk <= 8 
                    data(idx_1, kk) = 1 + rand( length(idx_1), 1);
                    data(idx_2, kk) = 3 + rand( length(idx_2), 1);
                elseif kk== 9 || kk == 11 || kk == 13 || kk == 15 || kk == 29 
                    [r r2] = gen2Dsample(length(idx_1), length(idx_2)); 
                    data(idx_1, kk) = r(:,1);
                    data(idx_1, kk+1) = r(:,2);
                    data(idx_2, kk) = r2(:,1);
                    data(idx_2, kk+1) = r2(:,2);
                elseif kk == 17 || kk == 20 || kk == 23 || kk == 26 
                    [r r2] = gen3Dsample(length(idx_1), length(idx_2)); 
                    data(idx_1, kk) = r(:,1);
                    data(idx_1, kk+1) = r(:,2);
                    data(idx_1, kk+2) = r(:,3);
                    data(idx_2, kk) = r2(:,1);
                    data(idx_2, kk+1) = r2(:,2);
                    data(idx_2, kk+2) = r2(:,3);
                elseif ( (kk >= 31) && (kk < 121))
                    if mod(kk-31,3) == 0
                        for ss=1:size(data,1)
                            data(ss, kk:(kk+2))=gennetvar(data( ss, floor((kk-30)/3)+1), 10, 3);
                        end
                    end
                elseif ( (kk >= 121) && (kk < 391)) 
                    if mod(kk-121,3) == 0
                        for ss=1:size(data,1)
                            data(ss, kk:(kk+2))=gennetvar(data( ss, floor((kk-120)/3)+30), 10, 3);
                        end
                    end
                elseif ( (kk >= 391)) 
                    data(idx_1, kk) = 2 + rand( length(idx_1), 1);
                    data(idx_2, kk) = 2 + rand( length(idx_2), 1);
                    if noiselevel ~= -1  % if noiselevel == -1, it means complete random in an uncontrolled manner
                        [tb,tbint,tr,trint,tstats] = regress(label_data,[ones(size(data,1),1)  data(:,kk)]);
                        while tstats(3) < noiselevel % tstats(3) = p-value of the full model
                            data(idx_1, kk) = 2 + rand( length(idx_1), 1);
                            data(idx_2, kk) = 2 + rand( length(idx_2), 1);
                            [tb,tbint,tr,trint,tstats] = regress(label_data,[ones(size(data,1),1)  data(:,kk)]);
                        end
                    end
                end
            end
            
            
            doShowThree = false; 
            if doShowThree
                figure(31); clf; hold on;
                kk=17; mksize = 13; lw = 2;
                plot3(data(idx_1, kk), data(idx_1, kk+1), data(idx_1, kk+2), 'bo', 'LineWidth', lw, 'MarkerSize', mksize);
                plot3(data(idx_2, kk), data(idx_2, kk+1), data(idx_2, kk+2), 'rx', 'LineWidth', lw, 'MarkerSize', mksize);
                legend('Label 0', 'Label 1');
                grid on;
                xlabel('X_9');ylabel('X_{10}');zlabel('X_{11}');
                view([46 32]);
                %saveas(gcf, 'illust_X1X2X3.fig');
                figure(32); clf; hold on;
                kk=1; mksize = 13;
                plot(data(idx_1, kk), data(idx_1, kk+4),'bo', 'LineWidth', lw, 'MarkerSize', mksize);
                plot(data(idx_2, kk), data(idx_2, kk+4),'rx', 'LineWidth', lw, 'MarkerSize', mksize);
                legend('Label 0', 'Label 1');
                grid on;
                xlabel('X_1');ylabel('X_5');
            end
            %add one outlier
            addoutlier = false;
            if addoutlier
                data(end,:) = rand(1,P);
            end
            
            isAutoScalse = true;
            drawfig = false;
            showSampleName = true;
            
            if isAutoScalse 
                [data] = normalizeData(data); %n-by-p
            end
            
            %graphical setting
            lw = 2;
            set(0, 'DefaultAxesFontSize', 15);
            set(0, 'DefaultAxesFontName', 'Arial');
            fs = 15;
            msize = 8;
            
            checkBoxPlot = false;
            if checkBoxPlot
                % checking boxplots
                ctg = 12;
                boxplot(data(:, ctg), label_data);
            end
            
            if doFDR1test
                % doing one-way fdr
                chem_shift_FDR = (1:P)';
                dataspec = (label_data)'; 
                WayNum = 1;
                q = tpcurlev;
                [sig_feature] = doFDR(data', dataspec, q, chem_shift_FDR, WayNum); 

                resultVarFDR( sig_feature(:,3),1) = resultVarFDR( sig_feature(:,3),1) + 1;

                tnum1 = sum( sig_feature(:,3) <= 30); 
                tnum2 = sum( (sig_feature(:,3) > 30) .* (sig_feature(:,3) <= 120));
                tnum3 = sum( (sig_feature(:,3) > 120) .* (sig_feature(:,3) <= 390));
                tnum4 = sum( (sig_feature(:,3) >= 391) );

                resultFDR1(uu,1) = tnum1;
                resultFDR2(uu,1) = tnum2;
                resultFDR3(uu,1) = tnum3;
                resultFDR4(uu,1) = tnum4;
                if tnum4 > 0 
                    %checking out the detected variables in the 4th group
                    tpVars = sig_feature(sig_feature(:,3) >= 391, 3);
                    [accuracy pvalue1 pvalue2] = computeLogisticRegressionPerformance(data(:,tpVars),label_data);
                    resultFDR4est(uu).val = [accuracy pvalue1 pvalue2];
                else
                    resultFDR4est(uu).val = [-2 -2 -2];
                end
                fprintf('FDR: %d %d %d %d %.3f\n', tnum1, tnum2, tnum3, tnum4, resultFDR4est(uu).val(1));
            end
            
            
            if doFDR2test
                % doing one-way fdr version2 -> naming as FDRlogistic for our convenience
                chem_shift_FDR = (1:P)';
                dataspec = (label_data)'; 
                WayNum = 1;
                q = tpcurlev;
                [sig_feature] = doReFDR(data', dataspec, q, chem_shift_FDR); 

                resultVarFDRlogistic( sig_feature(:,3),1) = resultVarFDRlogistic( sig_feature(:,3),1) + 1;

                tnum1 = sum( sig_feature(:,3) <= 30); 
                tnum2 = sum( (sig_feature(:,3) > 30) .* (sig_feature(:,3) <= 120));
                tnum3 = sum( (sig_feature(:,3) > 120) .* (sig_feature(:,3) <= 390));
                tnum4 = sum( (sig_feature(:,3) >= 391) );

                resultFDRlogistic1(uu,1) = tnum1; 
                resultFDRlogistic2(uu,1) = tnum2;
                resultFDRlogistic3(uu,1) = tnum3;
                resultFDRlogistic4(uu,1) = tnum4;
                if tnum4 > 0 
                    %checking out the detected variables in the 4th group
                    tpVars = sig_feature(sig_feature(:,3) >= 391, 3);
                    [accuracy pvalue1 pvalue2] = computeLogisticRegressionPerformance(data(:,tpVars),label_data);
                    resultFDRlogistic4est(uu).val = [accuracy pvalue1 pvalue2];
                else
                    resultFDRlogistic4est(uu).val = [-2 -2 -2];
                end
                fprintf('FDRlogistic: %d %d %d %d %.3f\n', tnum1, tnum2, tnum3, tnum4, resultFDRlogistic4est(uu).val(1));
            end
            
            % PCLS-OPLS
            %1st round of PCA
            if doPCLS2test
                idPCAll = [1 2];
                %idPCAll = [1 2 3];
                [Z,W,Pv,T] = dosc(data,label_data,1,1E-3);
                [XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] = plsregress(Z,label_data,1);

                score_data = [T XS];
                loading_data = [Pv XL]/1e5;


                drawfigclsf = false;
                drawfig = false;
                showSampleName = true;
                drawOneSigma = false;

                Params.score_data = score_data;
                Params.loading_data = loading_data;
                Params.idPCAll = idPCAll;
                Params.label_data = label_data;
                Params.lbl_value_all = unique(label_data)';
                Params.cutoff_md_quantile = tpcurlev; % Out of 64, 20/28 found.

                Params.drawfig = drawfig;
                Params.sample_name = sample_name;
                Params.strLabelAll = strLabelAll;
                Params.showSampleName = showSampleName;
                Params.drawOneSigma = drawOneSigma;
                Params.alpha = curalpha;
                Params.filterIndvLevel = 0.1;
                Params.dataXorig = data;
                Params.filterIndvMethod = 'LinearRegression';

                doPCLS_PCDrawing = false;
                if doPCLS_PCDrawing
                    Params.drawfig = true;
                    Params.showSampleName = false;
                    Params.highID = 1:30;

                    Params.redrawfig = true
                end

                Params.curLblnum = 1;
                [idx_inside1, Angles1, MDistSq1, cutoff_angle1, cutoff_dist1, outlier_id1, sampleInsidePval1, curLbl1, idx_filteredOutInfo1]= getVarIndexPCMatchNew(Params);

                Params.curLblnum = 2;
                [idx_inside2, Angles2, MDistSq2, cutoff_angle2, cutoff_dist2, outlier_id2, sampleInsidePval2, curLbl2, idx_filteredOutInfo2]= getVarIndexPCMatchNew(Params);

                doFilterOutAnalysis = true; %%2018/10/04
                if doFilterOutAnalysis
                    idx_filteredOut_union = union(idx_filteredOutInfo1.variables, idx_filteredOutInfo2.variables);
                    if length(idx_filteredOut_union) > 0
                        %resultOPCM_filtered = struct([]); %%2018/10/04
                        resultOPCM_filtered(uu).howMany = length(idx_filteredOut_union); %%2018/10/04                    
                        resultOPCM_filtered(uu).mean_pvalues = mean([idx_filteredOutInfo1.pvalues; idx_filteredOutInfo2.pvalues]);
                        resultOPCM_filtered(uu).std_pvalues = std([idx_filteredOutInfo1.pvalues; idx_filteredOutInfo2.pvalues]);
                        resultOPCM_filtered(uu).tnum1 = sum( idx_filteredOut_union <= 30 );
                        resultOPCM_filtered(uu).tnum2 = sum( (idx_filteredOut_union > 30) .* (idx_filteredOut_union<= 120) );
                        resultOPCM_filtered(uu).tnum3 = sum( (idx_filteredOut_union > 120) .* (idx_filteredOut_union<= 390) );
                        resultOPCM_filtered(uu).tnum4 = sum( (idx_filteredOut_union >= 391) );
                    else
                        resultOPCM_filtered(uu).howMany = 0; %%2018/10/04                    
                        resultOPCM_filtered(uu).mean_pvalues = -1;
                        resultOPCM_filtered(uu).std_pvalues = -1;
                        resultOPCM_filtered(uu).tnum1 = -1;
                        resultOPCM_filtered(uu).tnum2 = -1;
                        resultOPCM_filtered(uu).tnum3 = -1;
                        resultOPCM_filtered(uu).tnum4 = -1;

                    end
                end

                idx_union = union(idx_inside1, idx_inside2);
                resultVarOPCM( idx_union,1) = resultVarOPCM( idx_union,1) + 1;

                tnum1 = sum( idx_union <= 30 );
                tnum2 = sum( (idx_union > 30) .* (idx_union <= 120) );
                tnum3 = sum( (idx_union > 120) .* (idx_union <= 390) );
                tnum4 = sum( (idx_union >= 391) );

                if doPCLS_PCDrawing
                    Params.drawfig = true;
                    Params.showSampleName = false;
                    Params.drawOneSigma = false;
                    Params.highID = [];
                    Params.highIDmany = [];
                    Params.highIDmany(1).id = idx_union( idx_union <= 30 );
                    Params.highIDmany(2).id = idx_union( find( (idx_union > 30) .* (idx_union <= 120) ));
                    Params.highIDmany(3).id = idx_union( find( (idx_union > 120) .* (idx_union <= 390) ));

                    Params.redrawfig = true;
                    Params.curLblnum = 1;
                    Params.markSignificant = false;
                    Params.plotallloading = true;
                    [idx_inside1, Angles1, MDistSq1, cutoff_angle, cutoff_dist, outlier_id, sampleInsidePval]= getVarIndexPCMatchNew(Params);

                    Params.curLblnum = 2;
                    [idx_inside2, Angles2, MDistSq2]= getVarIndexPCMatchNew(Params);
                end

                resultOPCM1(uu,1) = tnum1;
                resultOPCM2(uu,1) = tnum2;
                resultOPCM3(uu,1) = tnum3;
                resultOPCM4(uu,1) = tnum4;

                if tnum4 > 0
                    %checking out the detected variables in the 4th group
                    tpVars = idx_union(idx_union >= 391);
                    [accuracy pvalue1 pvalue2] = computeLogisticRegressionPerformance(data(:,tpVars),label_data);
                    resultOPCM4est(uu).val = [accuracy pvalue1 pvalue2];
                    %[label_data svmclass]
                else
                    resultOPCM4est(uu).val = [-2 -2 -2];
                end

                fprintf('OPC: %d %d %d %d %.3f\n', tnum1, tnum2, tnum3, tnum4, resultOPCM4est(uu).val(1));
            end

            
            if doSTOCSY2test
                %doSTOCSY
                [Z,W,Pv,T] = dosc(data,label_data,1,1E-3);
                [XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] = plsregress(Z,label_data,1);
                %loading XL
                %pval_target = 0.05;
                pval_target = curalpha;
                tval = tinv(1-pval_target/2, N-2);
                r_target = sqrt(tval^2/(N-2)/(1+tval^2/(N-2)));
                corr_all = zeros(P,1);
                for mm=1:P
                    corr_all(mm,1) = abs( corr( data(:,mm), label_data ) );
                end
                xl_target = quantile( abs(XL(:,1)), 1 - tpcurlev);
                idSTOCSYfound = find( (corr_all > r_target) .* ( abs(XL(:,1)) > xl_target) );
                doShowSTOCSY = false;
                if doShowSTOCSY
                    figure(14); clf; hold on;
                    color_line(1:P, XL(:,1), corr_all);
                    colorbar;
                    xlabel('Variables');
                    ylabel('O-PLS coefficients');
                    ylim([-7 7]);
                    plot([40 40], [-8 8], '--g', 'linewidth', 3);
                    set(gca, 'XTick', [0 40 100 200 300 400]);
                    set(gca, 'XTickLabel', {'0','40','100','200','300','400'});
                end
                resultVarSTOCSY( idSTOCSYfound,1) = resultVarSTOCSY( idSTOCSYfound,1) + 1;


                tnum1 = sum( idSTOCSYfound <= 30);
                tnum2 = sum( (idSTOCSYfound > 30) .* (idSTOCSYfound <= 120));
                tnum3 = sum( (idSTOCSYfound > 120) .* (idSTOCSYfound <= 390));
                tnum4 = sum( (idSTOCSYfound >= 391) );


                resultSTOCSY1(uu,1) = tnum1;
                resultSTOCSY2(uu,1) = tnum2;
                resultSTOCSY3(uu,1) = tnum3;
                resultSTOCSY4(uu,1) = tnum4;
                if tnum4 > 0
                    %checking out the detected variables in the 4th group
                    tpVars = idSTOCSYfound (idSTOCSYfound >= 391);
                    [accuracy pvalue1 pvalue2] = computeLogisticRegressionPerformance(data(:,tpVars),label_data);
                    resultSTOCSY4est(uu).val = [accuracy pvalue1 pvalue2];
                    %[label_data svmclass]
                else
                    resultSTOCSY4est(uu).val = [-2 -2 -2];
                end
                fprintf('STOC: %d %d %d %d %.3f\n', tnum1, tnum2, tnum3, tnum4, resultSTOCSY4est(uu).val(1));
            end
        end
        
        if doFDR1test
            allres(rr).resultFDR1 = resultFDR1; 
            allres(rr).resultFDR2 = resultFDR2;
            allres(rr).resultFDR3 = resultFDR3;
            allres(rr).resultFDR4 = resultFDR4;
            allres(rr).resultFDR4est = resultFDR4est;
            allres(rr).resultVarFDR = resultVarFDR;
        end
        
        if doFDR2test
            allres(rr).resultFDRlogistic1 = resultFDRlogistic1; 
            allres(rr).resultFDRlogistic2 = resultFDRlogistic2;
            allres(rr).resultFDRlogistic3 = resultFDRlogistic3;
            allres(rr).resultFDRlogistic4 = resultFDRlogistic4;
            allres(rr).resultFDRlogistic4est = resultFDRlogistic4est;
            allres(rr).resultVarFDRlogistic = resultVarFDRlogistic;
        end
        
        if doPCLS2test
            allres(rr).resultOPCM1 = resultOPCM1;
            allres(rr).resultOPCM2 = resultOPCM2;
            allres(rr).resultOPCM3 = resultOPCM3;
            allres(rr).resultOPCM4 = resultOPCM4;
            allres(rr).resultOPCM4est = resultOPCM4est;
            allres(rr).resultVarOPCM = resultVarOPCM;
            allres(rr).resultOPCM_filtered = resultOPCM_filtered;
        end
        
        if doSTOCSY2test
            allres(rr).resultSTOCSY1 = resultSTOCSY1;
            allres(rr).resultSTOCSY2 = resultSTOCSY2;
            allres(rr).resultSTOCSY3 = resultSTOCSY3;
            allres(rr).resultSTOCSY4 = resultSTOCSY4;
            allres(rr).resultSTOCSY4est = resultSTOCSY4est;
            allres(rr).resultVarSTOCSY = resultVarSTOCSY;
        end
        
        allres(rr).tpcurlev = tpcurlev;
    end
    % save the result
    %tpcmd = sprintf('save(''allres_threelayers_plus_randomlayer_withFilteredOutVars_%.2f.mat'',''allres'',''alllevels'', ''noiselevel'', ''TotITER'');', noiselevel);
    %eval(tpcmd);
    %%% %save('allres_threelayers_realrandom.mat','allres','alllevels');
end %%for ww

