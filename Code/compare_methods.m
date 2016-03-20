function t_tests = compare_methods(confusion_matrix)

% features = {'ARTICULATORY', 'ARTICULATORY_ORTHO', 'HALLE_CLEMENTS'};
features = {'ARTICULATORY_ORTHO', 'HALLE_CLEMENTS'};
methods  = {'ls_metric', 'ls_metric_diag', 'oasis_metric', 'oasis_metric_diag'};

%%
baselines.frisch = true;
baselines.PMV    = true;
baselines.PMVS   = false;

%% NN precision
t_tests.NN = plot_measures_vs_methods_and_feature_sets(confusion_matrix, methods, features, 'NN', baselines, true);

%% SPEARMAN RHO
t_tests.RHO = plot_measures_vs_methods_and_feature_sets(confusion_matrix, methods, features, 'RHO', baselines, true);

%% KENDALL TAU
t_tests.TAU = plot_measures_vs_methods_and_feature_sets(confusion_matrix, methods, features, 'TAU', baselines, true);

%% open HTML file
% fileID = fopen(fullfile('www', [file_name '.html']), 'w');
% % Begining of file
% fprintf(fileID, '<html>\n');
% fprintf(fileID, '<head>\n');
% fprintf(fileID, '<title>Phoneme FFT and Spectrograms</title>\n');
% fprintf(fileID, '<link rel="stylesheet" type="text/css" href="css/style.css">\n');
% fprintf(fileID, '</head>\n');
% fprintf(fileID, '<body>\n');
% % Compare methods
% fprintf(fileID, '<div class="section">\n');
% fprintf(fileID, '<div class="section_title"><u>Compare methods</u></div>\n');
% fprintf(fileID, '<div class="img_container centered">\n');
% fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', file_name));
% 
end