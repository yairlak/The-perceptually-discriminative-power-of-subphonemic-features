clear all; close all; clc
addpath('../l1_ls_matlab', '../common functions', 'Data')

feature_sets = {'ARTICULATORY', 'ARTICULATORY_ORTHO', 'FRISCH'}; %{'ARTICULATORY', 'ARTICULATORY_ORTHO'};%, 'FRISCH'}
for feature_set = feature_sets
    feature_set = feature_set{1};
    Weights = []; Errors = []; counter = 1;
    for confusion_matrix = {'Luce', 'NicelyMiller', 'ExpHebWhite'} %{'Luce', 'NicelyMiller', 'ExpHebWhite'}
        
            confusion_matrix = confusion_matrix{1};
            
            for method = {'ls_metric_diag'} %{'ls_metric', 'ls_metric_diag', 'oasis_metric', 'oasis_metric_diag'}
               method = method{1};
          
                file_name = [confusion_matrix, '_', feature_set, '_', method];
                if ~(strcmp(confusion_matrix, 'ExpHebWhite')&&strcmp(feature_set,'FRISCH'))
                    collect_results_weights
                end
                switch feature_set
                    case 'ARTICULATORY'
                        Weights(counter, :) = weights_ave';
                        Errors(counter, :) = weights_std';
                    case 'ARTICULATORY_ORTHO'
                        switch confusion_matrix
                            case 'Luce'
                                Weights(counter, :) = weights_ave';
                                Errors(counter, :) = weights_std';
                            case 'NicelyMiller'
                                Weights(counter, 1:5) = weights_ave(1:5);
                                Weights(counter, 7) = weights_ave(6);
                                Weights(counter, 9:10) = weights_ave(7:8);
                                Weights(counter, 14) = weights_ave(9);
                                Errors(counter, 1:5) = weights_std(1:5);
                                Errors(counter, 7) = weights_std(6);
                                Errors(counter, 9:10) = weights_std(7:8);
                                Errors(counter, 14) = weights_std(9);
                            case 'ExpHebWhite'
                                Weights(counter, 1) = weights_ave(1);
                                Weights(counter, 3:11) = weights_ave(2:10);
                                Weights(counter, 13:14) = weights_ave(11:12);
                                Errors(counter, 1) = weights_std(1);
                                Errors(counter, 3:11) = weights_std(2:10);
                                Errors(counter, 13:14) = weights_std(11:12);
                                
                        end
                        
                    case 'FRISCH'
                        switch confusion_matrix
                            case 'Luce'
                                Weights(counter, :) = weights_ave';
                                Errors(counter, :) = weights_std';
                            case 'NicelyMiller'
                                Weights(counter, 1:12) = weights_ave(1:12);
                                Weights(counter, 14:15) = weights_ave(13:14);
                                Weights(counter, 17:18) = weights_ave(15:16);
                                Weights(counter, 21:23) = weights_ave(17:19);
                                Errors(counter, 1:12) = weights_std(1:12);
                                Errors(counter, 14:15) = weights_std(13:14);
                                Errors(counter, 17:18) = weights_std(15:16);
                                Errors(counter, 21:23) = weights_std(17:19);
                            case 'ExpHebWhite'
                                Weights(counter, :) = 0;
                                Errors(counter, :) = 0;
                        end
                            
                end
                
            end
    counter = counter + 1;        
    end
    
    [~, settings] = load_params_settings();
    switch feature_set
        case 'ARTICULATORY'
            group_names = settings.featureNames_Articulatory3;
        case 'ARTICULATORY_ORTHO'
            group_names = settings.featureNames_Articulatory14;
        case 'FRISCH'
            group_names = settings.featureNames_Frisch;
    end
    
    figWeights = figure();
    barweb(Weights', Errors', 0.5, group_names)
    set(gcf, 'Color', [1 1 1])
    ylabel('Relative weight size', 'FontSize', 20)
%     h_legend = legend('Luce', 'Nicely & Miller', 'Hebrew phonemes', 'Location', 'NorthEastOutside');
%     set(h_legend,'FontSize',20);
    set(figWeights, 'units','normalized','outerposition',[0 0 1 1])
    set(figWeights, 'PaperPositionMode','auto') 
    file_name = [feature_set, '_', method];
    saveas(gcf, fullfile('Figures', ['AllData_' file_name, '_weights']), 'jpg')
    close(figWeights)
%         create_html_file(confusion_matrix, feature_set)
    
%     compare_methods(confusion_matrix)
end