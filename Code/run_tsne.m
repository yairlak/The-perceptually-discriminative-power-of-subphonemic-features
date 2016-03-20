clear all; close all; clc
addpath('l1_ls_matlab', 'common functions', '../../tSNE_matlab')

%%
confusion_matrix = 'Luce';
feature_set = 'ARTICULATORY_ORTHO';
method = 'ls_metric_diag';

%%
color_feature = 1; % if smaller than zero, than no coloring.
font_size     = 26;
circle_size   = 750;

%%
settings.feature_set = feature_set; % 'MFCC', 'ARTICULATORY', etc.
settings.confusion_matrix = confusion_matrix;
settings.method = method; %Least squares 'ls', 'oasis', etc/

%% Settings & params
[params, settings] = load_params_settings(settings);
params.font_size = font_size;
params.circle_size = circle_size;

%% Load samples and labels according to feature_set
settings.preprocessing = false;
[samples, labels, similarity_mat, distance_mat, settings] = load_samples_labels(settings, params);
samples = samples + 1; % Number between 1 - N instead of 0 - N.

if color_feature > 0
    feature_name = eval(sprintf('settings.featureNames_%s{%i}', feature_set, color_feature));
    group = 
else
    feature_name = [];
end
%%
[n, d] = size(samples);
ind = randperm(n);
samples = samples(ind(1:n),:);
labels  = labels(ind(1:n));

%% Set parameters
no_dims = 2;
initial_dims = d;
perplexity = 30;

%% Run t?SNE
mappedX = tsne(samples, labels, no_dims, initial_dims, perplexity);

%% Plot results
gscatter(mappedX(:,1), mappedX(:,2), feature_name)
