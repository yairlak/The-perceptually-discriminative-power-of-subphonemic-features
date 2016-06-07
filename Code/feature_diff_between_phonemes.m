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

%% take only a subset of the features
subset_feat = [1, 3:13];
samples = samples(:, subset_feat);
settings.featureNames_Halle_Clements = settings.featureNames_Halle_Clements(subset_feat);

%%
h = figure;
imagesc(samples)
set(gca,'Xtick', 1:length(settings.featureNames_Halle_Clements), 'XtickLabel', settings.featureNames_Halle_Clements)
set(gca,'Ytick', 1:length(settings.phonemes), 'YtickLabel', settings.phonemes)
%
%%
fileID = fopen('feature_diff.txt','wt');
diff_features = cell(size(samples, 1),1);


for curr_diff = 0:13
    for phoneme1 = 1:size(samples, 1)
        for phoneme2 = (phoneme1+1):size(samples, 1)
            diff_vec = abs(samples(phoneme1,:) - samples(phoneme2,:));

            diff_vec = logical(abs(samples(phoneme1,:) - samples(phoneme2,:)));
            diff_fe  = settings.featureNames_Halle_Clements(diff_vec);
            if sum(diff_vec) == curr_diff
                fprintf(fileID, '%s,', settings.phonemes{phoneme1});
                fprintf(fileID, '%s,', settings.phonemes{phoneme2});
%                 fprintf(fileID, '%s,',similarity_mat(phoneme1, phoneme2));
                for i = 1:length(diff_fe)
                    fprintf(fileID, '%s,',diff_fe{i});
                end
                fprintf(fileID, '\n');
            end
        end
    end
end
fclose(fileID);

%%
% for rw = 2:size(data, 1)
%    phoneme1 = data{rw, 1}; 
%    phoneme2 = data{rw, 2};
%    IX_phn1 = strmatch(phoneme1, settings.phonemes);
%    IX_phn2 = strmatch(phoneme2, settings.phonemes);
%    diff_vec = logical(abs(samples(IX_phn1,:) - samples(IX_phn2,:)));
%    diff_fe = settings.featureNames_Halle_Clements(diff_vec);
%    curr_similarity = similarity_mat(IX_phn1, IX_phn2);
%    fprintf(fileID, '%s,',phoneme1);
%    fprintf(fileID, '%s,',phoneme2);
%    fprintf(fileID, '%s,',curr_similarity);
%    for i = 1:length(diff_fe)
%     fprintf(fileID, '%s,',diff_fe{i});
%    end
%    fprintf(fileID, '\n');
%    diff_features{rw-1}= settings.featureNames_Halle_Clements(diff_vec);
% end
