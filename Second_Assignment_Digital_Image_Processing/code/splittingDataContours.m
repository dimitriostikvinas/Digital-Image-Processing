function [c_1, c_2, c_3] = splittingDataContours(data, height_letters_training, width_letters_training, mean_height) 
    %we use this function to split the data according to the number of
    %contours each element/letter has
    [c_1, c_2, c_3] = deal(cell(0));
    j = 1;
    g = 1;
    l = 1;
    for i=1:length(data)
        c = getcontour(data{i, 1}, height_letters_training, width_letters_training, mean_height);
        switch (length(c))
            case  1

                c_1{j, 1} = data{i, 1};
                c_1{j, 2} = data{i, 2};
                j = j + 1;
                continue;

            case 2

                c_2{g, 1} = data{i, 1};
                c_2{g, 2} = data{i, 2};
                g = g + 1;
                continue;

            case 3

                c_3{l, 1} = data{i, 1};
                c_3{l, 2} = data{i, 2};
                l = l + 1;
                continue;
        end
    end
end