clearvars -except feature_set method confusion_matrix file_name
close all;
[params, settings] = load_params_settings;

%%
lambda_counter = 1; alpha_counter = 1;
switch confusion_matrix
    case 'Luce'
        settings.crossValidationKfold = 22;
    case 'NicelyMiller'
        settings.crossValidationKfold = 16;
    case 'ExpHebWhite'
        settings.crossValidationKfold = 22;
end

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
        load(fullfile('..', 'Output', [fileName '.mat']))
        
        % Save to arraies:
        NN_mapping(reg_counter, split)   = results.model.NN_precision;
        NN_baseline(reg_counter, split)  = results.baseline.NN_precision;
        RHO_mapping_val(reg_counter, split)  = results.model.rho_validation;
        RHO_baseline_val(reg_counter, split) = results.baseline.rho_validation;
        TAU_mapping_val(reg_counter, split)  = results.model.tau_validation;
        TAU_baseline_val(reg_counter, split) = results.baseline.tau_validation;
        RHO_mapping_test(reg_counter, split)  = results.model.rho_test;
        RHO_baseline_test(reg_counter, split) = results.baseline.rho_test;
        TAU_mapping_test(reg_counter, split)  = results.model.tau_test;
        TAU_baseline_test(reg_counter, split) = results.baseline.tau_test;
        
        
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
RHO_val = analyze_collected_results(RHO_mapping_val, RHO_baseline_val, regularizers);
TAU_val = analyze_collected_results(TAU_mapping_val, TAU_baseline_val, regularizers);
RHO_test = analyze_collected_results(RHO_mapping_test, RHO_baseline_test, regularizers);
TAU_test = analyze_collected_results(TAU_mapping_test, TAU_baseline_test, regularizers);
save(fullfile('..', 'Output', sprintf('Analyses_%s_%s_%s', confusion_matrix, feature_set, method)), 'NN', 'RHO_val', 'RHO_test', 'TAU_val', 'TAU_test', 'model', 'weights', 'regularizers', 'loss_iter', 'reg_counter')
