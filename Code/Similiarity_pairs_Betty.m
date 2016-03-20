clear all; close all; clc
addpath('../l1_ls_matlab', '../common functions', 'Data')

%%
feature_set = 'HALLE_CLEMENTS';
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
% imagesc(distance_mat)

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
h = figure;
imagesc(samples)
set(gca,'Xtick', 1:length(settings.featureNames_Halle_Clements), 'XtickLabel', settings.featureNames_Halle_Clements)
set(gca,'Ytick', 1:length(settings.phonemes), 'YtickLabel', settings.phonemes)
%
Single_feature_diff = cell(1, 4);
counter = 0;
for phoneme1 = 1:size(samples, 1)
    for phoneme2 = (phoneme1+1):size(samples, 1)
        diff_vec = abs(samples(phoneme1,:) - samples(phoneme2,:));
        if sum(diff_vec) == 1
            counter = counter + 1;
            Single_feature_diff{counter, 1} = settings.phonemes(phoneme1);
            Single_feature_diff{counter, 2} = settings.phonemes(phoneme2);
            Single_feature_diff{counter, 3} = settings.featureNames_Halle_Clements(find(diff_vec));
            Single_feature_diff{counter, 4} = similarity_mat(phoneme1, phoneme2);
        end
    end
end

%%
fileID = fopen('diff_features.txt','wt');
[~, data, ~] = xlsread('C:\Users\User\Documents\MATLAB\GPC\featuresMOPE_distinctiveFeatures.xlsx');
diff_features = cell(size(data, 1),1);
for rw = 2:size(data, 1)
   phoneme1 = data{rw, 1}; 
   phoneme2 = data{rw, 2};
   IX_phn1 = strmatch(phoneme1, settings.phonemes);
   IX_phn2 = strmatch(phoneme2, settings.phonemes);
   diff_vec = logical(abs(samples(IX_phn1,:) - samples(IX_phn2,:)));
   diff_fe = settings.featureNames_Halle_Clements(diff_vec);
   curr_similarity = similarity_mat(IX_phn1, IX_phn2);
   fprintf(fileID, '%s,',phoneme1);
   fprintf(fileID, '%s,',phoneme2);
   fprintf(fileID, '%s,',curr_similarity);
   for i = 1:length(diff_fe)
    fprintf(fileID, '%s,',diff_fe{i});
   end
   fprintf(fileID, '\n');
   diff_features{rw-1}= settings.featureNames_Halle_Clements(diff_vec);
end
fclose(fileID);