function fileName = get_filename(settings, params)

filename_strct.split      = params.split;
filename_strct.seed_split = params.seed_split;
switch settings.method
    case {'ls_metric', 'ls_metric_diag', 'ls_similarity', 'ls_similarity_diag'}
    filename_strct.lambda     = params.lambda;
%     filename_strct.alpha      = params.alpha;
    case {'oasis_similarity', 'oasis_metric', 'oasis_metric_diag'}
        filename_strct.aggress = params.oasis_aggress;
end
filename_strct.kNN = params.kNN;

fileName = buildStringFromStruct(filename_strct, '_');
fileName = [settings.preprocessing '_' fileName];
fileName = [settings.method '_' fileName];
fileName = [settings.feature_set '_' fileName];
fileName = [settings.confusion_matrix '_' fileName];
end