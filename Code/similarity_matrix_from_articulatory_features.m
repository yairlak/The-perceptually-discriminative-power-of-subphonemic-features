clear all; close all; clc
addpath('../l1_ls_matlab', '../common functions', 'Data')
%%
settings.confusion_matrix = 'ExpHebWhite';
settings.method           = 'None';
settings.feature_set      = 'ARTICULATORY';

%% Settings & params
[params, settings] = load_params_settings(settings);
settings.preprocessing    = 'None';

%%
[samples , ~, ~, ~, ~] = load_samples_labels(settings, params);

%% Build distance matrix
num_phonemes                        = size(samples, 1);
PMV_distance_matrix = zeros(num_phonemes);
for ph1 = 1:num_phonemes
    for ph2 = (ph1 + 1):num_phonemes
        ph1_vec = samples(ph1, :);
        ph2_vec = samples(ph2, :);
        diff = length(ph1_vec) - sum(ph1_vec == ph2_vec);
        PMV_distance_matrix(ph1, ph2) = diff;
        PMV_distance_matrix(ph2, ph1) = diff;
    end
end

%%
file_name = ['PMV_similarity', settings.confusion_matrix, '.mat'];
save(fullfile('Data/', file_name), 'PMV_distance_matrix')