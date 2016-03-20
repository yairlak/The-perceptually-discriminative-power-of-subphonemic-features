clear all; close all; clc

%%
load('DistMat_Confusion_final_5N.mat')
load('phoneme_names_Luce.mat')

%%
imagesc(DistMat)

set(gca, 'XTick', 1:length(phoneme_names_Luce))
set(gca, 'YTick', 1:length(phoneme_names_Luce))
set(gca, 'XTickLabels', phoneme_names_Luce)
set(gca, 'YTickLabels', phoneme_names_Luce)
