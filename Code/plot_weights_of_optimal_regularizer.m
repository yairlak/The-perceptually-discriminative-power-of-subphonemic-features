function plot_weights_of_optimal_regularizer(weights, measure, feature_set, model, measure_name, file_name, save_figure)
%% Calc average weights ans their STDs across all splits
weights_ave = squeeze(mean(weights(measure.IX_beg_reg, :, :)));
num_values  = length(squeeze(std(weights(measure.IX_beg_reg, :, :))));
weights_std = squeeze(std(weights(measure.IX_beg_reg, :, :)))/sqrt(num_values);

% Feature names
group_names = eval(sprintf('model.settings.featureNames_%s', feature_set));
% switch feature_set
%     case 'ARTICULATORY'
%         group_names = model.settings.featureNames_Articulatory3;
%     case 'ARTICULATORY_ORTHO'
%         group_names = model.settings.featureNames_Articulatory14;
%     case 'FRISCH'
%         group_names = model.settings.featureNames_Frisch;
%     case 'HALLE_CLEMENTS'
%         group_names = model.settings.featureNames_Halle_Clements;
% end

% Sort weights in descending order
[weights_ave, IX] = sort(weights_ave, 'descend');
weights_std      = weights_std(IX);
group_names      = group_names(IX);

%% Plot to fig and cosmetics
fig1 = figure('visible', 'off');
barweb(weights_ave, weights_std, 0.8, group_names);
if ~strcmp(feature_set, 'ARTICULATORY')
    rotateXLabels1(gca(), 30)
end
set(fig1, 'Color', [1 1 1])
ylabel('Relative weight size', 'FontSize', 20)
ylim([0 max(weights_ave) * 1.5])
%%
fig2 = figure('visible', 'off');

%% Calc average weights ans their STDs across all splits
weights_ave = squeeze(mean(weights(measure.IX_end_reg, :, :)));
num_values = length(squeeze(std(weights(measure.IX_end_reg, :, :))));
weights_std = squeeze(std(weights(measure.IX_end_reg, :, :)))/sqrt(num_values);

%% Plot to fig and cosmetics
group_names = eval(sprintf('model.settings.featureNames_%s', feature_set));
% switch feature_set
%     case 'ARTICULATORY'
%         group_names = model.settings.featureNames_Articulatory3;
%     case 'ARTICULATORY_ORTHO'
%         group_names = model.settings.featureNames_Articulatory14;
%     case 'FRISCH'
%         group_names = model.settings.featureNames_Frisch;
%     case 'HALLE_CLEMENTS'
%         group_names = model.settings.featureNames_Halle_Clements;
% end
% 
% Sort weights in descending order
[weights_ave, IX] = sort(weights_ave, 'descend');
weights_std      = weights_std(IX);
group_names      = group_names(IX);

barweb(weights_ave, weights_std, 0.5, group_names);
if ~strcmp(feature_set, 'ARTICULATORY')
    rotateXLabels1(gca(), 30)
end
set(fig2, 'Color', [1 1 1])
ylabel('Relative weight size', 'FontSize', 20)
% title(['End ' measure_name])

%% Save figure
if save_figure
    saveas(fig1, fullfile('..', 'Figures', [file_name, '_', measure_name, '_weights']), 'png') 
    saveas(fig2, fullfile('..', 'Figures', [file_name, '_', measure_name, '_weights_end']), 'png') 
%     saveas(fig3, fullfile('Figures', [file_name, '_', measure_name, '_weights_balanced']), 'png') 
end

end