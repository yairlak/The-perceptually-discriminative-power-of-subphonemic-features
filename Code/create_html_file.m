function create_html_file(confusion_matrix, feature_set)

file_name = sprintf('%s_%s',confusion_matrix, feature_set);

%% open file
fileID = fopen(fullfile('www', [file_name '.html']), 'w');

%% Begining of file
fprintf(fileID, '<html>\n');
fprintf(fileID, '<head>\n');
fprintf(fileID, '<title>Phoneme FFT and Spectrograms</title>\n');
fprintf(fileID, '<link rel="stylesheet" type="text/css" href="css/style.css">\n');
fprintf(fileID, '</head>\n');
fprintf(fileID, '<body>\n');

%% Least-squares (Diagonal constraint)
fprintf(fileID, '<div class="section">\n');
fprintf(fileID, '<div class="section_title"><u> Least-squares (diagonal constraint)</u></div>\n');

% Feature weights
fprintf(fileID, '<div class="subsection">\n');
fprintf(fileID, '<div class="subsection_title"><u> Feature weights </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_ls_metric_diag', '_weights']));

% Regularizer size
fprintf(fileID, '<div class="subsection">\n');
fprintf(fileID, '<div class="subsection_title"><u> Precision vs. Size of regularizer </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_ls_metric_diag', '_reg']));

%% Least-squares
fprintf(fileID, '<div class="section">\n');
fprintf(fileID, '<div class="section_title"><u> Least-squares </u></div>\n');

% Feature weights
fprintf(fileID, '<div class="subsection">\n');
fprintf(fileID, '<div class="subsection_title"><u> Feature weights </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_ls_metric', '_weights']));

% Regularizer size
fprintf(fileID, '<div class="subsection">\n');
fprintf(fileID, '<div class="subsection_title"><u> Precision vs. Size of regularizer </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_ls_metric', '_reg']));

%% OASIS (Diagonal constraint)
fprintf(fileID, '<div class="section">\n');
fprintf(fileID, '<div class="section_title"><u> OASIS (diagonal constraint)</u></div>\n');

% Feature weights
fprintf(fileID, '<div class="subsection">\n');
fprintf(fileID, '<div class="subsection_title"><u> Feature weights </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_oasis_metric_diag', '_weights']));

% Regularizer size
fprintf(fileID, '<div class="subsection">\n');
fprintf(fileID, '<div class="subsection_title"><u> Precision vs. Size of regularizer </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_oasis_metric_diag', '_reg']));

% Loss
fprintf(fileID, '<div class="section">\n');
fprintf(fileID, '<div class="section_title"><u> Loss during training </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_oasis_metric_diag', '_loss']));

%% Oasis
fprintf(fileID, '<div class="section">\n');
fprintf(fileID, '<div class="section_title"><u> OASIS </u></div>\n');

% Feature weights
fprintf(fileID, '<div class="subsection">\n');
fprintf(fileID, '<div class="subsection_title"><u> Feature weights </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_oasis_metric', '_weights']));

% Regularizer size
fprintf(fileID, '<div class="subsection">\n');
fprintf(fileID, '<div class="subsection_title"><u> Precision vs. Size of regularizer </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_oasis_metric', '_reg']));

% Loss
fprintf(fileID, '<div class="section">\n');
fprintf(fileID, '<div class="section_title"><u> Loss during training </u></div>\n');
fprintf(fileID, '<div class="img_container centered">\n');
fprintf(fileID, '<img class="centered" src="%s.jpg">\n', fullfile('Figures', [file_name, '_oasis_metric',  '_loss']));

%%
fclose(fileID);

end