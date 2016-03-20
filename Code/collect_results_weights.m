clearvars -except feature_set method confusion_matrix file_name Weights Errors counter
close all; clc
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
        load(fullfile(settings.path2output, [fileName '.mat']))
        
        % Save to arraies:
        NN_mapping(reg_counter, split)  = results.NN_predicted;
        NN_baseline(reg_counter, split) = results.NN_baseline;
        
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
        
%% calc average and std across splits
NN_mapping_ave  = mean(NN_mapping, 2);
NN_baseline_ave = mean(NN_baseline, 2);

NN_mapping_std  = std(double(NN_mapping), 0, 2);
NN_baseline_std = std(double(NN_baseline), 0, 2);

[max_prec_model, IX_reg]   = max(NN_mapping_ave);
max_prec_model_data        = NN_mapping(IX_reg, :);
std_model                  = std(max_prec_model_data);
[max_prec_baseline, IX_bl] = max(NN_baseline_ave);
max_prec_baseline_data     = NN_baseline(IX_bl, :);
std_baseline               = std(max_prec_baseline_data);
[h, p]                     = ttest(max_prec_model_data, max_prec_baseline_data);
save(fullfile('Output', sprintf('Precision_%s_%s_%s', confusion_matrix, feature_set, method)), 'max_prec_model_data', 'max_prec_baseline_data', 'max_prec_model', 'max_prec_baseline', 'IX_reg', 'regularizers')

        
%% Show weights
% f2 = figure();
weights_ave = squeeze(mean(weights(1, :, :)));
weights_std = squeeze(std(weights(1, :, :)))/sqrt(22);

% MyBox = uicontrol('style','text');
% set(MyBox,'String','Error bars (SEM) are across splits of leave-one-out');
% xpos = 600; ypos = 500; xsize = 300; ysize = 50;
% set(MyBox,'Position',[xpos,ypos,xsize,ysize])
% set(MyBox,'FontSize', 12)


%%
% f4 = figure('visible', 'off');
% bar([NN_mapping_ave NN_baseline_ave])
% hold on
% errorbar([NN_mapping_ave NN_baseline_ave], [NN_mapping_std NN_baseline_std], '.')

%%
fprintf('Model Prec   : %1.4f +- %1.4f\nBaseline Prec: %1.4f +- %1.4f\np-value = %1.5f\n', ...
    max_prec_model, std_model, max_prec_baseline, std_baseline, p)

%%
% set(f1, 'units','normalized','outerposition',[0 0 1 1])
% set(f1, 'PaperPositionMode','auto') 
% set(f2, 'units','normalized','outerposition',[0 0 1 1])
% set(f2, 'PaperPositionMode','auto') 