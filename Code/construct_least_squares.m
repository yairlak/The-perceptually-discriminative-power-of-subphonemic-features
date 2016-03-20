function [A, B] = construct_least_squares(samples, labels, similarity_mat, distance_mat, settings)
% ls: A * w = B,
% Build the distance vector and the design matrix (in which each sample is the difference between pair of phonemes).
switch settings.method
    case 'ls_metric_diag'
        % Design Matrix:
        fprintf('Constructing the Design Matrix\n')
        num_samples  = size(samples, 1);
        pair_indices = nchoosek(1:num_samples, 2);

        phonemes_1 = samples(pair_indices(:, 1), :);
        phonemes_2 = samples(pair_indices(:, 2), :);

        A = (phonemes_1 - phonemes_2) .^ 2;

        % Distance Vector:
        fprintf('Constructing the Distance Vector\n')

        row_ind = labels(pair_indices(:, 1));
        col_ind = labels(pair_indices(:, 2));
   
        IX = sub2ind(size(distance_mat), row_ind, col_ind);
        B  = distance_mat(IX);

        B = B .^ 2;  % (Fi - Fj)'*W'*W*(Fi - Fj) = DistVec ^ 2
        
  case 'ls_metric'
        % Design Matrix:
        fprintf('Constructing the Design Matrix\n')
        num_samples  = size(samples, 1);
        pair_indices = nchoosek(1:num_samples, 2);

        phonemes_1 = samples(pair_indices(:, 1), :);
        phonemes_2 = samples(pair_indices(:, 2), :);
        
        delta = phonemes_1 - phonemes_2;
        
        num_features = size(samples, 2);
        delta_1 = kron(delta, ones(1, num_features));
        delta_2 = repmat(delta, 1, num_features);
        
        A = delta_1 .* delta_2;

        % Distance Vector:
        fprintf('Constructing the Distance Vector\n')

        row_ind = labels(pair_indices(:, 1));
        col_ind = labels(pair_indices(:, 2));
   
        IX = sub2ind(size(distance_mat), row_ind, col_ind);
        B  = distance_mat(IX);

        B = B .^ 2;
    case 'ls_similarity'
        % Design Matrix:
        fprintf('Constructing the Design Matrix\n')
        num_samples  = size(samples, 1);
        pair_indices = nchoosek(1:num_samples, 2);

        phonemes_1 = samples(pair_indices(:, 1), :);
        phonemes_2 = samples(pair_indices(:, 2), :);
        
        num_features = size(samples, 2);
        phonemes_1 = kron(phonemes_1, ones(1, num_features));
        phonemes_2 = repmat(phonemes_2, 1, num_features);
        
        A = phonemes_1 .* phonemes_2;

        % Distance Vector:
        fprintf('Constructing the Distance Vector\n')

        row_ind = labels(pair_indices(:, 1));
        col_ind = labels(pair_indices(:, 2));
   
        IX = sub2ind(size(similarity_mat), row_ind, col_ind);
        B  = similarity_mat(IX);
        
        B = B .^ 2;
        
     case 'ls_similarity_diag'
        % Design Matrix:
        fprintf('Constructing the Design Matrix\n')
        num_samples  = size(samples, 1);
        pair_indices = nchoosek(1:num_samples, 2);

        phonemes_1 = samples(pair_indices(:, 1), :);
        phonemes_2 = samples(pair_indices(:, 2), :);
        
        A = phonemes_1 .* phonemes_2;

        % Distance Vector:
        fprintf('Constructing the Distance Vector\n')

        row_ind = labels(pair_indices(:, 1));
        col_ind = labels(pair_indices(:, 2));
   
        IX = sub2ind(size(similarity_mat), row_ind, col_ind);
        B  = similarity_mat(IX);
        
        B = B .^ 2;
end

%% Omit NaN values from the distance vector and design matrix. In the Hebrew experiment, NaN represents that the comparison wasn't done.
if settings.omit_NaNs
    nan_ix = isnan(B);
    if any(nan_ix)
        A = A(~nan_ix, :);
        B = B(~nan_ix);
    end
end
end