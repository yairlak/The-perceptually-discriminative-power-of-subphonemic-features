function samples = phonemeFrischFeatures()

% samples = xlsread(fullfile('Data', 'Frische features.xlsx'), 'B2:Y25');
load(fullfile('Data', 'frisch_features_Eng_Heb.mat'))
order_vec = [1  6  16 2  7  17 ...
             14 15 10 12 11 13 3  ...
             8  4  9  24 21 18 5  ...
             19 20 22 23, 25, 26, 27]; 

samples = samples(order_vec, :);

end