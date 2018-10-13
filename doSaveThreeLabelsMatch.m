%% saving inside variables
delete('tp_idx_inside1.csv'); 
delete('tp_idx_inside2.csv');
delete('tp_idx_inside3.csv');
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

tpnewc = cell(size(idx_inside3,1)+1, 1);
tpnewc{1} = lbl_value_all(3);
for kk=1:size(idx_inside3,1)
    if iscell(variable_name(idx_inside3(kk)))
        tpnewc(1+kk) = variable_name(idx_inside3(kk));
    else
        tpnewc(1+kk) = num2cell(variable_name(idx_inside3(kk)));
    end
end

cellwrite('tp_idx_inside3.csv', tpnewc);