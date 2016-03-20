clear all; close all; clc

ls_dot_product_3_ave = 0.1818;
ls_dot_product_3_std = 0.3948;

ls_dot_product_diag_3_ave = 0.1364;
ls_dot_product_diag_3_std = 0.3513;

ls_dot_product_14_ave = 0.2727;
ls_dot_product_14_std = 0.4558;

ls_dot_product_diag_14_ave = 0.4545;
ls_dot_product_diag_14_std = 0.5096;

oasis_3_ave = 0.0909;
oasis_3_std = 0.2942;

oasis_14_ave = 0.3182;
oasis_14_std = 0.4767;

baseline_3_ave  = 0.1364;
baseline_3_std  = 0.3513;
baseline_14_ave = 0.1818;
baseline_14_std = 0.3948;

values(1, 1) = ls_dot_product_3_ave;
values(1, 2) = ls_dot_product_diag_3_ave;
values(1, 3) = oasis_3_ave;
values(1, 4) = baseline_3_ave;
values(2, 1) = ls_dot_product_14_ave;
values(2, 2) = ls_dot_product_diag_14_ave;
values(2, 3) = oasis_14_ave;
values(2, 4) = baseline_14_ave;

errors(1, 1) = ls_dot_product_3_std/sqrt(22);
errors(1, 2) = ls_dot_product_diag_3_std/sqrt(22);
errors(1, 3) = oasis_3_std/sqrt(22);
errors(1, 4) = baseline_3_std/sqrt(22);
errors(2, 1) = ls_dot_product_14_std/sqrt(22);
errors(2, 2) = ls_dot_product_diag_14_std/sqrt(22);
errors(2, 3) = oasis_14_std/sqrt(22);
errors(2, 4) = baseline_14_std/sqrt(22);

group_names{1} = 'Articulatory 3-features';
group_names{2} = 'Articulatory 14-features';

addpath('C:\Users\User\Documents\MATLAB\phonemeSimilarity\misc\barweb')
barweb(values, errors, [], group_names)
set(gcf, 'Color', [1 1 1])
ylabel('Nearest Neighbor precision', 'FontSize', 14)
legend({'Least-squares full', 'Least-squares diagonal', 'OASIS', 'Baseline'}, 'FontSize', 14, 'Location', 'NorthEastOutside')

MyBox = uicontrol('style','text');
set(MyBox,'String','Error bars (SEM) are across 22 splits of leave-one-out');

xpos = 300; ypos = 500; xsize = 300; ysize = 50;
set(MyBox,'Position',[xpos,ypos,xsize,ysize])
set(MyBox,'FontSize', 12)