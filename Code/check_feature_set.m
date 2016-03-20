clear all; close all; clc
params = [];
%% Get Params from outside - parallalization script
settings.feature_set = 'ARTICULATORY_ORTHO';
settings.confusion_matrix = 'Luce';
settings.method      = 'ls_metric_diag'; %Least squares 'ls', 'oasis', etc/
addpath('l1_ls_matlab', 'common functions', fullfile('..', 'Data'))

%% Settings & params
[params, settings] = load_params_settings(settings, params);

%% Load samples and labels according to feature_set
settings.preprocessing = false;
settings.omit_NaNs = false;
[samples, ~, similarity_mat, distance_mat, settings] = load_samples_labels(settings, params);
samples = samples + 1; % Number between 1 - N instead of 0 - N.

%%
all_dist = true;
[num_phonemes, num_features] = size(samples);
for ph1 = 1:num_phonemes
    for ph2 = ph1+1:num_phonemes
        vec1 = samples(ph1, :);
        vec2 = samples(ph2, :);
        if vec1 == vec2
           all_dist = false;
           ph1
           ph2
        end
    end
end

%%
redundant_features = ones(num_features, 1);
for feature = 1:num_features
    samples_reduced = samples(:, setdiff(1:num_features, feature));
    for ph1 = 1:num_phonemes
        for ph2 = ph1+1:num_phonemes
            vec1 = samples_reduced(ph1, :);
            vec2 = samples_reduced(ph2, :);
            if vec1 == vec2
               redundant_features(feature) = 0;
            end
        end
    end
end