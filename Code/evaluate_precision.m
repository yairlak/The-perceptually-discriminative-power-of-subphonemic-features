 function [mean_avg_precision, precision_at_all_ks, auc] = evaluate_precision(samples, labels, W)
    % Evaluate mean avg precision,  precision_at_all_ks and AUC with a given similarity matrix
    num_samples  = size(samples, 1);
%     auc_score_per_example = zeros(size(samples,1),1);
    mean_avg_precision = [];
    auc = [];
    
    pairs      = nchoosek(1:num_samples, 2);
    results    = zeros(num_samples - 1, 1);
    for n=1:size(samples,1) % iterating over each of the images
        
        %%
        
        IX_curr_ex    = (pairs(:, 1) == n) | (pairs(:, 2) == n);
        IX_pairs      = pairs(IX_curr_ex, :);
        phonemes_1    = samples(IX_pairs(:, 1), :);
        phonemes_2    = samples(IX_pairs(:, 2), :);
        labels_1      = labels(IX_pairs(:, 1));
        labels_2      = labels(IX_pairs(:, 2));
        
        DesignMatrix  = (phonemes_1 - phonemes_2) .^ 2;
        similiarities = DesignMatrix * diag(W);
        
        %% Prec@k
        tmp_ranking       = [similiarities , labels_1 == labels_2]; % taking the similarity of image 'n' to all other images
        tmp_ranking       = sortrows(tmp_ranking, 1); % ranking according to the similiarity score
        a_ind             = tmp_ranking(:,2); % extracting the ranking of positive images per image:label
        
        results = results + cumsum(a_ind)./(1:length(a_ind))';
        
%         auc_score_per_example(n) = scoreAUC(tmp_ranking(:,2)==1, tmp_ranking(:,1));
    end
    
    precision_at_all_ks = results / num_samples;
%     auc = mean(auc_score_per_example);
 end