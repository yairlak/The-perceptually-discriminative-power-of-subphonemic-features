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
delta = 0.1;
c = zeros(size(samples,1), 1);
for place = 1:6
    c(samples(:, 1) == place) = 0.15 + delta*place;
end
num_place_features = (max(c)-min(c))/delta + 1;

%% MDS
% h1 = figure();
% MDS = mdscale(distance_mat, 3);
% scatter3(MDS(:, 1), MDS(:, 2), MDS(:, 3), 50, c, '.')
% dx = 0.1; dy = 0.1; dz = 0.1; % displacement so the text does not overlay the data points
% text(MDS(:, 1)+dx, MDS(:, 2)+dy, MDS(:, 3) + dz, settings.phonemes, 'FontWeight', 'bold');
% set(h1, 'Color', [1 1 1])

%%
h2 = figure();
MDS = mdscale(distance_mat, 2);
% MDS = mdscale(distance_mat, 2, 'criterion', 'strain');
scatter(MDS(:, 1), MDS(:, 2), 200, c, '.')
dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points
text(MDS(:, 1)+dx, MDS(:, 2)+dy, settings.phonemes, 'FontWeight', 'bold');
title(confusion_matrix, 'FontSize', 14, 'FontWeight', 'bold')
set(h2, 'Color', [1 1 1])
set(h2, 'units','normalized','outerposition',[0 0 1 1])
set(h2, 'PaperPositionMode','auto') 
% add color labels
place_features = {'Labial', 'Dental', 'Alveolar', 'Post-alveolar', 'Velar', 'Glottal'};
cmap = colormap;
IX = round(linspace(1,64,num_place_features));
for place = 1:num_place_features
    text(3,2-place*0.2, place_features{place}, 'Color', cmap(IX(place), :), 'FontWeight', 'bold')
end
axis equal