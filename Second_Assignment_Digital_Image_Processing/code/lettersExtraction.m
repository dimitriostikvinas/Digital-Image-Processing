function [dataset, words_per_line, letters_per_word, height_letters, ...
    width_letters, mean_height] = lettersExtraction(rotated_img)
% Inputs:
%     -rotated_img : the text image after the rotation restoration
% Outputs:
%     -dataset : the letters extracted from the rotated_img, formed as a dataset
%     -words_per_line : array containing the number of words per line
%     -letters_per_word : array containing the number of letters per word
%     -height_letters : array containing the heights of each letter
%     -width_letters : array containing the width of each letter
%     -mean_height : the mean of the letter's heights



    %Converting the input image with fixed rotation to grayscale
    rotated_img = rgb2gray(rotated_img);

    %Taking the complement in order to have the rows and columns containing
    %content as brightness positive projections
    rotated_img = imcomplement(rotated_img);
    
    %Chosen arbitrarily to fit in the given training and test images
    strel_size = 8;

    %% Distinguishing the lines of the text image
    %Computing the horizontal projection of brightness
    proj_hor = sum(rotated_img, 2); 

    %Finding where the horizontal projections are 0. These rows combined into 
    %consistent groups will be the spaces above and below the text lines
    zero_spaces_between_lines = find(proj_hor == 0); 

    %Separating the text lines using the zero horizontal projections as
    %bordelines and storing each one in a cell array
    lines = cell(0);
    g = 1;
    for i=1:size(zero_spaces_between_lines, 1) 

        if i == 1 && zero_spaces_between_lines(i) ~= 1
            lines{g} = rotated_img(1:zero_spaces_between_lines(i+1), :);

            g = g + 1;

        elseif i == size(zero_spaces_between_lines, 1) 

            if zero_spaces_between_lines(i) ~= size(rotated_img, 1)
                lines{g} = rotated_img(zero_spaces_between_lines(i):end, :);
                g = g + 1;
            else
                continue;
            end

        elseif zero_spaces_between_lines(i) + 1 ~= zero_spaces_between_lines(i+1) 
            lines{g} = rotated_img(zero_spaces_between_lines(i):zero_spaces_between_lines(i+1), :);
            g = g + 1;

        end
    end
    words_per_line = [];
    %% Distinguishing the words of the text image 
    words = cell(0);
    wo = 1;

    for i=1:size(lines, 2)  
        wpl = 0;
        line_opened = imclose(lines{i}, strel('disk', strel_size));
        %Computing the vertical projection of brightness for each line
        proj_ver_line = sum(line_opened, 1);

        %Finding where the vertical projections are 0. These columns combined into 
        %consistent groups will be the spaces between the line's words
        zero_spaces_between_words = find(proj_ver_line == 0); 
        
        %Separating the words of each line using the zero vertical projections as
        %bordelines and storing each one in a cell array
        for j=1:size(zero_spaces_between_words, 2) 
            set = 0;
            if j == 1 && zero_spaces_between_words(j) ~=1
                word_temp = lines{i}(:, 1:zero_spaces_between_words(j+1));
                set = 1;
            elseif j == size(zero_spaces_between_words, 2)
                if zero_spaces_between_words(j) ~= size(lines{i}, 2)
                    word_temp = lines{i}(:, zero_spaces_between_words(j):end);
                    set = 1;
                else 
                    continue;
                end

            elseif zero_spaces_between_words(j) + 1 ~= zero_spaces_between_words(j+1) 
                word_temp = lines{i}(:, zero_spaces_between_words(j):zero_spaces_between_words(j+1));
                set = 1;
            end
            
            if set == 1 
                words{wo} = word_temp;
                wo = wo + 1;
                wpl = wpl + 1;
                words_per_line(i) = wpl; 
            end
        end
    end
    
%% Distinguishing the letters of the text image 
letters_per_word = [];
letters = cell(0);
g = 1;
for i=1:size(words, 2)
    lpw = 0;
    word_temp = imbinarize(words{i});
    %Computing the vertical projection of brightness of each word
    proj_ver_word = sum(word_temp, 1);
    
    %Finding where the vertical projections are 0. These columns combined into 
    %consistent groups will be the spaces between the word's letters
    zero_spaces_between_letters = find(proj_ver_word == 0); 
    

    for j=1:size(zero_spaces_between_letters, 2)
        set = 0;
        if j == 1 && zero_spaces_between_letters(j) ~= 1
            letters_temp = words{i}(:, 1: zero_spaces_between_letters(j)+1 );
            set = 1;

        elseif j == size(zero_spaces_between_letters, 2) 
            if zero_spaces_between_letters(j) ~= size(words{i}, 2)
                letters_temp = words{i}(:, zero_spaces_between_letters(j)-1 : end);
                set = 1;
            else
                break;
            end
        elseif zero_spaces_between_letters(j) + 1 ~= zero_spaces_between_letters(j+1) 
            letters_temp = words{i}(:, zero_spaces_between_letters(j): zero_spaces_between_letters(j+1));
            set = 1;

        end
     
        if set == 1 
            letters{g} = letters_temp;
            g = g + 1;
            lpw = lpw + 1;
            letters_per_word(i) = lpw;
        end
    end
end
  
    [height_letters, width_letters] = deal(zeros(length(letters), 1));
    dataset = cell(0);

    for i=1:length(letters)
        dataset{i} = imcomplement(letters{i});
        height_letters(i) = size(letters{i}, 1);
        width_letters(i) = size(letters{i}, 2);
    end
    mean_height = ceil(mean(height_letters));

end