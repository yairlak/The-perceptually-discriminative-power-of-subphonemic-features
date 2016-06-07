function [dataset_1, dataset_2, tags_1, tags_2] = set_both_sets_same_size(dataset_1, dataset_2, tags_1, tags_2);

for i = 1:length(tags_1)
    IndexC = strfind(tags_2, tags_1{i});
    Index = sum(not(cellfun('isempty', IndexC))); 
    if Index == 0
        IX(i) = true;
    else
        IX(i) = false;
    end
end
tags_1(IX) = [];
dataset_1(IX) = [];
clear IX

for i = 1:length(tags_2)
    IndexC = strfind(tags_1, tags_2{i});
    Index = sum(not(cellfun('isempty', IndexC))); 
    if Index == 0
        IX(i) = true;
    else
        IX(i) = false;
    end
end
tags_2(IX) = [];
dataset_2(IX) = [];

end
