function [train_samples, test_samples, train_labels, test_labels] = ...
             splitTrainTest(params, settings, samples, labels)

%%        
rng(params.seed_split)

%%
partsDivision = randomDivideToParts(size(samples, 1), ...
                                    settings.crossValidationKfold);

%%
test_pointers  = partsDivision(:, params.split);
train_pointers = ~test_pointers;

%% Split data
train_samples = samples(train_pointers, :);
test_samples  = samples(test_pointers, :);

train_labels   = labels(train_pointers, :);
test_labels    = labels(test_pointers, :);

end