clear all; close all; clc
addpath('l1_ls_matlab', 'common functions', '../Data')

%% Choose data/features/method:
confusion_matrix = 'Luce';
feature_set      = 'HALLE_CLEMENTS';
method           = 'ls_metric_diag';
settings.confusion_matrix = confusion_matrix;
settings.feature_set      = feature_set;
settings.method           = method;

%%
switch confusion_matrix
    case 'Luce'
        settings.features_subset = [1, 3, 5:11, 13];
    case 'NicelyMiller'
        settings.features_subset = [1, 3, 5:11, 13];
    case 'ExpHebWhite'
        settings.features_subset = [1, 3:11, 13];
end        
[params, settings] = load_params_settings(settings);
settings.SWR       = true;

%% Load full-feature model
file_name = sprintf('Analyses_%s_%s_%s', confusion_matrix, feature_set, method);
full_model = load(fullfile('..', 'Output', file_name), 'NN', 'RHO', 'TAU', 'model', 'weights');
weights_full_model = squeeze(mean(full_model.weights(full_model.RHO.IX_beg_reg, :, :), 2));
[~, IX_full] = sort(weights_full_model, 'descend');

%% Set params:
lambda        = full_model.RHO.best_beg_reg;
params.lambda = lambda;

%% CV
switch confusion_matrix
    case 'Luce'
        settings.crossValidationKfold = 22;
    case 'NicelyMiller'
        settings.crossValidationKfold = 16;
    case 'ExpHebWhite'
        settings.crossValidationKfold = 22;
end
 
%%
num_features = eval(sprintf('length(settings.featureNames_%s)', feature_set));
subset_size  = num_features - 1;
subsets      = nchoosek(1:num_features, subset_size);
regularizers = lambda;

%%
for counter_subset = 1:size(subsets, 1);
    curr_feature = setdiff(1:(subset_size+1), subsets(counter_subset, :));
    where_not_curr_feature = (IX_full == curr_feature);
    IX_full_without_curr_feature = IX_full(~where_not_curr_feature);
    fprintf('Current subset #%i from %i\n', counter_subset, size(subsets, 1))
    for split = 1:settings.crossValidationKfold
        params.split          = split;
        settings.method       = method;
        settings.feature_set  = feature_set;
        settings.confusion_matrix    = confusion_matrix;
        [params, settings] = load_params_settings(settings, params);
        fileName = get_filename(settings, params);
        fileName = ['SWR_' num2str(subset_size) '_' num2str(counter_subset) '_' fileName];
        load(fullfile('..', 'Output', [fileName '.mat']))

        % Save to arraies:
        measure_model(split)    = results.model.rho;
        measure_baseline(split) = results.baseline.rho;
        weights(split, :)  = diag(model.W);

    end

    %% calc average and std across splits
    measure_mapping_ave  = mean(measure_model);
    measure_baseline_ave = mean(measure_baseline);

    measure_mapping_std  = std(double(measure_model), 0, 2);
    measure_baseline_std = std(double(measure_baseline), 0, 2);
    
    [phat, pci] = binofit(sum(measure_model, 2), length(measure_model));
    [h, p]                     = ttest(measure_model, measure_baseline);
%     % save(fullfile('Output', sprintf('Precision_%s_%s_%s', confusion_matrix, feature_set, method)), 'max_prec_model_data', 'max_prec_baseline_data', 'max_prec_model', 'max_prec_baseline', 'IX_reg', 'regularizers')

    %% Show weights
    weights_ave = squeeze(mean(weights));
    weights_std = squeeze(std(weights)/sqrt(22));
    switch feature_set
        case 'ARTICULATORY'
            group_names = model.settings.featureNames_Articulatory3;
        case 'ARTICULATORY_ORTHO'
            group_names = model.settings.featureNames_ARTICULATORY_ORTHO;
        case 'FRISCH'
            group_names = model.settings.featureNames_Frisch;
        case 'HALLE_CLEMENTS'
            group_names = model.settings.featureNames_HALLE_CLEMENTS;
    end
    
    % Sort
    [weights_ave, IX] = sort(weights_ave, 'descend');
    weights_std       = weights_std(IX);
    group_names       = group_names(IX);
    
    corr_two_orders(counter_subset) = corr(IX', IX_full_without_curr_feature, 'type', 'spearman');
    % Plot and save
    file_name = ['SWR_' num2str(subset_size) '_' num2str(counter_subset) '_' confusion_matrix, '_', feature_set, '_', method];
%     plot_weights_of_optimal_regularizer(weights, 'RHO', feature_set, model, 'Nearest Neighbor Precision', file_name, true)
    f2 = figure();
    barweb(weights_ave', weights_std', 0.5, group_names);
    set(gcf, 'Color', [1 1 1])
    ylabel('Relative weight size', 'FontSize', 20)
    set(f2, 'units','normalized','outerposition',[0 0 1 1])
    set(f2, 'PaperPositionMode','auto') 
%     pause(10)
    close(f2)
       
    %%
    prec_SWR(counter_subset, 1) = measure_mapping_ave;
    prec_SWR(counter_subset, 2) = measure_mapping_std/sqrt(22);
    prec_SWR(counter_subset, 3) = measure_baseline_ave;
    prec_SWR(counter_subset, 4) = measure_baseline_std/sqrt(22);
    
    %%
    clear measure_mapping measure_baseline measure_mapping_ave measure_mapping_std measure_baseline_ave measure_baseline_std
end

f5 = figure();
full_model_prediction = full_model.RHO.best_ave_value_beg_model;
group_names = eval(sprintf('settings.featureNames_%s', feature_set));
% group_names = flipud(eval(sprintf('settings.featureNames_%s', feature_set)));
[prec_sorted, IX_prec] = sort(flipud(prec_SWR(:,1)), 'ascend');
prec_std_sorted        = flipud(prec_SWR(:, 2));
prec_std_sorted        = prec_std_sorted(IX_prec);
group_names_sorted     = group_names(IX_prec);

barweb(prec_sorted-full_model_prediction, prec_std_sorted, [], group_names_sorted);%, 'LineWidth', 2)
rotateXLabels1(gca, 30);
% set(gca, 'xtick', 1:14, 'xticklabel', flipud(settings.featureNames_Articulatory14))
set(f5, 'Color', [1 1 1])
xlabel('Left-out feature', 'FontSize', 20)
ylabel('Prediction difference', 'FontSize', 20)
set(f5, 'units','normalized','outerposition',[0 0 1 1])
set(f5, 'PaperPositionMode','auto') 
saveas(f5, fullfile('..', 'Figures', sprintf('SWR_%s_%s_%s', confusion_matrix, feature_set, method)), 'jpg')


[corr_sorted, IX_corr] = sort(flipud(corr_two_orders'), 'ascend');
group_names = eval(sprintf('settings.featureNames_%s', feature_set));
group_names = flipud(group_names);
group_names_sorted = group_names(IX_corr);
f6 = figure();
barweb(corr_sorted, zeros(size(corr_sorted)), [], group_names_sorted);
rotateXLabels1(gca, 30);
set(gcf, 'Color', [1 1 1])
ylabel('Spearman Correlation', 'FontSize', 20)
set(f6, 'units','normalized','outerposition',[0 0 1 1])
set(f6, 'PaperPositionMode','auto')
saveas(f6, fullfile('..', 'Figures', sprintf('SWR_corr_%s_%s_%s', confusion_matrix, feature_set, method)), 'jpg')

%   
% hold on
% errorbar(prec_SWR(:,3), prec_SWR(:,4), 'r')