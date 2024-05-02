function [lines, text, C_Matrices, weightedAccuracies] = readtext(x, fileID, Mdl_1, Mdl_2, Mdl_3, ...
  N1, N2, N3, height_letters_training, width_letters_training)

    %Find rotation angle and rotate the image accordingly
    angle = findRotationAngle(x);
    img_rotated = rotateImage(x, angle);
    
    %Extract the letters from the text image alongside some useful
    %information about the dimensions of the test set letters' dimensions
    [letters_data, words_per_line, letters_per_word, ~, ~, mean_height] = lettersExtraction(img_rotated);

    %Store the predicted characters in raw form (without word and line
    %separations)
    text = cell(0);
    [g_1, g_2, g_3] = deal(1);
    [test_predictions_1, test_predictions_2, test_predictions_3] = deal(cell(0));

    %Make the predictions for each contour class
    for i=1:length(letters_data)
        temp = letters_data(i);
        c = getcontour(temp{1}, height_letters_training, width_letters_training, mean_height);

        switch size(c, 2)
            case 1

                R_temp = contourDescriptors(temp, N1, height_letters_training, width_letters_training, mean_height); 
                R_temp = cell2mat(R_temp');
                letter_temp = predict(Mdl_1,R_temp);
                test_predictions_1{g_1} = letter_temp{1};
                g_1 = g_1 + 1;
            case 2
                R_temp = contourDescriptors(temp, N2, height_letters_training, width_letters_training, mean_height); 
                R_temp = cell2mat(R_temp');
                letter_temp = predict(Mdl_2,R_temp);
                test_predictions_2{g_2} = letter_temp{1};
                g_2 = g_2 + 1;

            case 3
                R_temp = contourDescriptors(temp, N3, height_letters_training, width_letters_training, mean_height); 
                R_temp = cell2mat(R_temp');
                letter_temp = predict(Mdl_3,R_temp);
                test_predictions_3{g_3} = letter_temp{1};
                g_3 = g_3 + 1;

        end

        text = [text letter_temp];
    end
    
    %Store the predicted text in readible form
    lines= {};
    g = 1;
    d = 0;
    %For each line
    for i = 1:length(words_per_line) % i : line
        line= [];
        for k=1:words_per_line(i) % k : word in a line
            for j = 1:letters_per_word(k + d) % k : letters in a word in a line
                line = [line, text{g}];
                g = g + 1;
            end
            if k == words_per_line(i)
                continue;
            end
            line = [line, ' '];
        end
        d = d + words_per_line(i);
        lines{i} = line;
    end





    %Scan the txt file to label the predicted letters with the actual ones
    %for evaluation of the prediction
    contents= textscan(fileID, '%c');

    dataset = cell(0);
    for i=1:length(letters_data) 
        dataset{i, 1} = letters_data{i};
        dataset{i, 2} = contents{1}(i);
    end
    
    [c_1_test, c_2_test, c_3_test] = splittingDataContours(dataset, height_letters_training, width_letters_training, mean_height);
    
    %Confusion Matrices
    C_1 = confusionmat(c_1_test(:, 2), test_predictions_1');
    
    C_2 = confusionmat(c_2_test(:, 2), test_predictions_2');
    
    C_3 = confusionmat(c_3_test(:, 2), test_predictions_3');
    
    %Weighted Accuracies
    classAccuracies_1 = diag(C_1) ./ sum(C_1, 2);
    classWeights_1 = sum(C_1, 1) / sum(C_1, 'all');
    classAccuracies_1(isnan(classAccuracies_1)) = 0;
    classWeights_1(isnan(classWeights_1)) = 0;
    weightedAccuracy_1 = sum(classAccuracies_1 .* classWeights_1');
    
    classAccuracies_2 = diag(C_2) ./ sum(C_2, 2);
    classWeights_2 = sum(C_2, 1) / sum(C_2, 'all');
    classAccuracies_2(isnan(classAccuracies_2)) = 0;
    classWeights_2(isnan(classWeights_2)) = 0;
    weightedAccuracy_2 = sum(classAccuracies_2 .* classWeights_2');
    
    classAccuracies_3 = diag(C_3) ./ sum(C_3, 2);
    classWeights_3 = sum(C_3, 1) / sum(C_3, 'all');
    classAccuracies_3(isnan(classAccuracies_3)) = 0;
    classWeights_3(isnan(classWeights_3)) = 0;
    weightedAccuracy_3 = sum(classAccuracies_3 .* classWeights_3');
    
    C_Matrices = {C_1, C_2, C_3};
    weightedAccuracies= [weightedAccuracy_1 ; weightedAccuracy_2 ; weightedAccuracy_3 ];

end