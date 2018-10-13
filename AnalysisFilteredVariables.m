%allres_threelayers_plus_randomlayer_withFilteredOutVars_-1.00.mat
%allres_threelayers_plus_randomlayer_withFilteredOutVars_0.10.mat
%allres_threelayers_plus_randomlayer_withFilteredOutVars_0.05.mat
%allres_threelayers_plus_randomlayer_withFilteredOutVars_0.03.mat

%allres_twolayers_plus_randomlayer_withFilteredOutVars_-1.00.mat
%allres_twolayers_plus_randomlayer_withFilteredOutVars_0.10.mat
%allres_twolayers_plus_randomlayer_withFilteredOutVars_0.05.mat
%allres_twolayers_plus_randomlayer_withFilteredOutVars_0.03.mat

%allres_onelayers_plus_randomlayer_withFilteredOutVars_-1.00.mat
%allres_onelayers_plus_randomlayer_withFilteredOutVars_0.10.mat
%allres_onelayers_plus_randomlayer_withFilteredOutVars_0.05.mat
%allres_onelayers_plus_randomlayer_withFilteredOutVars_0.03.mat

%allres_zerolayers_plus_randomlayer_withFilteredOutVars_0.10.mat
%allres_zerolayers_plus_randomlayer_withFilteredOutVars_0.05.mat
%allres_zerolayers_plus_randomlayer_withFilteredOutVars_0.03.mat
%allres_zerolayers_plus_randomlayer_withFilteredOutVars_-1.00.mat

%load allres_threelayers_plus_randomlayer_withFilteredOutVars_0.10.mat
%load allres_zerolayers_plus_randomlayer_withFilteredOutVars_0.10.mat
%load allres_onelayers_plus_randomlayer_withFilteredOutVars_0.05.mat
load allres_twolayers_plus_randomlayer_withFilteredOutVars_0.05.mat
length(allres)
allres(1).tpcurlev
allres(1).resultOPCM_filtered

%% howMany
tpVals = []
for rr=1:length(allres(1).resultOPCM_filtered)
tpVals = [tpVals; allres(1).resultOPCM_filtered(rr).howMany];
end
plot(tpVals);

sum(tpVals ~= 0)
sum(tpVals)

%% meanPValues - from y ~ variable
tpVals = []
for rr=1:length(allres(1).resultOPCM_filtered)
    tpVals = [tpVals; allres(1).resultOPCM_filtered(rr).mean_pvalues];
end
plot(tpVals);
mean( tpVals(tpVals ~= -1) )


%%
for aa=1:4 %layer structures
    fprintf("\n\n");
    for nn=1:4 %noise conditions
        if nn == 1
            switch aa
                case 1
                    load allres_threelayers_plus_randomlayer_withFilteredOutVars_-1.00.mat
                case 2
                    load allres_twolayers_plus_randomlayer_withFilteredOutVars_-1.00.mat
                case 3
                    load allres_onelayers_plus_randomlayer_withFilteredOutVars_-1.00.mat
                case 4
                    load allres_zerolayers_plus_randomlayer_withFilteredOutVars_-1.00.mat
            end
        elseif nn == 2
            switch aa
                case 1
                    load allres_threelayers_plus_randomlayer_withFilteredOutVars_0.03.mat
                case 2
                    load allres_twolayers_plus_randomlayer_withFilteredOutVars_0.03.mat
                case 3
                    load allres_onelayers_plus_randomlayer_withFilteredOutVars_0.03.mat
                case 4
                    load allres_zerolayers_plus_randomlayer_withFilteredOutVars_0.03.mat
            end
        elseif nn == 3            
            switch aa
                case 1
                    load allres_threelayers_plus_randomlayer_withFilteredOutVars_0.05.mat
                case 2
                    load allres_twolayers_plus_randomlayer_withFilteredOutVars_0.05.mat
                case 3
                    load allres_onelayers_plus_randomlayer_withFilteredOutVars_0.05.mat
                case 4
                    load allres_zerolayers_plus_randomlayer_withFilteredOutVars_0.05.mat
            end
        else
            switch aa
                case 1
                    load allres_threelayers_plus_randomlayer_withFilteredOutVars_0.10.mat
                case 2
                    load allres_twolayers_plus_randomlayer_withFilteredOutVars_0.10.mat
                case 3
                    load allres_onelayers_plus_randomlayer_withFilteredOutVars_0.10.mat
                case 4
                    load allres_zerolayers_plus_randomlayer_withFilteredOutVars_0.10.mat
            end
        end
        
        for level=1:7
            tpValsHowMany = [];
            tpValsMeanPvalues = [];
            tpValsStdPvalues = [];
            tnum1 = [];
            tnum2 = [];
            tnum3 = [];
            tnum4 = [];
            for rr=1:length(allres(level).resultOPCM_filtered)
                tpValsHowMany = [tpValsHowMany; allres(level).resultOPCM_filtered(rr).howMany];
                tpValsMeanPvalues = [tpValsMeanPvalues; allres(level).resultOPCM_filtered(rr).mean_pvalues];
                tpValsStdPvalues = [tpValsStdPvalues; allres(level).resultOPCM_filtered(rr).std_pvalues];
                if isfield( allres(level).resultOPCM_filtered(rr), 'tnum1')
                    tnum1 = [tnum1; allres(level).resultOPCM_filtered(rr).tnum1];
                    tnum1( tnum1 == -1 ) = 0;
                end
                if isfield( allres(level).resultOPCM_filtered(rr), 'tnum2')
                    tnum2 = [tnum2; allres(level).resultOPCM_filtered(rr).tnum2];
                    tnum2( tnum2 == -1 ) = 0;
                end
                if isfield( allres(level).resultOPCM_filtered(rr), 'tnum3')
                    tnum3 = [tnum3; allres(level).resultOPCM_filtered(rr).tnum3];
                    tnum3( tnum3 == -1 ) = 0;
                end
                if isfield( allres(level).resultOPCM_filtered(rr), 'tnum4')
                    tnum4 = [tnum4; allres(level).resultOPCM_filtered(rr).tnum4];
                    tnum4( tnum4 == -1 ) = 0;
                end
            end
            
            fprintf("%.3f   %.3f %.3f   %.3f %.3f %.3f %.3f \n", ...
            mean(tpValsHowMany), mean( tpValsMeanPvalues(tpValsMeanPvalues > 0 ) ), mean(tpValsStdPvalues(tpValsStdPvalues>0)), ...
            mean( tnum1 ), mean( tnum2 ) , mean( tnum3 ), mean( tnum4 ) );
        end
    end
    
end