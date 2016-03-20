function [t_tests, t_tests_between, stats, stats_between] = t_tests_weights(weights)
% 1st dimension is assumed to be the number of Cross Validations
% 2nd dimension is assumed to be the feaures
[~, num_features] = size(weights);
for f1 = 1:num_features
    [t_tests(f1, 1), t_tests(f1, 2), ~, stats(f1)] = ttest(weights(:, f1));
    for f2 = f1:num_features
       [t_tests_between(f1, f2, 1), t_tests_between(f1, f2, 2), ~, stats_between(f1, f2)] = ttest(weights(:, f1), weights (:, f2));
    end
end 

end