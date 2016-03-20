clearvars -except feature_set method confusion_matrix
settings.SWR = 0;

%%
switch confusion_matrix
    case 'Luce'
        settings.crossValidationKfold = 22;
        settings.features_subset = [1, 3, 5:11, 13];
    case 'NicelyMiller'
        settings.crossValidationKfold = 16;
        settings.features_subset = [1, 3, 5:11, 13];
    case 'ExpHebWhite'
        settings.features_subset = [1, 3:11, 13];
        settings.crossValidationKfold = 22;
        [~, settings] = load_params_settings(settings);
        if settings.without_J_tS_Z
            settings.crossValidationKfold = 19;
        end
    case {'SpeechErrorsMIT', 'SpeechErrorsStemberger'}
        settings.crossValidationKfold = 24;
end
[params, settings] = load_params_settings(settings);
settings.feature_set = feature_set; settings.method = method; settings.confusion_matrix = confusion_matrix;

lambdas = [];
switch method
    case {'ls_metric', 'ls_metric_diag', 'ls_similarity', 'ls_similarity_diag'}
        for order = settings.lambda_orders
            lambdas = [lambdas settings.lambda_values.* 10^order];
        end
%         for alpha = settings.alphas
            for lambda = lambdas
                for split = 1:settings.crossValidationKfold
%                     params.alpha  = alpha;
                    params.lambda = lambda;
                    params.split  = split;
                    fileName = get_filename(settings, params);
%                     if ~exist(fullfile('..', 'Output', [fileName, '.mat']), 'file')
                        main_phoneme_similarity
%                     end
                end
            end
%         end
        
    case {'oasis_similarity', 'oasis_metric', 'oasis_similarity_diag', 'oasis_metric_diag'}
        for aggress = settings.aggresses
            params.oasis_aggress = aggress;
            for split = 1:settings.crossValidationKfold
                fprintf('Current split %i\n', split)
                params.split  = split;
                fileName = get_filename(settings, params);
                %if ~exist(fullfile('..', 'Output', [fileName, '.mat']), 'file')
                    main_phoneme_similarity
                %end
            end
        end
    
end