function [mean_weights, tags] = load_mean_weights(confusion_matrix, feature_set, method)
    file_name = sprintf('analyses_%s_%s_%s.mat', confusion_matrix, feature_set, method);
    load(fullfile('..', 'Output', file_name));
    mean_weights = mean(sqrt(squeeze(weights(RHO.IX_beg_reg, :, :))))';
    % [~, IX_1] = sort(mean_vals_1, 'descend');
    % std_vals = std(sqrt(squeeze(weights(RHO.IX_beg_reg, :, :))))';
    tags = eval(sprintf('model.settings.featureNames_%s''', feature_set));
end