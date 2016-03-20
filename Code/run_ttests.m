clear all; close all; clc
addpath(genpath('../Code'))

%%
confusion_matrix = 'Luce';
feature_set = 'HALLE_CLEMENTS';
method = 'ls_metric_diag';
file_name = sprintf('analyses_%s_%s_%s.mat', confusion_matrix, feature_set, method);
load(fullfile('..', 'Output', file_name));

%%
mean_vals = mean(sqrt(squeeze(weights(RHO.IX_beg_reg, :, :))))';
[~, IX] = sort(mean_vals, 'descend');
std_vals = std(sqrt(squeeze(weights(RHO.IX_beg_reg, :, :))))';
tags = eval(sprintf('model.settings.featureNames_%s''', feature_set));

%% t_tests
[t_tests, t_tests_between, stats, stats_between] = ...
    t_tests_weights(sqrt(squeeze(weights(RHO.IX_beg_reg, :, :))));

%% Plots
% t_tests
f1 = figure;
imagesc(t_tests_between(:,:,2))
set(gca, 'Xtick', 1:length(tags), 'Xticklabel', tags)
set(gca, 'Ytick', 1:length(tags), 'Yticklabel', tags)
% t_tests
f3 = figure;
imagesc(t_tests_between(:,:,1))
set(gca, 'Xtick', 1:length(tags), 'Xticklabel', tags)
set(gca, 'Ytick', 1:length(tags), 'Yticklabel', tags)
% weights
f2 = figure;
set(f2, 'Color', [1 1 1])
barweb(mean_vals(IX), std_vals(IX), 0.8, tags(IX));
% ylim([0, 1.5*max(mean_vals(IX))])
ylim([0, 1.2])
rotateXLabels1(gca, 30)
ylabel('Feature weight', 'FontSize', 26)
fig_file_name = sprintf('%s_%s_%s.png', confusion_matrix, feature_set, method);
saveas(f2, fullfile('..', 'Figures', fig_file_name), 'png')