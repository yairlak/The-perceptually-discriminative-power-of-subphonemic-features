function  partsDivision = randomDivideToPartsEqualPositive(num_samples ,numberOfParts, labels)

    if(length(labels) ~= num_samples)
        error('randDivideEqual:sizeMisMatch','the number of samples and the labels vector length should be the same');
    end
    
    partsDivision = NaN(num_samples,numberOfParts);
    
    positiveSetSize = sum(labels);
    positiveDivision = randomDivideToParts(positiveSetSize ,numberOfParts);
    
    negativeSetSize = length(labels) - sum(labels);
    negativeDivision = randomDivideToParts(negativeSetSize ,numberOfParts);
    
    partsDivision(labels,:) = positiveDivision;
    partsDivision(~labels,:) = negativeDivision;
    partsDivision = logical(partsDivision);
end