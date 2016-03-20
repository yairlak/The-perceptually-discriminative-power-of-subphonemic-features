function results = eval_NN_rho_tau(W, train_samples, train_labels, test_samples, test_labels, distance_mat, settings, params, results)
% This function expects leave-one-out, and calc for the left-out sample its
% distnace from all other samples (after the mapping W), and then sort
% them. If its nearest neighbor (NN) is also its NN according to the
% confusion matrix then the precision equals 1, else 0.

%% Calc distances from current sample and sort (After mapping):
num_train_samples = size(train_samples, 1);

switch settings.method
    case {'ls_metric', 'ls_metric_diag', 'oasis_metric', 'oasis_metric_diag'}  % Euclidian similarity distance
        Pi_Pj = (train_samples - ones(num_train_samples, 1) * test_samples);
        dist2others_predicted = diag(Pi_Pj * W * Pi_Pj');
    
    case {'oasis_similarity', 'ls_similarity', 'ls_similarity_diag'} % Dot product similarity distance
        % Minus the similarity
        dist2others_predicted = -train_samples * W * test_samples'; 
        
end

% distances from current left-out phoneme according to confusion matrix
dist2others_confMat = distance_mat(test_labels, train_labels)';

rand_vec = randperm(num_train_samples);
validation_set_IX = rand_vec(1:round(params.validation_test_sets_ration * num_train_samples/100));
test_set_IX = setdiff(1:num_train_samples, validation_set_IX, 'stable');

dist2others_confMat_validation = dist2others_confMat(validation_set_IX);
dist2others_predicted_validation = dist2others_predicted(validation_set_IX);
dist2others_confMat_test = dist2others_confMat(test_set_IX);
dist2others_predicted_test = dist2others_predicted(test_set_IX);

% Calc Kendall and Pearson rank correlations:
results.rho_validation = corr(dist2others_predicted_validation, dist2others_confMat_validation, 'type', 'Spearman');
results.rho_test       = corr(dist2others_predicted_test, dist2others_confMat_test, 'type', 'Spearman');
results.tau_validation = corr(dist2others_predicted_validation, dist2others_confMat_validation, 'type', 'Kendall');
results.tau_test       = corr(dist2others_predicted_test, dist2others_confMat_test, 'type', 'Kendall');


% Calc NN-precision
tmp_ranking      = [dist2others_predicted train_labels];
tmp_ranking      = sortrows(tmp_ranking, 1); % Ascending order
nearest_neighbor_predicted = tmp_ranking(1, 2);
clear tmp_ranking

tmp_ranking         = [dist2others_confMat train_labels];
tmp_ranking         = sortrows(tmp_ranking, 1); % Ascending order
nearest_neighbor_confMat = tmp_ranking(1:params.kNN, 2); % Within k NNs.
clear tmp_ranking

results.NN_precision = ismember(nearest_neighbor_predicted, nearest_neighbor_confMat);

end