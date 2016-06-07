function model = train_model(train_samples, train_labels, similarity_mat, distance_mat, settings, params)
fprintf('Train model\n')
% Train model - choose method
switch settings.method
    case {'ls_metric', 'ls_metric_diag', 'ls_similarity', 'ls_similarity_diag'}
        % Construct the least-squares problem - design matrix and distances vector:
        [A, B] = construct_least_squares(train_samples, train_labels, similarity_mat, distance_mat, settings);
%         A      = standarize_or_normalize(A, settings);
        % train model:
        model  = train_model_ls(settings, params, A, B);
    case 'oasis_similarity'
        similarity_mat = similarity_mat(train_labels, train_labels);
        model  = train_model_oasis(train_samples, similarity_mat, params);
    case 'oasis_similarity_diag'
        
    case 'oasis_metric'
        similarity_mat = similarity_mat(train_labels, train_labels);
        model  = train_model_oasis_metric(train_samples, similarity_mat, params);
    case 'oasis_metric_diag'
        similarity_mat = similarity_mat(train_labels, train_labels);
        model  = train_model_oasis_diag_metric(train_samples, similarity_mat, params);
end

model.settings = settings;
model.params   = params;

end

function A = standarize_or_normalize(A, settings)
%         A = bsxfun(@minus, A, mean(A));
        %% Standarize features:
        switch settings.preprocessing
            case 'standarize'
                % Center data:
                A = bsxfun(@minus, A, mean(A));
                % divide by std if not zero:
                A_temp = bsxfun(@rdivide, A, std(A));
                IX     = ~(isnan(A_temp)|isinf(A_temp));
                A(IX)  = A_temp(IX);
            case 'normalize'
                A = normc(A')';
        end

end