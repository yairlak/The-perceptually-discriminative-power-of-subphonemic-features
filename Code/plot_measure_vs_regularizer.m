function plot_measure_vs_regularizer(measure, regularizers, feature_set, measure_name, file_name, save_figure)
fig = figure('visible', 'off');

%% Plot
semilogx(regularizers, measure.mapping_ave, 'Color', 'b', 'LineWidth', 2)
hold on
num_values = length(measure.mapping_ave);
errorbar(regularizers, measure.mapping_ave, measure.mapping_std/sqrt(num_values), 'Color', 'b')
semilogx(regularizers, measure.baseline_ave, 'Color', 'r', 'LineWidth', 2)
hold off

%% Cosmetics
xlabel('Regularizer', 'FontSize', 14)
ylabel(measure_name, 'FontSize', 14)
if strcmp(feature_set, 'ARTICULATORY')
    legend_str = '3-features';
else
    legend_str = '14-features';
end
legend({[legend_str 'LS'], 'Baseline'}, 'FontSize', 14, 'Location', 'NorthEastOutside')
set(gcf, 'Color', [1 1 1])   

%% Save figure
if save_figure
    saveas(fig, fullfile('..', 'Figures', [file_name, '_', measure_name, '_reg']), 'png')
end

end