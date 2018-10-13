function [sig_feature] = doFDR_logistic(data, dataspec, q, chem_shift_FDR)


isGraph = false;
showMessage = false;

pv = zeros(length(data), 1);
for kk=1:length(data)   
    try
        m = data(kk,:);        
        %exclude zeros
        idxnz = find(m ~= 0);        
        [B,dev,stats] =mnrfit(data(kk,idxnz),dataspec(1,idxnz)');
        pv(kk,1) = stats.p(2);
    catch exception
        fprintf('here we go!\n');
    end
end

index=[1:length(data)]';
f_pv=[pv chem_shift_FDR index];
sort_pv=sortrows(f_pv);

for i=1:length(data)
    %Change by Sky, 08/25/2010
    %ref(i,1)=q*i/length(dt_data);
    ref(i,1)=q*i/length(data);
end

if (isGraph)
    figure(12); clf;
    plot(sort_pv(:,1), 'b-'); hold on;
    plot(ref(:,1), 'r:');
end

s_ind=find(sort_pv(:,1)<ref(:,1));
if showMessage
    if length(s_ind) == 0
        fprintf('No significant feature found \n');
    else
        fprintf('The number of significant features found is %d\n', length(s_ind));
    end
end
cut=max(s_ind);
sig_feature=sort_pv([1:cut],:);
