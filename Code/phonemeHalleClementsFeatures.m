function samples = phonemeHalleClementsFeatures()

load(fullfile('..', 'Data', 'HalleClements_features_Eng_Heb.mat'))
order_vec = [1,3,5,2,4,6,7,8,13,15,14,16,9,11,10,12,17,19,20,18,21,22,23,24,25,26,27];
samples = samples(order_vec, :);

% subset_feat = [1:3, 5:7, 11,12,14];
% samples = samples(:, subset_feat);

end