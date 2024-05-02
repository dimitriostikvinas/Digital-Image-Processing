function matchingPoints = descriptorMatching(...
    features_1, features_2, percentageThreshold)
    
    possible_pairs = zeros(size(features_1, 2), size(features_2, 2));
    matchingPoints = [];

    for i=1:size(features_1, 2)
        for j=1:size(features_2, 2)
            possible_pairs(i, j) = norm(features_1(:, i) - features_2(:, j));
        end
    end
    
    num_possible_pairs = numel(possible_pairs);

    k = 1;
    while(1)
        if( size(matchingPoints, 1) < ceil(num_possible_pairs * percentageThreshold) )
            [x, y] = find(possible_pairs == min(possible_pairs(k, :)));
            k = k + 1;
            possible_pairs(x, y) = Inf;
            matchingPoints = [matchingPoints ; [x, y]];
            if k == size(possible_pairs, 1) + 1
                k = 1;
            end
        else
            matchingPoints = matchingPoints';
            return
        end
    end
    
    
end

