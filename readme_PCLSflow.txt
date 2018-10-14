1. Synthetic Layers Data and Tests
(1) test_simulationTest1.m
 three layers + noise layer
(2) test_simulationTest2.m
 two layers + noise layer
(3) test_simulationTest3.m
 one layer + noise layer
(4) test_simulationTest3.m
 noise layer


2. getVarIndexPCMatchNew.m
 implementation of core PCLS logic

3. TG-WT metabolomics application
(1)  AE-WTvsTGmitochondria-males.xlsx
 3.2 TG-WT metabolomics data
(2) test_AE_WT.m
(3) individual flow
%(1) OPLS-DA
doOPCreadData.m
doOPCInitialCheckup.m
%(2) common
doFirstLabelMatch.m
doSecondLabelMatch.m
doSaveTwoLabelsMatch.m

%doMatchForGraph.m - to draw a figure with both significant-labeled loading data

dir *.csv

%For three label identities,
%open doThirdLabelMatch.m
%open doSaveThreeLabelsMatch.m

4. Issues
(1) needs to integrate individual flows with getVarIndexPCMatchNew.m