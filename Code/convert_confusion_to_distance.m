function distance_mat = convert_confusion_to_distance(similarity_mat)

%% Similarity to Perceived Distance
distance_mat = -log(similarity_mat);

%% if Infinite or negative distance
distance_mat(isinf(distance_mat)) = -999;
maxValue = max(max(distance_mat));
distance_mat(distance_mat == -999) = maxValue;
IX = distance_mat < 0;
distance_mat(IX) = 0;

%if any(any(distance_mat < 0)); error('Negative distance values'); end

end