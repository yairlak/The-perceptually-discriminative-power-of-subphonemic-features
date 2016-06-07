function save_to_file(model, results, settings, params)

filename_strct.split      = params.split;
filename_strct.seed_split = params.seed_split;
switch settings.method
    case {'ls', 'ls_dot_product', 'ls_dot_product_diag'}
    filename_strct.lambda     = params.lambda;
%     filename_strct.alpha      = params.alpha;
end
filename_strct.kNN = params.kNN;

fileName = buildStringFromStruct(filename_strct, '_');
fileName = [settings.preprocessing '_' fileName];
fileName = [settings.method '_' fileName];
fileName = [settings.feature_set '_' fileName];
fileName = [settings.confusion_matrix '_' fileName];

save(fullfile(settings.path2output, [fileName '.mat']), 'model', 'results')

end