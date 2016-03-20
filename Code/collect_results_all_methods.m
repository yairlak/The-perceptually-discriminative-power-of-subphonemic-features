clear all; close all; clc
addpath('l1_ls_matlab', 'common functions')

for confusion_matrix = {'Luce', 'NicelyMiller', 'ExpHebWhite'};
% for confusion_matrix = {'Luce', 'NicelyMiller'}
    confusion_matrix = confusion_matrix{1};
%     for feature_set = {'ARTICULATORY_ORTHO', 'HALLE_CLEMENTS'}
    for feature_set = {'ARTICULATORY_ORTHO', 'HALLE_CLEMENTS'}
        feature_set = feature_set{1};
%         for method = {'ls_metric', 'ls_metric_diag', 'oasis_metric', 'oasis_metric_diag'}
        for method = {'ls_metric_diag'}
            method = method{1};
            file_name = [confusion_matrix, '_', feature_set, '_', method];
%             if ~exist(fullfile('Figures', [file_name, '_reg.jpg']), 'file')
                fprintf('Generating summary files for: %s\n', file_name)
                collect_results
                fprintf('Generating figures for: %s\n', file_name)
                generate_figures
%             end                
        end
%         create_html_file(confusion_matrix, feature_set)
    end
    t_tests = compare_methods(confusion_matrix);
end