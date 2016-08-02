function [params, settings] = load_params_settings(settings, params)

%%
settings.without_J_tS_Z = true; % For Hebrew experiment
settings.omit_NaNs      = false;
%%
settings.preprocessing = 'standarize'; % 'standarize'/'normalize'
params.symmetrize_conf = true;

%% General params
params.seed_split             = 1;
params.kNN                    = 1; % number of k nearest neighbors in evalutaions
params.validation_test_sets_ration   = 100; % percent Validation:Test sets.

%% Luce:
settings.initFinal         = 'init'; % (init/final) Similarity determined from confusion according to begining/ending of the presented words.
settings.SNR               = '5N'; % SNR in experiment (see function - confusionMat(init_final, SNR))

%% Features
settings.featureNames_ARTICULATORY  = {'Place'; 'Manner'; 'Voicing'};
settings.featureNames_ARTICULATORY_ORTHO = {'Labial'; 'Dental'; 'Alveolar'; 'Palatal'; 'Velar'; 'Glottal'; 'Plosive'; 'Affricate'; 'Fricative'; 'Nasal'; 'Lateral'; 'Rhotic'; 'Glide'; 'Voiced'};
settings.featureNames_HALLE_CLEMENTS = {'Consonantal', 'Sonorant', 'Continuant', 'Delayed release', 'Strident', 'Voiced', 'Nasal', 'Dorsal', 'Anterior', 'Labial', 'Coronal', 'Distributed', 'Lateral'};

settings.featureNames_HALLE_CLEMENTS = settings.featureNames_HALLE_CLEMENTS(settings.features_subset);

%% Lasso
settings.lambda_orders = [-3:1:5];
settings.lambda_values = [1, 5];

%% OASIS
params.oasis_num_steps  = 5000;
params.do_psd           = true;
settings.aggresses      = [0.001, 0.01, 0.1, 0.5];

%% phoneme order
settings.phonemes = {'p', 't', 'k', 'b', 'd', 'g', 'C', 'J', 's', 'S', 'z', 'Z', 'f', 'T', 'v', 'D', 'h', 'n', 'G', 'm', 'l', 'r', 'w', 'y', 'X', 'ts', 'R'}';

end
