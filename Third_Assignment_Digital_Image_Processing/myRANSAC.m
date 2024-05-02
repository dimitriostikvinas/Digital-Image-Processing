%function [H, inlierMatchingPoints, outlierMatchingPoints] = myRANSAC(matchingPoints, edges_1, edges_2, r, N)
function H = myRANSAC(matchingPoints, edges_1, edges_2)
    % for i=1:N
        
        indices = randperm(size(matchingPoints, 2), 3); % randomly select two pairs from matchingPoints
        points1_indices = matchingPoints(:, indices(1));% first pair pointer
        points2_indices = matchingPoints(:, indices(2));% second pair pointer
        
        
        points1 = [edges_1(points1_indices(1), :) ; edges_2(points1_indices(2), :)]; %first pair
        points2 = [edges_1(points2_indices(1), :) ; edges_2(points2_indices(2), :)]; %second pair
        
        disp(points1)
        disp(points2)
        
        H = findHomography(points1, points2);
        
        % new_points = [];
        % for i=1:size(edges_1, 1)
        %     new_points = [ new_points ; round(H{1}*[edges_1(i, 1) ; edges_1(i, 2)] + H{2})'];
        % end
        % 
        % EuclideanDistance = norm(new_points - edges_2);
       
    % end


end