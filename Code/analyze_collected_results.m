function measures = analyze_collected_results(mapping, baseline, regularizers);
%%
% Average measure across splits (for all regularization sizes)
measures.mapping_ave  = mean(mapping, 2);
measures.baseline_ave = mean(baseline, 2);
% Calc STD across splits
measures.mapping_std  = std(double(mapping), 0, 2);
measures.baseline_std = std(double(baseline), 0, 2);

%% If the optimal value is for several reg size - choose either from the begining or from end
% Find optimal regularization size (from begining)
[measures.best_ave_value_beg_model, measures.IX_beg_reg] = max(measures.mapping_ave);
measures.best_beg_reg = regularizers(measures.IX_beg_reg);
% Find optimal regularization size (from end). So the strongest sparsity.
[measures.best_ave_value_end_model, measures.IX_end_reg]   = max(fliplr(measures.mapping_ave'));
measures.IX_end_reg = length(measures.mapping_ave) - measures.IX_end_reg + 1; 

%% Extract results for optimal regularizer
measures.best_beg_model_values = mapping(measures.IX_beg_reg, :);
measures.std_beg_model         = std(measures.best_beg_model_values);
measures.best_end_model_values = mapping(measures.IX_end_reg, :);
measures.std_end_model         = std(measures.best_end_model_values);

%% Basline
[measures.best_ave_value_baseline, measures.IX_bl] = max(measures.baseline_ave);
measures.best_baseline_values            = baseline(measures.IX_bl, :);
measures.std_baseline                    = std(measures.best_baseline_values);

%% Test significance Model vs. Baseline
[measures.h_beg, measures.p_beg]                  = ttest(measures.best_beg_model_values, measures.best_baseline_values);
[measures.h_end, measures.p_end]                  = ttest(measures.best_end_model_values, measures.best_baseline_values);

end