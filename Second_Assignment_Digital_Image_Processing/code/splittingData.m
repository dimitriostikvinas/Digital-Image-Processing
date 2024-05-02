function [dataTrain, dataTest] = splittingData(letters_dataset, percentage)
    % we use this function to split the letters dataset 

    %cross validation partition (train : 70%, test 30 %)
    cv = cvpartition(length(letters_dataset),'HoldOut', 1- percentage);
    
    idx = cv.test;
    dataTest = cell(0);
    dataTrain = cell(0);
    % Separate to training and test data
    j = 1;
    g = 1;
    for i = 1:length(idx)
        if idx(i)
            dataTest{j, 1}  = letters_dataset{j, 1};
            dataTest{j, 2}  = letters_dataset{j, 2};
            j = j + 1;
        else 
            dataTrain{g, 1} = letters_dataset{g, 1};
            dataTrain{g, 2} = letters_dataset{g, 2};
            g = g + 1;
        end
    end
end