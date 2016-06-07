function results = evaluate_model(model, train_samples, test_samples, train_labels, test_labels, similarity_mat, distance_mat, settings, params)

fprintf('\nEvaluate model\n')
model_b.W = eye(length(model.W)); % Baseline = identity mapping
% Nearest-neighbor precision:
results = [];
results.model    = eval_NN_rho_tau(model.W, train_samples, train_labels, test_samples, test_labels, distance_mat, settings, params, results);
results.baseline = eval_NN_rho_tau(model_b.W, train_samples, train_labels, test_samples, test_labels, distance_mat, settings, params, results);

end