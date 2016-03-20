function [samples, labels, similarity_mat, distance_mat, settings] = load_samples_labels(settings, params)
%% Feature samples:
switch settings.feature_set        
    case 'ARTICULATORY'
        samples = phonemeArticulatoryFeatures(false);
    case 'ARTICULATORY_ORTHO'
        samples = phonemeArticulatoryFeatures(true);
    case 'FRISCH'
        samples = phonemeFrischFeatures();
    case 'HALLE_CLEMENTS'
        samples = phonemeHalleClementsFeatures();
        samples = samples(:, settings.features_subset);
end

%% Step-wise regression: leave out a different feature each time
SWR = take_from_struct(settings, 'SWR', 0);
if SWR
    left_out_features = setdiff(1:size(samples, 2), params.subset_features, 'stable');
    samples(:, left_out_features) = 0;
end

%% Confusion matrix. Also order samples array according to the order of phonemes in the confusion matrix

switch settings.confusion_matrix
    case 'Luce'
        confMat = confusionMat(settings.initFinal, settings.SNR);
        % Labels:
        samples = samples([1:11 13:18 20:24], :); % Only phonemes in Luce's confusion matrix
        settings.phonemes = settings.phonemes([1:11 13:18 20:24]);
        labels = (1:22)';
        
    case 'NicelyMiller'
        confMat = load(fullfile('..', 'Data', 'NicelyMiller_minus12.mat'));
        confMat = confMat.confMat_NicelyMiller_minus12;

        % Labels:
        samples = samples([1:3 13:14 9:10 4:6 15:16 11:12 20 18], :); % Only phonemes in N&M's confusion matrix
        settings.phonemes = settings.phonemes([1:3 13:14 9:10 4:6 15:16 11:12 20 18]);
        labels = (1:16)';
        
    case 'ExpHebWhite'
        curr_data = load(fullfile('..', 'Data', 'ExpHebWhite.mat'));
%         similarity_mat = curr_data.similarity_matrix_probability;
        confMat = curr_data.AllConfMat;
%         confMat = confMat([1:8, 10:19, 22], [1:8, 10:19, 22]);
        % Labels:
        samples = samples([4 6 8 5 17 15 11 12 25 2 24 3 21 20 18 9 13 1 26 7 27 10], :); % Only phonemes in ExpHeb confusion matrix
        settings.phonemes = settings.phonemes([4 6 8 5 17 15 11 12 25 2 24 3 21 20 18 9 13 1 26 7 27 10]);
        labels = (1:22)'; 
        
        if settings.without_J_tS_Z
           subset = [1 2 4:7 9:19 21 22];
           samples = samples(subset, :);
           confMat = confMat(subset, subset);
           settings.phonemes = settings.phonemes(subset);
           labels = (1:19)';
        end
        
    case 'SpeechErrorsMIT'
        confMat = load(fullfile('..', 'Data', 'speech_errors_MIT.mat'));
        confMat = confMat.speech_errors_MIT;
        confMat(1:length(confMat)+1:end) = 0;
        
        % Labels:
        reorder_vec = [1,4,13,15,20,2,5,14,16,9,11,10,12,7,8,3,6,19,21,22,18,23,24,17];
        samples = samples(reorder_vec, :);
        settings.phonemes = settings.phonemes(reorder_vec);
        labels = (1:24)';
        
    case 'SpeechErrorsStemberger'
        confMat = load(fullfile('..', 'Data', 'speech_errors_STEMBERGER.mat'));
        confMat = confMat.speech_errors_STEMBERGER;
        confMat(1:length(confMat)+1:end) = 0;
        
        % Labels:
        reorder_vec = [1,4,13,15,20,2,5,14,16,9,11,10,12,7,8,3,6,19,21,22,18,23,24,17];
        samples = samples(reorder_vec, :);
        settings.phonemes = settings.phonemes(reorder_vec);
        labels = (1:24)';
end

%% Confusion to Similarity
switch settings.confusion_matrix
    case {'Luce', 'NicelyMiller', 'ExpHebWhite'}
        symmetriz_conf = take_from_struct(params, 'symmetrize_conf', 1);
        if symmetriz_conf
            numPhonemes = length(confMat);
            p_confMat = bsxfun(@rdivide, confMat, sum(confMat, 2));
            similarity_mat = (p_confMat + p_confMat')./(diag(p_confMat) * ones(1, numPhonemes) + ones(numPhonemes, 1) * diag(p_confMat)');
        else
            similarity_mat = confMat;
        end
%         nan_IX = (similarity_mat == 0);
        % similarity_mat(nan_IX) = NaN;
    case {'SpeechErrorsMIT', 'SpeechErrorsStemberger'}
        symmetriz_conf = take_from_struct(params, 'symmetrize_conf', 1);
        if symmetriz_conf
            p_confMat = bsxfun(@rdivide, confMat, sum(confMat, 2));
            p_confMat(isnan(p_confMat)) = 0;
            similarity_mat = (p_confMat + p_confMat')./2;
            similarity_mat(1:length(similarity_mat)+1:end) = 1;
        else
            similarity_mat = confMat;
        end
end

switch settings.method
    case {'ls_metric', 'ls_metric_diag'}
        if settings.omit_NaNs
            nan_IX = (similarity_mat == 0);
            similarity_mat(nan_IX) = NaN;
        end
end
%% Similarity to Perceived Distance
distance_mat = convert_confusion_to_distance(similarity_mat);

%% Omit non-distinctive features
% i.e., all zero for all samples:
diff_samples = abs(diff(samples));
all_identical = sum(diff_samples, 1);
IX_not_all_identical = (all_identical ~= 0);
num_features = size(samples, 2);
if sum(IX_not_all_identical) < num_features;
    samples = samples(:, IX_not_all_identical);
    switch settings.feature_set
        case 'MFCC'
            settings.featureNames_MFCC = settings.featureNames_MFCC(IX_not_all_identical);
           
        case 'ARTICULATORY'
            settings.featureNames_ARTICULATORY = settings.featureNames_ARTICULATORY(IX_not_all_identical);
            
        case 'ARTICULATORY_ORTHO'
           settings.featureNames_ARTICULATORY_ORTHO = settings.featureNames_ARTICULATORY_ORTHO(IX_not_all_identical);
        case 'FRISCH'
           settings.featureNames_FRISCH = settings.featureNames_FRISCH(IX_not_all_identical);
        case 'HALLE_CLEMENTS'
            settings.featureNames_HALLE_CLEMENTS = settings.featureNames_HALLE_CLEMENTS(IX_not_all_identical);
    end
end

%% Standarize features:
switch settings.preprocessing
    case 'standarize'
        samples = bsxfun(@minus, samples, mean(samples));
        samples = bsxfun(@rdivide, samples, std(samples));
    case 'normalize'
        samples = normc(samples')';
    case 'None'
end
        
%% LEAVE-ONE-OUT
settings.crossValidationKfold = length(labels);

end

% imagesc(similarity_mat)
% set(gca, 'Xtick', 1:length(settings.phonemes), 'Xticklabel', settings.phonemes)
% set(gca, 'Ytick', 1:length(settings.phonemes), 'Yticklabel', settings.phonemes)