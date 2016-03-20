clearvars -except feature_set method confusion_matrix file_name
close all;
%%
lambda_counter = 1; alpha_counter = 1;
switch confusion_matrix
    case 'Luce'
        settings.crossValidationKfold = 22;
        settings.features_subset = [1, 3, 5:11, 13];
    case 'NicelyMiller'
        settings.crossValidationKfold = 16;
        settings.features_subset = [1, 3, 5:11, 13];
    case 'ExpHebWhite'
        settings.crossValidationKfold = 22;
        settings.features_subset = [1, 3:11, 13];
        [~, settings] = load_params_settings(settings);
        if settings.without_J_tS_Z
            settings.crossValidationKfold = 19;
        end
    case {'SpeechErrorsMIT', 'SpeechErrorsStemberger'}
           settings.crossValidationKfold = 24;
end
[params, settings] = load_params_settings(settings);

switch method
    case {'ls_metric', 'ls_metric_diag', 'ls_similarity', 'ls_similarity_diag'}
        regularizers = [];
        for order = settings.lambda_orders
            regularizers = [regularizers settings.lambda_values.* 10 ^ order];
        end
    case {'oasis_similarity', 'oasis_metric', 'oasis_metric_diag', 'oasis_similarity_diag'}
        regularizers = settings.aggresses;
end

reg_counter = 1; loss_iter = [];
for reg = regularizers
    for split = 1:settings.crossValidationKfold
        % Load file:
        switch method
            case {'ls_metric', 'ls_metric_diag', 'ls_similarity', 'ls_similarity_diag'}
                params.lambda = reg;
            case {'oasis_similarity', 'oasis_metric', 'oasis_metric_diag'}
                params.oasis_aggress = reg;
        end
        params.split          = split;
        settings.method       = method;
        settings.feature_set  = feature_set;
        settings.confusion_matrix    = confusion_matrix;
        [params, settings] = load_params_settings(settings, params);
        fileName = get_filename(settings, params);
        load(fullfile('../Output', [fileName '.mat']))
        
        % Save to arraies:
        NN_mapping(reg_counter, split)   = results.model.NN_precision;
        NN_baseline(reg_counter, split)  = results.baseline.NN_precision;
        RHO_mapping(reg_counter, split)  = results.model.rho;
        RHO_baseline(reg_counter, split) = results.baseline.rho;
        TAU_mapping(reg_counter, split)  = results.model.tau;
        TAU_baseline(reg_counter, split) = results.baseline.tau;
        
        
        weights(reg_counter, split, :)   = diag(model.W);
        if strcmp(method, 'ls_similarity') || strcmp(method, 'oasis_similarity') || strcmp(method, 'ls_metric') || strcmp(method, 'oasis_metric')
            N = length(model.W);
            for i = 1:N
               vec = zeros(N, 1);
               vec(i) = 1;
               weights(reg_counter, split, i) = vec' * model.W * vec;
            end
        end
        
        if strcmp(method, 'oasis_similarity')||strcmp(method, 'oasis_metric')||strcmp(method, 'oasis_metric_diag')
            loss_iter(reg_counter, split, :) = model.loss;
        end
        
    end
    reg_counter = reg_counter + 1;
end
        
%% calc average and std across splits for NN-precision
NN  = analyze_collected_results(NN_mapping, NN_baseline, regularizers);
RHO = analyze_collected_results(RHO_mapping, RHO_baseline, regularizers);
TAU = analyze_collected_results(TAU_mapping, TAU_baseline, regularizers);
save(fullfile('..', 'Output', sprintf('Analyses_%s_%s_%s', confusion_matrix, feature_set, method)), 'NN', 'RHO', 'TAU', 'model', 'weights', 'regularizers', 'loss_iter', 'reg_counter')
