function [samples, labels_NM] = phonemeArticulatoryFeatures_NicelyMiller()
%% This function creates a matrix with consonant phonemes 
% according to their articulatoric features.
% ----------------------------------------------------------------------
% Manner: Stop - 1, affricate - 2, fricative - 3, Nasal - 4, Lateral - 5,
% Rhot - 6, Glide - 7 (According to sonority hierarchy - more or less)
% Place: Labial - 1, Dental - 2, Alvear - 3, Post-alvear - 4, Velar - 5,
% Golttal - 6
% ----------------------------------------------------------------------

%%
labels_NM = [1:16]';
featureMat = cell(16, 5);

featureMat{1, 1} = 'Phoneme';
featureMat{1, 2} = 'Place';
featureMat{1, 3} = 'Sonority';
featureMat{1, 4} = 'Manner';
featureMat{1, 5} = 'Voicing';

featureMat{2, 1} = 'p';
featureMat{2, 2} = '1';
featureMat{2, 3} = '0';
featureMat{2, 4} = '1';
featureMat{2, 5} = '0';

featureMat{3, 1} = 't';
featureMat{3, 2} = '3';
featureMat{3, 3} = '0';
featureMat{3, 4} = '1';
featureMat{3, 5} = '0';

featureMat{4, 1} = 'k';
featureMat{4, 2} = '5';
featureMat{4, 3} = '0';
featureMat{4, 4} = '1';
featureMat{4, 5} = '0';

featureMat{5, 1} = 'f';
featureMat{5, 2} = '1';
featureMat{5, 3} = '0';
featureMat{5, 4} = '3';
featureMat{5, 5} = '0';

featureMat{6, 1} = 'T';
featureMat{6, 2} = '2';
featureMat{6, 3} = '0';
featureMat{6, 4} = '3';
featureMat{6, 5} = '0';

featureMat{7, 1} = 's';
featureMat{7, 2} = '3';
featureMat{7, 3} = '0';
featureMat{7, 4} = '3';
featureMat{7, 5} = '0';

featureMat{8, 1} = 'S';
featureMat{8, 2} = '4';
featureMat{8, 3} = '0';
featureMat{8, 4} = '3';
featureMat{8, 5} = '0';

featureMat{9, 1} = 'b';
featureMat{9, 2} = '1';
featureMat{9, 3} = '0';
featureMat{9, 4} = '1';
featureMat{9, 5} = '1';

featureMat{10, 1} = 'd';
featureMat{10, 2} = '3';
featureMat{10, 3} = '0';
featureMat{10, 4} = '1';
featureMat{10, 5} = '1';

featureMat{11, 1} = 'g';
featureMat{11, 2} = '5';
featureMat{11, 3} = '0';
featureMat{11, 4} = '1';
featureMat{11, 5} = '1';

featureMat{12, 1} = 'v';
featureMat{12, 2} = '1';
featureMat{12, 3} = '0';
featureMat{12, 4} = '3';
featureMat{12, 5} = '1';

featureMat{13, 1} = 'D';
featureMat{13, 2} = '2';
featureMat{13, 3} = '0';
featureMat{13, 4} = '3';
featureMat{13, 5} = '1';

featureMat{14, 1} = 'z';
featureMat{14, 2} = '3';
featureMat{14, 3} = '0';
featureMat{14, 4} = '3';
featureMat{14, 5} = '1';

featureMat{15, 1} = 'Z';
featureMat{15, 2} = '4';
featureMat{15, 3} = '0';
featureMat{15, 4} = '3';
featureMat{15, 5} = '1';

featureMat{16, 1} = 'm';
featureMat{16, 2} = '1';
featureMat{16, 3} = '1';
featureMat{16, 4} = '4';
featureMat{16, 5} = '1';

featureMat{17, 1} = 'n';
featureMat{17, 2} = '3';
featureMat{17, 3} = '1';
featureMat{17, 4} = '4';
featureMat{17, 5} = '1';

samples = str2double(featureMat(2:end, [2, 4, 5]));
end