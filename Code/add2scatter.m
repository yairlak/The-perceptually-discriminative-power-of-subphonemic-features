function add2scatter(dataset_1, dataset_2, tags, clr, sz)
% scatter(dataset_1, dataset_2, 0.01)

for i = 1:max(length(dataset_1), length(dataset_2))
    text(dataset_1(i), dataset_2(i), tags(i), 'FontSize', sz, 'Color', clr)
end

end