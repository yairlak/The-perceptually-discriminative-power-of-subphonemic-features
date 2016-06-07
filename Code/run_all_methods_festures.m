clear all; close all; clc
addpath('l1_ls_matlab', 'common functions')

for confusion_matrix = {'Luce', 'NicelyMiller', 'ExpHebWhite'};
% for confusion_matrix = {'ExpHebWhite'};
    confusion_matrix = confusion_matrix{1};
    for feature_set = {'ARTICULATORY_ORTHO', 'HALLE_CLEMENTS'}
%     for feature_set = {'ARTICULATORY_ORTHO'}
        feature_set = feature_set{1};
%         for method = {'ls_metric', 'ls_metric_diag', 'oasis_metric', 'oasis_metric_diag'}
        for method = {'ls_metric_diag'}
            method = method{1};
            fprintf('Data:%s, Theory:%s, Method:%s\n', confusion_matrix, feature_set, method);
%             evalc('run_main');
            run_main
        end
    end
end