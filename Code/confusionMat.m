function Mat = confusionMat(init_final, SNR)

%% Choose initial/final phoneme, and Signal-to-Noise ratio
switch init_final
    case 'init'
        switch SNR
            case '5N'
                conf{1} = '14 53 26 2 3 4 6 2 5 2 0 7 1 0 0 5 2 3 0 3 0 1 11';
                conf{2} = '12 41 28 2 8 3 9 1 4 2 1 8 3 3 4 2 2 0 1 1 0 1 14';
                conf{3} = '6 46 36 2 5 3 9 0 12 0 1 5 1 2 0 3 1 2 0 0 0 0 16';
                conf{4} = '5 19 13 9 23 5 7 3 12 0 4 3 4 5 4 3 4 2 3 2 3 1 16';
                conf{5} = '4 17 6 4 38 19 5 8 9 2 3 2 6 1 6 2 1 1 4 3 0 0 9';
                conf{6} = '0 6 7 1 19 24 1 25 2 0 7 2 0 3 1 0 1 0 6 1 7 25 12';
                conf{7} = '6 21 13 0 5 6 58 9 6 3 2 2 1 1 1 2 1 0 3 0 1 2 7';
                conf{8} = '1 7 3 2 25 10 5 60 6 1 5 0 0 2 2 2 0 0 2 0 4 5 8';
                conf{9} = '9 18 16 2 16 6 11 1 34 1 6 5 5 2 3 1 0 0 1 0 1 2 10';
                conf{10} = '1 12 9 0 5 8 55 29 9 8 1 2 0 1 3 0 2 0 0 0 0 1 4';
                conf{11} = '2 4 0 7 30 24 4 21 6 1 7 0 5 6 4 0 0 0 2 3 7 13 4';
                conf{12} = '10 24 13 2 4 2 4 2 33 2 3 15 5 6 6 1 0 1 0 4 0 2 11';
                conf{13} = '7 34 17 4 5 4 8 2 16 3 4 19 3 4 9 2 0 0 0 0 1 1 7';
                conf{14} = '3 8 7 11 24 8 1 10 7 1 13 6 4 10 12 1 2 1 2 1 4 2 12';
                conf{15} = '2 11 4 7 21 17 2 13 6 0 12 6 2 3 11 0 2 1 2 7 6 4 11';
                conf{16} = '8 35 37 2 0 1 4 2 6 1 0 4 0 0 0 16 0 0 3 2 0 1 28';
                conf{17} = '0 2 2 1 1 0 0 0 4 1 1 0 0 1 0 0 61 59 5 0 1 2 9';
                conf{18} = '0 9 1 0 0 1 0 0 10 0 0 2 0 1 0 1 40 65 1 1 1 7 10';
                conf{19} = '2 6 1 3 2 1 1 3 0 0 1 2 2 2 3 1 4 3 65 15 9 13 11';
                conf{20} = '1 2 0 1 0 4 1 5 1 0 2 2 1 1 1 0 1 0 24 13 20 62 8';
                conf{21} = '1 2 1 0 4 6 0 9 2 0 3 1 0 3 2 2 2 3 20 13 18 42 16';
                conf{22} = '1 3 2 0 1 5 1 15 0 0 2 0 2 1 1 0 1 0 7 8 12 83 5';
                conf{23} = '5 21 11 3 5 3 0 2 4 0 0 5 0 0 3 10 4 2 3 5 1 4 59';
                % Omit no response:
                conf = conf(1:22);
            case '15P'
                % -----
        end

    case 'final'
        switch SNR
            case '5N'
                conf{1} = '27 24 31 1 0 1 27 0 11 6 1 7 1 2 0 0 1 1 0 0 1';
                conf{2} = '11 36 29 0 1 2 20 4 10 4 0 4 4 2 1 2 2 0 2 0 2';
                conf{3} = '11 39 35 1 0 2 22 2 13 3 1 5 1 0 0 2 0 0 1 0 1';
                conf{4} = '5 13 7 27 15 33 1 4 1 3 1 2 2 2 1 2 1 0 1 3 9';
                conf{5} = '2 7 3 6 20 27 9 7 8 6 1 5 3 8 2 2 2 3 0 1 11';
                conf{6} = '3 8 10 8 8 46 5 5 3 3 3 8 1 8 0 0 2 0 1 6 10';
                conf{7} = '6 21 12 0 1 0 70 2 6 11 0 3 2 0 2 1 0 0 1 0 5';
                conf{8} = '7 8 4 8 11 23 10 11 5 8 4 2 5 2 1 8 0 0 2 1 19';
                conf{9} = '9 21 26 2 1 6 18 3 24 5 1 5 3 3 0 2 0 2 1 2 3';
                conf{10} = '6 14 16 2 1 0 42 1 5 29 0 3 8 1 1 1 0 0 0 0 6';
                conf{11} = '2 2 0 6 11 13 2 5 3 1 5 2 1 11 6 17 2 2 5 6 22';
                conf{12} = '9 36 24 1 3 4 16 1 12 10 0 13 3 1 3 1 1 0 0 0 0';
                conf{13} = '9 29 29 0 1 7 21 0 12 7 0 6 4 1 3 3 1 2 0 0 1';
                conf{14} = '2 2 5 7 11 23 1 5 2 1 13 2 1 17 2 5 3 8 4 4 13';
                conf{15} = '4 4 3 6 11 28 2 8 7 0 5 4 3 14 4 4 2 9 3 4 12';
                conf{16} = '2 3 2 7 6 6 0 1 1 0 3 1 1 6 2 58 10 4 0 23 5';
                conf{17} = '1 1 4 6 6 5 1 0 0 0 1 1 0 5 1 41 29 3 3 22 2';
                conf{18} = '1 6 4 5 7 14 1 3 0 0 0 2 1 4 2 1 0 37 21 2 0';
                conf{19} = '1 4 2 2 7 7 1 2 6 1 5 3 2 4 2 4 0 30 35 1 2';
                conf{20} = '1 1 0 3 6 0 0 0 0 0 0 0 0 2 0 47 23 2 0 48 4';
                conf{21} = '3 5 0 10 12 21 0 5 4 1 17 0 2 7 2 4 1 4 2 7 30';
        end
        
end

%%
numPhonemes = length(conf);
Mat = zeros(numPhonemes);

for i = 1:numPhonemes
    vec = [];
    vec = textscan(conf{i}, '%s');
    vec = vec{1};
    vec = cellfun(@str2num, vec);
    Mat(i, 1:numPhonemes) = vec(1:(end-1)); %!!!END-1 because I omitted the 'no response' case, which is at the last column and last row
end

end
