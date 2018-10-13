function[] = drawMultiLabels2D(score_data, label_data, strLabelAll, lbl_value_all, idAll)

if nargin < 4
    lbl_value_all = unique(label_data);
end

if nargin < 5
   idAll = [1 2]; 
end
idPC1 = idAll(1);
idPC2 = idAll(2);
msize = 8;
lw = 2;

rd_colors = floor(256*rand(length(lbl_value_all),3))/255;
rd_markers = '+o*.xsd^v><ph';
len_markers = length(rd_markers);
for pp=1:length(lbl_value_all)
    cur_lbl = lbl_value_all(pp);
    idLB_cur = find( label_data == cur_lbl);
    plot(score_data(idLB_cur(1),idPC1), score_data(idLB_cur(1),idPC2), rd_markers(mod(pp-1,len_markers)+1), 'Color', rd_colors(pp,:), 'MarkerSize', msize, 'LineWidth', lw);
end
legend(strLabelAll);
for pp=1:length(lbl_value_all)
    cur_lbl = lbl_value_all(pp);
    idLB_cur = find( label_data == cur_lbl);
    plot(score_data(idLB_cur,idPC1), score_data(idLB_cur,idPC2), rd_markers(mod(pp-1,len_markers)+1), 'Color', rd_colors(pp,:), 'MarkerSize', msize, 'LineWidth', lw);
end
