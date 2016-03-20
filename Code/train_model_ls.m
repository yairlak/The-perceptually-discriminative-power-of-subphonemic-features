function model = train_model_ls(settings, params, A, B)
%% Least-squares with L1-regularization or Ridge regression
fprintf('Train model - Lambda %d, split %i\n', params.lambda, params.split)
fprintf('Method: %s, Feature set: %s Confusion data: %s\n', ...
         settings.method, settings.feature_set, settings.confusion_matrix)
% Lasso:
switch settings.method
    case {'ls_metric_diag', 'ls_similarity_diag'}
        [W, status] = l1_ls_nonneg(A, B, params.lambda, 0.001, 'quiet', true);
    case {'ls_metric', 'ls_similarity'}
        [W, status] = l1_ls(A, B, params.lambda, 0.001, 'quiet', true);
end

if strcmp(status, 'Failed')
   params
   warning('Lasso solver failed')
end

switch settings.method
    case {'ls_metric_diag', 'ls_similarity_diag'}
        model.W     = diag(W); % Convert weights vector to a diagonal matrix
    case {'ls_metric', 'ls_similarity'}
        model.W     = reshape(W, sqrt(numel(W)), sqrt(numel(W)));
end

end



% fmincon(fun,x0,A,b,Aeq,beq,lb,ub);
% options      = optimoptions(@fmincon,'Algorithm','interior-point', 'Display', 'none');
% num_features = size(A, 2);
% [W,model.fval,model.exitflag,model.output,model.lambda] = ...
%     fmincon(@(W) myobj_l2(A, B, W, params.lambda, params.alpha), ...
%        rand(num_features,1),[],[],[],[],zeros(num_features,1),inf(num_features,1),[],options);
% 
% function L = myobj_l2(A, B, w, lambda, alpha)
%     resid = B - A*w;
%     Regularization = (0.5*(1-alpha) * norm(w)^2  + alpha * sum(abs(w)));
%     L = 0.5 * norm(resid)^2 + lambda * Regularization;
% end

%% Optimization part
% [W, status] = l1_ls_nonneg(A, B, params.lambda, 0.001);

% params.alpha = 1;
% [W, model.FitInfo] = lasso(A, B, 'Alpha', params.alpha);
