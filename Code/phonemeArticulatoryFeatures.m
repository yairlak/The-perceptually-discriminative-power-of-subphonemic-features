function samples = phonemeArticulatoryFeatures(binary_flag)
%% This function creates a matrix with consonant phonemes 
% according to their articulatoric features.
% ----------------------------------------------------------------------
% Manner: Stop - 1, affricate - 2, fricative - 3, Nasal - 4, Lateral - 5,
% Rhot - 6, Glide - 7 (According to sonority hierarchy - more or less)
% Place: Labial - 1, Dental - 2, Alvear - 3, Paletal - 4, Velar - 5,
% Golttal - 6
% ----------------------------------------------------------------------

%%
featureMat = cell(28, 5);

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

featureMat{5, 1} = 'b';
featureMat{5, 2} = '1';
featureMat{5, 3} = '0';
featureMat{5, 4} = '1';
featureMat{5, 5} = '1';

featureMat{6, 1} = 'd';
featureMat{6, 2} = '3';
featureMat{6, 3} = '0';
featureMat{6, 4} = '1';
featureMat{6, 5} = '1';

featureMat{7, 1} = 'g';
featureMat{7, 2} = '5';
featureMat{7, 3} = '0';
featureMat{7, 4} = '1';
featureMat{7, 5} = '1';

featureMat{8, 1} = 'tS';
featureMat{8, 2} = '4';
featureMat{8, 3} = '0';
featureMat{8, 4} = '2';
featureMat{8, 5} = '0';

featureMat{9, 1} = 'dZ';
featureMat{9, 2} = '4';
featureMat{9, 3} = '0';
featureMat{9, 4} = '2';
featureMat{9, 5} = '1';

featureMat{10, 1} = 's';
featureMat{10, 2} = '3';
featureMat{10, 3} = '0';
featureMat{10, 4} = '3';
featureMat{10, 5} = '0';

featureMat{11, 1} = 'S';
featureMat{11, 2} = '4';
featureMat{11, 3} = '0';
featureMat{11, 4} = '3';
featureMat{11, 5} = '0';

featureMat{12, 1} = 'z';
featureMat{12, 2} = '3';
featureMat{12, 3} = '0';
featureMat{12, 4} = '3';
featureMat{12, 5} = '1';

featureMat{13, 1} = 'Z';
featureMat{13, 2} = '4';
featureMat{13, 3} = '0';
featureMat{13, 4} = '3';
featureMat{13, 5} = '1';

featureMat{14, 1} = 'f';
featureMat{14, 2} = '1';
featureMat{14, 3} = '0';
featureMat{14, 4} = '3';
featureMat{14, 5} = '0';

featureMat{15, 1} = 'T';
featureMat{15, 2} = '2';
featureMat{15, 3} = '0';
featureMat{15, 4} = '3';
featureMat{15, 5} = '0';

featureMat{16, 1} = 'v';
featureMat{16, 2} = '1';
featureMat{16, 3} = '0';
featureMat{16, 4} = '3';
featureMat{16, 5} = '1';

featureMat{17, 1} = 'D';
featureMat{17, 2} = '2';
featureMat{17, 3} = '0';
featureMat{17, 4} = '3';
featureMat{17, 5} = '1';

featureMat{18, 1} = 'h';
featureMat{18, 2} = '6';
featureMat{18, 3} = '0';
featureMat{18, 4} = '3';
featureMat{18, 5} = '0';

featureMat{19, 1} = 'n';
featureMat{19, 2} = '3';
featureMat{19, 3} = '1';
featureMat{19, 4} = '4';
featureMat{19, 5} = '1';

featureMat{20, 1} = 'G';
featureMat{20, 2} = '5';
featureMat{20, 3} = '1';
featureMat{20, 4} = '4';
featureMat{20, 5} = '1';

featureMat{21, 1} = 'm';
featureMat{21, 2} = '1';
featureMat{21, 3} = '1';
featureMat{21, 4} = '4';
featureMat{21, 5} = '1';

featureMat{22, 1} = 'l';
featureMat{22, 2} = '3';
featureMat{22, 3} = '1';
featureMat{22, 4} = '5';
featureMat{22, 5} = '1';

featureMat{23, 1} = 'r';
featureMat{23, 2} = '3';
featureMat{23, 3} = '1';
featureMat{23, 4} = '6';
featureMat{23, 5} = '1';

featureMat{24, 1} = 'w';
featureMat{24, 2} = '1';
featureMat{24, 3} = '1';
featureMat{24, 4} = '7';
featureMat{24, 5} = '1';

featureMat{25, 1} = 'y';
featureMat{25, 2} = '4';
featureMat{25, 3} = '1';
featureMat{25, 4} = '7';
featureMat{25, 5} = '1';

featureMat{26, 1} = 'X'; % Chet
featureMat{26, 2} = '5';
featureMat{26, 3} = '1';
featureMat{26, 4} = '3';
featureMat{26, 5} = '0';

featureMat{27, 1} = 'ts'; %Tzadik
featureMat{27, 2} = '3';
featureMat{27, 3} = '0';
featureMat{27, 4} = '2';
featureMat{27, 5} = '0';

featureMat{28, 1} = 'R'; % Israeli R
featureMat{28, 2} = '5';
featureMat{28, 3} = '1';
featureMat{28, 4} = '6';
featureMat{28, 5} = '1';

features = str2double(featureMat(2:end, [2, 4, 5]));
%% If binary representation
if binary_flag
    samples = zeros(size(features, 1), 14); % Place 1-of-6, Manner 1-of-7, voicing 0/1.
    for ph = 1:size(features, 1)
        place = features(ph, 1);
        samples(ph, place) = 1;

        manner = features(ph, 2);
        samples(ph, 6 + manner) = 1;

        voicing = features(ph, 3);
        samples(ph, 14) = voicing;
    end
else
    samples = features;
end

end