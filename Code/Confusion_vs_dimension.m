clear all; close all; clc
addpath('../l1_ls_matlab', '../common functions', 'Data')

%%
feature_set = 'ARTICULATORY';
confusion_matrix = 'Luce';
method = 'ls_metric_diag';
settings.feature_set = feature_set; % 'MFCC', 'ARTICULATORY', etc.
settings.confusion_matrix = confusion_matrix;
settings.method      = method; %Least squares 'ls', 'oasis', etc/

%% Settings & params
[params, settings] = load_params_settings(settings);

%% Load samples and labels according to feature_set
switch settings.feature_set        
    case 'ARTICULATORY'
        samples = phonemeArticulatoryFeatures(false);
    case 'ARTICULATORY_ORTHO'
        samples = phonemeArticulatoryFeatures(true);
        if settings.SWR
            left_out_features = setdiff(1:14, params.subset_features, 'stable');
            samples(:, left_out_features) = 0;
        end
    case 'FRISCH'
        samples = phonemeFrischFeatures();
    case 'HALLE_CLEMENTS'
        samples = phonemeHalleClementsFeatures();
end

[~, ~, similarity_mat, distance_mat, ~] = load_samples_labels(settings, params);
% imagesc(distance_mat)

switch settings.confusion_matrix
    case 'Luce'
        samples = samples([1:11 13:18 20:24], :); % Only phonemes in Luce's confusion matrix
        settings.phonemes = settings.phonemes([1:11 13:18 20:24]);
        
    case 'NicelyMiller'
        samples = samples([1:3 13:14 9:10 4:6 15:16 11:12 20 18], :); % Only phonemes in N&M's confusion matrix
        settings.phonemes = settings.phonemes([1:3 13:14 9:10 4:6 15:16 11:12 20 18]);
       
    case 'ExpHebWhite'
        samples = samples([4 6 8 5 17 15 11 12 25 2 24 3 21 20 18 9 13 1 26 7 27 10], :); % Only phonemes in ExpHeb confusion matrix
        settings.phonemes = settings.phonemes([4 6 8 5 17 15 11 12 25 2 24 3 21 20 18 9 13 1 26 7 27 10]);

end

%%
similarity_vs_place_diff = cell(6, 1);
for phoneme1 = 1:size(samples, 1)
    for phoneme2 = (phoneme1+1):size(samples, 1)
        place_diff = abs(samples(phoneme1,1) - samples(phoneme2,1));
        curr_similarity = similarity_mat(phoneme1, phoneme2);
        similarity_vs_place_diff{place_diff+1} = [similarity_vs_place_diff{place_diff+1} curr_similarity];
    end
end
averages = cellfun(@mean, similarity_vs_place_diff);
STDs     = cellfun(@std, similarity_vs_place_diff);
counter  = cellfun(@length, similarity_vs_place_diff);
f1 = figure();
errorbar(0:5, averages, STDs./sqrt(counter),'LineWidth', 2)
set(f1, 'Color', [1 1 1])
xlabel('Difference - Place of Articulation', 'FontSize', 14)
ylabel('Mean similarity', 'FontSize', 14)
% title('Place: Labial - 1, Dental - 2, Alvear - 3, Post-alvear - 4, Velar - 5, Golttal - 6')