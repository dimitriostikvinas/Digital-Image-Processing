function [Mdl_1, Mdl_2, Mdl_3, weightedAccuracies_validation, ...
   weightedAccuracies_train, C_Matrices_validation, C_Matrices_train, height_letters_training...
   , width_letters_training] = KNNClassifiers(img, fileID, N1, N2, N3, K1, K2, K3)

    %Find rotation angle and rotate the image accordingly
    angle = findRotationAngle(img);
    img_rotated = rotateImage(img, angle);
    
    %Extract the letters from the text image alongside some useful
    %information about the dimensions of the train set letters' dimensions
    [letters_data, ~, ~, height_letters_training, width_letters_training, mean_height_training] = lettersExtraction(img_rotated);
    
    %Scan the txt file of the train set to label the letters' images with
    %the corresponding characters
    contents= textscan(fileID, '%c');
    
    %Creating a dataset
    dataset = cell(0);
    for i=1:length(letters_data) 
        dataset{i, 1} = letters_data{i};
        dataset{i, 2} = contents{1}(i);
    end
    
    %Splitting the dataset in train and validation set
    [dataTrain, datavalidation] = splittingData(dataset, 0.7);
    
    
    %% Splitting each element of the dataset according the number of contours it possesses
    
    [c_1_data_train, c_2_data_train, c_3_data_train] = splittingDataContours(dataTrain , height_letters_training, width_letters_training, mean_height_training);
    
    [c_1_data_validation, c_2_data_validation, c_3_data_validation] = splittingDataContours(datavalidation , height_letters_training, width_letters_training, mean_height_training);
    
    %% Contour Descriptor
    R_datavalidation_1 = contourDescriptors(c_1_data_validation, N1 , height_letters_training, width_letters_training, mean_height_training);
    R_dataTrain_1 = contourDescriptors(c_1_data_train, N1 , height_letters_training, width_letters_training, mean_height_training);
    
    R_datavalidation_2 = contourDescriptors(c_2_data_validation, N2 ,  height_letters_training, width_letters_training, mean_height_training);
    R_dataTrain_2 = contourDescriptors(c_2_data_train, N2 ,  height_letters_training, width_letters_training, mean_height_training);
    
    R_datavalidation_3 =  contourDescriptors(c_3_data_validation, N3 ,  height_letters_training, width_letters_training, mean_height_training);
    R_dataTrain_3 =  contourDescriptors(c_3_data_train, N3 ,  height_letters_training, width_letters_training, mean_height_training);
    
    %% Classifiers for each category
    R_dataTrain_1 = cell2mat(R_dataTrain_1');
    Mdl_1 = fitcknn(R_dataTrain_1, c_1_data_train(:, 2), "NumNeighbors", K1, "Distance", "euclidean");%46
    
    
    R_dataTrain_2 = cell2mat(R_dataTrain_2');
    Mdl_2 = fitcknn(R_dataTrain_2, c_2_data_train(:, 2),"NumNeighbors",K2, "Distance", "euclidean");
    
    
    R_dataTrain_3 = cell2mat(R_dataTrain_3');
    Mdl_3 = fitcknn(R_dataTrain_3, c_3_data_train(:, 2), "NumNeighbors",K3, "Distance", "euclidean");
    
     %% Predictions on the validation set
    R_datavalidation_1 = cell2mat(R_datavalidation_1');
    validation_predictions_1 = predict(Mdl_1, R_datavalidation_1);
    train_predictions_1 = predict(Mdl_1, R_dataTrain_1);

    R_datavalidation_2 = cell2mat(R_datavalidation_2');
    validation_predictions_2 = predict(Mdl_2, R_datavalidation_2);
    train_predictions_2 = predict(Mdl_2, R_dataTrain_2);

    R_datavalidation_3 = cell2mat(R_datavalidation_3');
    validation_predictions_3 = predict(Mdl_3, R_datavalidation_3);
    train_predictions_3 = predict(Mdl_3, R_dataTrain_3);

    %% Metrics
    
    %Confusion Matrices for each category
    
    C_1_validation = confusionmat(c_1_data_validation(:, 2), validation_predictions_1);
    
    C_2_validation = confusionmat(c_2_data_validation(:, 2), validation_predictions_2);
    
    C_3_validation = confusionmat(c_3_data_validation(:, 2), validation_predictions_3);
    
    C_1_train = confusionmat(c_1_data_train(:, 2), train_predictions_1);
    
    C_2_train = confusionmat(c_2_data_train(:, 2), train_predictions_2);
    
    C_3_train = confusionmat(c_3_data_train(:, 2), train_predictions_3);

    %Weighted Accuracy for each category
    
    
    classAccuracies_1_validation = diag(C_1_validation) ./ sum(C_1_validation, 2);
    classWeights_1_validation = sum(C_1_validation, 1) / sum(C_1_validation, 'all');
    classAccuracies_1_validation(isnan(classAccuracies_1_validation)) = 0;
    classWeights_1_validation(isnan(classWeights_1_validation)) = 0;
    weightedAccuracy_1_validation = sum(classAccuracies_1_validation .* classWeights_1_validation');
    
    classAccuracies_2_validation = diag(C_2_validation) ./ sum(C_2_validation, 2);
    classWeights_2_validation = sum(C_2_validation, 1) / sum(C_2_validation, 'all');
    classAccuracies_2_validation(isnan(classAccuracies_2_validation)) = 0;
    classWeights_2_validation(isnan(classWeights_2_validation)) = 0;
    weightedAccuracy_2_validation = sum(classAccuracies_2_validation .* classWeights_2_validation');
    
    classAccuracies_3_validation = diag(C_3_validation) ./ sum(C_3_validation, 2);
    classWeights_3_validation = sum(C_3_validation, 1) / sum(C_3_validation, 'all');
    classAccuracies_3_validation(isnan(classAccuracies_3_validation)) = 0;
    classWeights_3_validation(isnan(classWeights_3_validation)) = 0;
    weightedAccuracy_3_validation = sum(classAccuracies_3_validation .* classWeights_3_validation');

    classAccuracies_1_train = diag(C_1_train) ./ sum(C_1_train, 2);
    classWeights_1_train = sum(C_1_train, 1) / sum(C_1_train, 'all');
    classAccuracies_1_train(isnan(classAccuracies_1_train)) = 0;
    classWeights_1_train(isnan(classWeights_1_train)) = 0;
    weightedAccuracy_1_train = sum(classAccuracies_1_train .* classWeights_1_train');
    
    classAccuracies_2_train = diag(C_2_train) ./ sum(C_2_train, 2);
    classWeights_2_train = sum(C_2_train, 1) / sum(C_2_train, 'all');
    classAccuracies_2_train(isnan(classAccuracies_2_train)) = 0;
    classWeights_2_train(isnan(classWeights_2_train)) = 0;
    weightedAccuracy_2_train = sum(classAccuracies_2_train .* classWeights_2_train');
    
    classAccuracies_3_train = diag(C_3_train) ./ sum(C_3_train, 2);
    classWeights_3_train = sum(C_3_train, 1) / sum(C_3_train, 'all');
    classAccuracies_3_train(isnan(classAccuracies_3_train)) = 0;
    classWeights_3_train(isnan(classWeights_3_train)) = 0;
    weightedAccuracy_3_train = sum(classAccuracies_3_train .* classWeights_3_train');

    weightedAccuracies_validation = [weightedAccuracy_1_validation ; weightedAccuracy_2_validation ; weightedAccuracy_3_validation ];
    weightedAccuracies_train = [weightedAccuracy_1_train ; weightedAccuracy_2_train ; weightedAccuracy_3_train ];

    C_Matrices_validation = {C_1_validation, C_2_validation, C_3_validation};
    C_Matrices_train = {C_1_train, C_2_train, C_3_train};
end
