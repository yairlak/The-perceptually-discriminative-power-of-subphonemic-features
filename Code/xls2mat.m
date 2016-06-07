% Convert xls to mat file (MIT corpus)
clear all; close all; clc
speech_errors_MIT = xlsread(fullfile('..', 'Data', 'MIT.xlsx'), 'B2:Y25');
[~, phoneme_names, ~] = xlsread(fullfile('..', 'Data', 'STEMBERGER.xlsx'), 'A2:A25');
save(fullfile('..', 'Data', 'speech_errors_MIT.mat'), 'speech_errors_MIT', 'phoneme_names')

%% Convert xls to mat file (Stemberger corpus)
clear all; close all; clc
speech_errors_STEMBERGER = xlsread(fullfile('..', 'Data', 'STEMBERGER.xlsx'), 'B2:Y25');
[~, phoneme_names, ~] = xlsread(fullfile('..', 'Data', 'STEMBERGER.xlsx'), 'A2:A25');
save(fullfile('..', 'Data', 'speech_errors_STEMBERGER.mat'), 'speech_errors_STEMBERGER', 'phoneme_names')

