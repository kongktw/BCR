function [sig_feature, cutpvalue] = getFDRSig(f_pv, q, isGraph)

if nargin < 2
    q = 0.05;
end
if nargin <3
    isGraph = false;
end

TotP = size(f_pv,1);
pv = f_pv(:,1);

%index=[1:TotP]';
% if AppendRT
%     f_pv=[pv chem_shift_FDR index];
% else 
%     %f_pv=[pv index];
%     f_pv=[pv pvCovS pvCovHist pvCovH coefCovH coef index];
% end
sort_pv=sortrows(f_pv);

for i=1:TotP
    %Change by Sky, 08/25/2010
    %ref(i,1)=q*i/length(dt_data);
    ref(i,1)=q*i/length(pv);
end


s_ind=find(sort_pv(:,1)<ref(:,1));
cut=max(s_ind);
sig_feature=sort_pv([1:cut],:);

if length(s_ind) == 0
    fprintf('No significant feature found \n');
else
    %fprintf('The number of significant features found is %d\n', length(s_ind));
    fprintf('The number of significant features found is %d\n', cut);
end

if (isGraph)
    figure(12); clf;
    plot(sort_pv(:,1), 'b-'); hold on;
    plot(ref(:,1), 'r:');
end

cutpvalue = sort_pv(cut,1);