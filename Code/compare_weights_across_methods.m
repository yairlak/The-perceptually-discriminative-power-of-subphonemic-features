clear all; close all; clc

%%
confusion_matrix = 'ExpHebWhite';
feature_set = 'ARTICULATORY_ORTHO';
measure = 'RHO';

method1 = 'ls_metric_diag';
method2 = 'ls_metric_diag';

%%
data1 = eval(sprintf('load(''../Output/Analyses_%s_%s_%s.mat'')', confusion_matrix, feature_set, method1));
data2 = eval(sprintf('load(''../Output/Analyses_%s_%s_%s.mat'')', confusion_matrix, feature_set, method2));

group_names = eval(sprintf('data1.model.settings.featureNames_%s', feature_set));
% switch feature_set
%     case 'ARTICULATORY'
%         group_names = data1.model.settings.featureNames_Articulatory3;
%     case 'ARTICULATORY_ORTHO'
%         group_names = data1.model.settings.featureNames_Articulatory14;
%     case 'FRISCH'
%         group_names = data1.model.settings.featureNames_Frisch;
%     case 'HALLE_CLEMENTS'
%         group_names = data1.model.settings.featureNames_Halle_Clements;
% end

%%
IX1_best   = eval(sprintf('data1.%s.IX_beg_reg', measure));
IX2_best   = eval(sprintf('data2.%s.IX_beg_reg', measure));
weights1   = mean(squeeze(data1.weights(IX1_best,:,:)))';
weights2   = mean(squeeze(data2.weights(IX2_best,:,:)))';
errorbars1 = std(squeeze(data1.weights(IX1_best,:,:)))';
errorbars2 = std(squeeze(data2.weights(IX2_best,:,:)))';

%%
C = corr(weights1, weights2, 'Type', 'Spearman');
%%
[weights1_sorted, IX1] = sort(weights1, 'descend');
[weights2_sorted, IX2] = sort(weights2, 'descend');
errorbars1_sorted      = errorbars1(IX1);
errorbars2_sorted      = errorbars2(IX2);
group_names1           = group_names(IX1);
group_names2           = group_names(IX2);

%% Figure: weights from both methods
figure; set(gcf, 'Color', [1 1 1])
subplot(1, 2, 1)
barweb(sqrt(weights1_sorted), errorbars1_sorted, [], group_names1);
rotateXLabels1(gca, 30);
title(method1)
subplot(1, 2, 2)
barweb(sqrt(weights2_sorted), errorbars2_sorted, [], group_names2);
rotateXLabels1(gca, 30);
title(method2)

%%
% [~, settings_temp] = load_params_settings();
% phonemes_temp      = data1.model.settings.phonemes;
% data1.model.settings.phonemes = settings_temp.phonemes; data1.model.settings.featureNames_ARTICULATORY_ORTHO = settings_temp.featureNames_ARTICULATORY_ORTHO; data1.model.settings.featureNames_ARTICULATORY = settings_temp.featureNames_ARTICULATORY; data1.model.settings.featureNames_HALLE_CLEMENTS = settings_temp.featureNames_HALLE_CLEMENTS;
% [samples, ~, ~, ~, ~] = load_samples_labels(data1.model.settings, data1.model.params);
% data1.model.settings.phonemes = phonemes_temp;
% samples_zeros            = sum(samples == 0);
% samples_ones             = sum(samples == 1);
% feature_sharing_balance  = samples_zeros;
% 
% fig3 = figure;
% barweb(weights1 * feature_sharing_balance, weights_std, 0.5, group_names);
% if ~strcmp(feature_set, 'ARTICULATORY')
%     rotateXLabels1(gca(), 30)
% end
% set(fig3, 'Color', [1 1 1])
% ylabel('Relative weight size', 'FontSize', 20)

group_names = eval(sprintf('data1.model.settings.featureNames_%s', feature_set));
IX1_best = 14;
weights1   = mean(squeeze(data1.weights(IX1_best,:,:)))';
errorbars1 = std(squeeze(data1.weights(IX1_best,:,:)))';
[weights1_sorted, IX1] = sort(weights1, 'descend');
errorbars1_sorted      = errorbars1(IX1);
group_names1           = group_names(IX1);
figure; set(gcf, 'Color', [1 1 1])
barweb(sqrt(weights1_sorted), errorbars1_sorted, [], group_names1);
rotateXLabels1(gca, 30);