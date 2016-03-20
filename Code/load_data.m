function [FeatureMat, phonemes_MFCC_Summed, diffFeatureVec, DistMat, DistVec, labels, settings] = load_data(settings, dialect)

train_test = 'TEST';
%% Load Feature Matrix
FeatureMat = []; phonemes_MFCC_Summed = []; diffFeatureVec = [];
DistMat = []; DistVec = []; labels = [];

switch settings.featureMethod
    case 'Articulatory'
        FeatureMat = phonemeArticulatoryFeatures();
        
%         phoneme_names_Luce = FeatureMat(2:end, 1);
%         save('phoneme_names_Luce.mat', 'phoneme_names_Luce')
        
        FeatureMat = FeatureMat(2:end, 2:end);
        if ~isempty(settings.featureSubset) 
            FeatureMat = FeatureMat(:, settings.featureSubset);
        end
        FeatureMat = cellfun(@str2num, FeatureMat);
        FeatureMat = FeatureMat(settings.rowIndiceFeatures, :);
        FeatureMat = FeatureMat - ones(size(FeatureMat, 1), 1) * mean(FeatureMat);
        FeatureMat = FeatureMat ./ (ones(size(FeatureMat, 1), 1) * std(FeatureMat));
        % Compute the square difference between phonemes, element wise.
        diffFeatureVec = [];
        num_features = size(FeatureMat, 2);
        for f = 1:num_features
           featureCol       = FeatureMat(:, f);
           newCol           = pdist(featureCol) .^ 2';
           diffFeatureVec   = [diffFeatureVec newCol];
        end

        % Distance Matrix

        switch settings.similarityMethod
            case 'Confusion'
                confMat = confusionMat(settings.initFinal, settings.SNR);
                DistMat = convert_confusion_to_distance(confMat);
                DistMat = DistMat(settings.rowIndiceDist, settings.rowIndiceDist);
                % Transform similarity distances into a vector (assuming symmetric matrix)
                DistVec = squareform(DistMat, 'tovector')';
                DistVec = DistVec .^ 2; % (Fi - Fj)'*W'*W*(Fi - Fj) = DistVec ^ 2
                % save(sprintf('DistMat_%s_%s_%s.mat', settings.similarityMethod, settings.initFinal, settings.SNR),'DistMat')

                %% 
            case 'Neural'
                % ----
        end

    case 'MFCC'
        
        path2data = '/cortex/users/yairlak/phonemeTIMIT';
        filename = sprintf('phonemeTIMIT_Design_and_Distnace_Matrices_SummedColumns_Dialect%i_%s.mat', dialect, train_test);
        load(fullfile(path2data, filename), 'phonemes_MFCC_Summed', 'diffFeatureVec', 'DistVec', 'labels')
        
        switch settings.similarityMethod
            case 'Confusion'
                % --- already loaded above ---
            case 'Neural'
                % ----
        end

        
end

%% update settings struct
settings.numSamples               = size(diffFeatureVec, 1);
settings.numFeatures              = size(diffFeatureVec, 2);

end