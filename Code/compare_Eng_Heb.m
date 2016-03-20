clear all; close all; clc
addpath(genpath('../Code'))
method = 'ls_metric_diag';
f1 = figure;
hold on

%% Heb vs. Luce; Phonological features
confusion_matrix_1 = 'ExpHebWhite';
confusion_matrix_2 = 'Luce';
feature_set = 'ARTICULATORY_ORTHO';

[mean_weights_1, tags_1] = load_mean_weights(confusion_matrix_1, feature_set, method);
[mean_weights_2, tags_2] = load_mean_weights(confusion_matrix_2, feature_set, method);
dataset_1 = mean_weights_1/sum(mean_weights_1);
dataset_2 = mean_weights_2/sum(mean_weights_2); 
[dataset_1, dataset_2, tags_1, tags_2] = ...
    set_both_sets_same_size(dataset_1, dataset_2, tags_1, tags_2);
tags_1 = change_labels(tags_1);
add2scatter(dataset_1, dataset_2, tags_1, 'b', 14)

%% Heb vs. Luce; Phonological features
confusion_matrix_1 = 'ExpHebWhite';
confusion_matrix_2 = 'Luce';
feature_set = 'HALLE_CLEMENTS';

[mean_weights_1, tags_1] = load_mean_weights(confusion_matrix_1, feature_set, method);
[mean_weights_2, tags_2] = load_mean_weights(confusion_matrix_2, feature_set, method);
dataset_1 = mean_weights_1/sum(mean_weights_1);
dataset_2 = mean_weights_2/sum(mean_weights_2); 
[dataset_1, dataset_2, tags_1, tags_2] = ...
    set_both_sets_same_size(dataset_1, dataset_2, tags_1, tags_2);
tags_1 = change_labels(tags_1);
add2scatter(dataset_1, dataset_2, tags_1, 'r', 14)

%% Heb vs. Luce; Phonological features
% confusion_matrix_1 = 'ExpHebWhite';
% confusion_matrix_2 = 'NicelyMiller';
% feature_set = 'ARTICULATORY_ORTHO';
% 
% [mean_weights_1, tags_1] = load_mean_weights(confusion_matrix_1, feature_set, method);
% [mean_weights_2, tags_2] = load_mean_weights(confusion_matrix_2, feature_set, method);
% dataset_1 = mean_weights_1/sum(mean_weights_1);
% dataset_2 = mean_weights_2/sum(mean_weights_2); 
% [dataset_1, dataset_2, tags_1, tags_2] = ...
%     set_both_sets_same_size(dataset_1, dataset_2, tags_1, tags_2);
% add2scatter(dataset_1, dataset_2, tags_1, 'r', 12)
% 
% %% Heb vs. Luce; Phonological features
% confusion_matrix_1 = 'ExpHebWhite';
% confusion_matrix_2 = 'NicelyMiller';
% feature_set = 'HALLE_CLEMENTS';
% 
% [mean_weights_1, tags_1] = load_mean_weights(confusion_matrix_1, feature_set, method);
% [mean_weights_2, tags_2] = load_mean_weights(confusion_matrix_2, feature_set, method);
% dataset_1 = mean_weights_1/sum(mean_weights_1);
% dataset_2 = mean_weights_2/sum(mean_weights_2); 
% [dataset_1, dataset_2, tags_1, tags_2] = ...
%     set_both_sets_same_size(dataset_1, dataset_2, tags_1, tags_2);
% add2scatter(dataset_1, dataset_2, tags_1, 'r', 12)

%% Cosmetics

set(f1, 'Color', [1 1 1])
xlabel('Relative weight (Hebrew)', 'FontSize', 18)
ylabel('Relative weight (English)', 'FontSize', 18)
axis equal
axis([0 max([dataset_1; dataset_2]) 0 max([dataset_1; dataset_2])]);
set(gca,'fontsize',18)

h_ref = refline(1, 0);
set(h_ref, 'Color', 'k', 'LineWidth', 2)
saveas(f1, sprintf('../Figures/compare_%s_Heb.png', confusion_matrix_2), 'png')