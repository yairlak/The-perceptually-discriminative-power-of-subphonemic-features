
%% Get Params from outside - parallalization script
settings.feature_set = feature_set; % 'MFCC', 'ARTICULATORY', etc.
settings.confusion_matrix = confusion_matrix;
settings.method      = method; %Least squares 'ls', 'oasis', etc/
addpath('l1_ls_matlab', 'common functions', fullfile('..', 'Data'))

%% Settings & params
[params, settings] = load_params_settings(settings, params);

%% Load samples and labels according to feature_set
[samples, labels, similarity_mat, distance_mat, settings] = load_samples_labels(settings, params);

%% Split Data - train/test
[train_samples, test_samples, train_labels, test_labels] = ...
            splitTrainTest(params, settings, samples, labels);

%% Train model
model = train_model(train_samples, train_labels, similarity_mat, distance_mat, settings, params);

%% Evaluate model
results = evaluate_model(model, train_samples, test_samples, train_labels, test_labels, similarity_mat, distance_mat, settings, params);

%% Save model and results
% fileName = get_filename(settings, params);
save(fullfile('..', 'Output', [fileName '.mat']), 'model', 'results')
