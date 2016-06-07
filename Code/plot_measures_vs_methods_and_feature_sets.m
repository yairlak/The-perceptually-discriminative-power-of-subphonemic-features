function t_tests = plot_measures_vs_methods_and_feature_sets(confusion_matrix, methods, features, measure, baselines, save_figure)
% Which field from measure
field_for_ave        = 'best_ave_value_beg_model';
% field_for_std        = 'std_beg_model';
field_for_all_values = 'best_beg_model_values';

%% collect measure values
values_ave = zeros(length(features), length(methods));
errors_SEM = zeros(length(features), length(methods));
for f = 1:length(features)
    feature_set = features{f};
    for m = 1:length(methods)
        method = methods{m};
        load(fullfile('..', 'Output', sprintf('Analyses_%s_%s_%s.mat', confusion_matrix, feature_set, method)))
        values(f, m, :)  = eval(sprintf('%s.%s', measure, field_for_all_values));
        values_ave(f, m) = eval(sprintf('%s.%s', measure, field_for_ave));
        errors_SEM(f, m) = std(eval(sprintf('%s.%s', measure, field_for_all_values)))/sqrt(length(eval(sprintf('%s.%s', measure, field_for_all_values))));
    end
    % Add baslines:
    values_ave(f, length(methods) + 1) = eval([sprintf('%s', measure), '.best_ave_value_baseline']);
    errors_SEM(f, length(methods) + 1) = std(eval([sprintf('%s', measure), '.best_baseline_values']))/sqrt(length(eval([sprintf('%s', measure), '.best_baseline_values'])));
    
    if baselines.frisch
        load(sprintf('../Output/Analyses_%s_frisch_similarity.mat', confusion_matrix))
        values(f, length(methods) + 2, :)  = eval(sprintf('%s1', measure));
        values_ave(:, length(methods) + 2) = mean(eval(sprintf('%s1', measure)));
        errors_SEM(:, length(methods) + 2) = std(eval(sprintf('%s1', measure)))/sqrt(length(eval(sprintf('%s1', measure))));
    end
    if baselines.PMV
        load(sprintf('../Output/Analyses_%s_PMV_similarity.mat', confusion_matrix))
        values(f, length(methods) + 3, :)  = eval(sprintf('%s1', measure));
        values_ave(:, length(methods) + 3) = mean(eval(sprintf('%s1', measure)));
        errors_SEM(:, length(methods) + 3) = std(eval(sprintf('%s1', measure)))/sqrt(length(eval(sprintf('%s1', measure))));
    end
    if baselines.PMVS
        load(sprintf('../Output/Analyses_%s_PMVS_similarity.mat', confusion_matrix))
        values(f, length(methods) + 4, :)  = eval(sprintf('%s1', measure));
        values_ave(:, length(methods) + 4) = mean(eval(sprintf('%s1', measure)));
        errors_SEM(:, length(methods) + 4) = std(eval(sprintf('%s1', measure)))/sqrt(length(eval(sprintf('%s1', measure))));
    end
end

%% calc t-tests
for f = 1:length(features)
    for m1 = 1:size(values, 2)
        for m2 = 1:size(values, 2)
            [t_tests(f, m1, m2, 1), t_tests(f, m1, m2, 2)] = ttest(values(f, m1, :), values(f, m2, :));
        end
    end
end


%% Plot summary
h = figure();
% group_names{1} = '3d-articulatory';
group_names{1} = 'Articulatory features';
group_names{2} = 'Phonolongical features';
barweb(values_ave, errors_SEM, [], group_names);
% rotateXLabels1(gca(), 10)

%% Cosmetics
set(h, 'Color', [1 1 1])
switch measure
    case 'NN'
        ylabel('Nearest Neighbor Precision', 'FontSize', 30)
    case 'RHO'
        ylabel('Spearman Correlation', 'FontSize', 30)
    case 'TAU'
        ylabel('Kendall''s Rank Correlation', 'FontSize', 30)
end

% Add legend
legend_text = {'LS', 'Diagonal-LS', 'OASIS', 'Diagonal-OASIS', 'Uniform weights'};
if baselines.frisch
    legend_text = [legend_text, {'Frisch'}];
end
if baselines.PMV
    legend_text = [legend_text, {'PMV'}];
end
if baselines.PMVS
    legend_text = [legend_text, {'PMVS'}];
end

set(h, 'units','normalized','outerposition',[0 0 1 1])
set(h, 'PaperPositionMode','auto') 

% legend_h = legend(legend_text, 'Position', [0.92,0.65,0.1,0.08]);
legend_h = legend(legend_text, 'Location', 'bestoutside');
set(legend_h, 'FontSize', 10);
legend boxoff;

%% Save figure
if save_figure
    file_name = ['compare_methods_', confusion_matrix, '_', measure];
    print(h, '-dpng', fullfile('..', 'Figures', file_name))
    saveas(h, fullfile('..', 'Figures', file_name), 'png')
    close(h)
end

end