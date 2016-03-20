function MDS_matrix(samples, distance_mat, phoneme_names, Features, color_feature, title, params)
%%
if color_feature > 0
    color_scale = zeros(size(samples,1), 1);
    max_value_feature = max(samples(:, color_feature));
    delta = 1 / (max_value_feature + 1);
    for curr_value = 1:max_value_feature+1
        color_scale(samples(:, color_feature) == curr_value) = delta * (curr_value-1);
    end
else
%    color_scale = ones(length(phoneme_names), 1) * abs(color_feature);
    color_scale = 'b';
end
%%
h2 = figure();
dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points
%%
% MDS = mdscale(distance_mat, 2, 'criterion', 'strain');
MDS = mdscale(distance_mat, 2);
scatter(MDS(:, 1), MDS(:, 2), params.circle_size, color_scale, '.')

%%
text(MDS(:, 1)+dx, MDS(:, 2)+dy, phoneme_names, 'FontWeight', 'bold', 'FontSize', params.font_size);
% title(title, 'FontSize', 14, 'FontWeight', 'bold')
set(gca, 'FontSize', 20)
set(gca, 'FontSize', 20)
set(h2, 'Color', [1 1 1])
set(h2, 'units','normalized','outerposition',[0 0 1 1])
set(h2, 'PaperPositionMode','auto') 
% add color labels

% num_place_features = length(Features);
if color_feature > 0
    cmap = colormap;
    IX = round(linspace(1,64,max_value_feature));
    for f = 1:max_value_feature
        text(3,2-f*0.2, Features{f}, 'Color', cmap(IX(f), :), 'FontWeight', 'bold', 'FontSize', 20)
    end
    axis equal
end

%% MDS
% h1 = figure();
% MDS = mdscale(distance_mat, 3);
% scatter3(MDS(:, 1), MDS(:, 2), MDS(:, 3), 50, c, '.')
% dx = 0.1; dy = 0.1; dz = 0.1; % displacement so the text does not overlay the data points
% text(MDS(:, 1)+dx, MDS(:, 2)+dy, MDS(:, 3) + dz, settings.phonemes, 'FontWeight', 'bold');
% set(h1, 'Color', [1 1 1])

end