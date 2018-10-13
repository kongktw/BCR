function [sig_feature] = doReFDR(data, dataspec, q, chem_shift_FDR, WayNum)

WayNum = 1;
isGraph = false;
showMessage = false;

pv = zeros(length(data), 1);
for kk=1:length(data)
    m = data(kk,:);
    
    %include all numbers, even zeros
    %[p,table,stats,terms] = anovan(data(kk,:),{dataspec(1,:)' dataspec(2,:)'},...
    %'model', 'linear', 'display', 'off');
    %pv(kk,1) = p(2);
    
    %exclude zeros
    idxnz = find(m ~= 0);
    if WayNum == 1
        try
        [p,table,stats,terms] = anovan(data(kk,idxnz),{dataspec(1,idxnz)'},...
            'model', 'linear', 'display', 'off');
        catch exception 
            fprintf('here we go!\n');
        end
    end
    pv(kk,1) = p(end);
end

[h, crit_p, adj_p]=fdr_bh(pv,q,'pdep');

pv=adj_p;

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
