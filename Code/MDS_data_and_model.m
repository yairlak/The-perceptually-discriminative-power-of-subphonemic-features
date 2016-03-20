clear all; close all; clc
addpath('l1_ls_matlab', 'common functions')
% seed = 10;

%%
confusion_matrix = 'ExpHebWhite';
feature_set = 'HALLE_CLEMENTS';
method = 'ls_metric_diag';

%%
color_feature = -1; % if smaller than zero, than no coloring.
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
settings.omit_NaNs = false;
[samples, ~, similarity_mat, distance_mat, settings] = load_samples_labels(settings, params);
samples = samples + 1; % Number between 1 - N instead of 0 - N.

%% Run MDS
if color_feature > 0
    feature_name = eval(sprintf('settings.featureNames_%s{%i}', feature_set, color_feature));
else
    feature_name = [];
end

%% Run MDS
MDS_matrix(samples, distance_mat, settings.phonemes, {sprintf('Not %s', feature_name),feature_name}, color_feature, confusion_matrix, params)

%% Save figure
file_name = sprintf('MDS_%s_%s_%s_%s', confusion_matrix, feature_set, method, feature_name);
saveas(gcf, fullfile('..', 'Figures', file_name), 'png')
