
load(fullfile('..', 'Output', sprintf('Analyses_%s_%s_%s', confusion_matrix, feature_set, method)), 'NN', 'RHO_val', 'RHO_test', 'TAU_val', 'TAU_test', 'model', 'weights', 'regularizers', 'loss_iter', 'reg_counter')
%%
file_name = [confusion_matrix, '_', feature_set, '_', method];

%% plot vs. Lambda
plot_measure_vs_regularizer(NN, regularizers, feature_set, 'Nearest Neighbor Precision', file_name, true)
plot_measure_vs_regularizer(RHO_val, regularizers, feature_set, 'Spearman Correlation', file_name, true)
plot_measure_vs_regularizer(TAU_val, regularizers, feature_set, 'Kendall Ranking Correlation', file_name, true)
  
%% Plot weights of optimal regularizer according to each measure
plot_weights_of_optimal_regularizer(weights, NN, feature_set, model, 'Nearest Neighbor Precision', file_name, true)
plot_weights_of_optimal_regularizer(weights, RHO_val, feature_set, model, 'Spearman Correlation', file_name, true)
plot_weights_of_optimal_regularizer(weights, TAU_val, feature_set, model, 'Kendall Ranking Correlation', file_name, true)

%% Training loss for OASIS
if strcmp(method, 'oasis_similarity') || strcmp(method, 'oasis_metric')|| strcmp(method, 'oasis_metric_diag')
    plot_training_loss_vs_iter(regularizers, loss_iter, reg_counter, file_name, true)
end
