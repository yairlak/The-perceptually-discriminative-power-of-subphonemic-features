clear all; close all
addpath('Data')
[params, settings] = load_params_settings();
settings.feature_set = 'ARTICULATORY';
settings.method = 'ls';
settings.confusion_matrix = 'ExpHeb';

[samples, labels, ~, settings] = load_samples_labels(settings, params);
[samples, permVoicing] = sortrows(samples, 3);
samples = normc(samples')';

imagesc(samples * samples')
set(gca, 'Xtick', 1:length(settings.phonemes), 'Xticklabel', settings.phonemes(permVoicing))
set(gca, 'Ytick', 1:length(settings.phonemes), 'Yticklabel', settings.phonemes(permVoicing))