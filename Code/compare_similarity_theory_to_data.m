clear all; close all; clc
addpath('../l1_ls_matlab', '../common functions', 'Data')
%% Empirical data:
settings.confusion_matrix = 'ExpHebWhite';
settings.method           = 'None';
settings.feature_set      = 'ARTICULATORY';

%% Theoretical data:
similarity_theory         = 'PMV_similarity'; % PMV_similarity, PMVS_similarity, frisch_similarity

%% Settings & params
[params, settings] = load_params_settings(settings);

%% Load empirical matrix
[~ , ~, empirical_similarity_mat, empirical_distance_mat, settings] = load_samples_labels(settings, params);

%% Load theoretical matrix
switch similarity_theory
    case 'frisch_similarity'
        switch settings.confusion_matrix
            case 'Luce'
                load(fullfile('Data/', 'frisch_similarity.mat'), 'frisch_similarity_ordered_as_Luce')
                % Convert similarity to distance
                theoretical_distance_mat = convert_confusion_to_distance(frisch_similarity_ordered_as_Luce);
            case 'NicelyMiller'
                load(fullfile('Data/', 'frisch_similarity.mat'), 'frisch_similarity_ordered_as_NicelyMiller')
                % Convert similarity to distance
                theoretical_distance_mat = convert_confusion_to_distance(frisch_similarity_ordered_as_NicelyMiller);
        end
    case 'PMV_similarity'
        file_name = ['PMV_similarity', settings.confusion_matrix, '.mat'];
        load(fullfile('Data/', file_name), 'PMV_distance_matrix')
        theoretical_distance_mat = PMV_distance_matrix;
    case 'PMVS_similarity'
        load(fullfile('Data/', 'PMVS_similarity.mat'), 'PMVS_distance_matrix_ordered_as_Luce')
        theoretical_distance_mat = PMVS_distance_matrix_ordered_as_Luce;
end

%% compare between empirical and theoretical matrices
num_phonemes = length(empirical_distance_mat);
for ph = 1:num_phonemes
    other_phonemes = setdiff(1:num_phonemes, ph, 'stable');
    curr_empirical_distances   = empirical_distance_mat(ph, other_phonemes);
    curr_theoretical_distances = theoretical_distance_mat(ph, other_phonemes);
    
    % Spearman's RHO
    RHO1(ph) = corr(curr_empirical_distances', curr_theoretical_distances', 'type', 'Spearman');
    
    % Kendall's TAU
    TAU1(ph) = corr(curr_empirical_distances', curr_theoretical_distances', 'type', 'Kendall');
    
    % NN-precision
    tmp_ranking      = [curr_theoretical_distances' (1:(num_phonemes-1))'];
    tmp_ranking      = sortrows(tmp_ranking, 1); % Ascending order
    nearest_neighbor_predicted = tmp_ranking(1, 2);
    clear tmp_ranking

    tmp_ranking         = [curr_empirical_distances' (1:(num_phonemes-1))'];
    tmp_ranking         = sortrows(tmp_ranking, 1); % Ascending order
    nearest_neighbor_confMat = tmp_ranking(1, 2);
    clear tmp_ranking
    
    NN1(ph) = nearest_neighbor_predicted == nearest_neighbor_confMat;
end
% Calc averages and STD of measures
RHO_ave = mean(RHO1);
RHO_std = std(RHO1);
TAU_ave = mean(TAU1);
TAU_std = std(TAU1);
NN1_ave = mean(NN1);
NN1_std = std(NN1);

%% Save to file
file_name = sprintf('Analyses_%s_%s',settings.confusion_matrix, similarity_theory);
save(fullfile('Output/', file_name), 'RHO1', 'TAU1', 'NN1', 'empirical_distance_mat', 'theoretical_distance_mat')

%%
figure;imagesc(empirical_distance_mat)
set(gca, 'Xtick', 1:length(settings.phonemes), 'Xticklabel', settings.phonemes)
set(gca, 'Ytick', 1:length(settings.phonemes), 'Yticklabel', settings.phonemes)
figure;imagesc(theoretical_distance_mat)
set(gca, 'Xtick', 1:length(settings.phonemes), 'Xticklabel', settings.phonemes)
set(gca, 'Ytick', 1:length(settings.phonemes), 'Yticklabel', settings.phonemes)
