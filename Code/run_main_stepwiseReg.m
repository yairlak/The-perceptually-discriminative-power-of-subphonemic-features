clear all; close all; clc

%% Choose data/features/method:
confusion_matrix = 'NicelyMiller';
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

%% Set params:
file_name_analysis = sprintf('Analyses_%s_%s_%s.mat', confusion_matrix, feature_set, method);
Analyses = load(fullfile('..', 'Output', file_name_analysis));
lambda           = Analyses.RHO.best_beg_reg;

%% CV
switch settings.confusion_matrix
    case 'Luce'
        settings.crossValidationKfold = 22;
    case 'NicelyMiller'
        settings.crossValidationKfold = 16;
    case 'ExpHebWhite'
        settings.crossValidationKfold = 22;
end

%% Run model
num_features = eval(sprintf('length(settings.featureNames_%s)', feature_set));
subset_size     = num_features - 1;
subsets = nchoosek(1:num_features, subset_size);
for counter_subset = 1:size(subsets, 1);
    fprintf('Current subset #%i from %i\n', counter_subset, size(subsets, 1))
    params.subset_features = subsets(counter_subset, :);
    for split = 1:settings.crossValidationKfold
        params.lambda = lambda;
        params.split  = split;
        fileName = get_filename(settings, params);
        fileName = ['SWR_' num2str(subset_size) '_' num2str(counter_subset) '_' fileName];
%         if ~exist(fullfile(settings.path2output, [fileName, '.mat']), 'file')
            evalc('main_phoneme_similarity');
%         end
    end
end