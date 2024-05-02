 function rotated_img = rotateImage(x, angle_degrees)
    

    angle_rad = deg2rad(angle_degrees);
    %Height and width of the original image
    [height, width, ~] = size(x);
    
    %Calculating the height and width of the rotated image we are about to
    %produce
    new_height = floor(abs(height*cos(angle_rad)) + abs(width*sin(angle_rad)));
    new_width = floor(abs(width*cos(angle_rad)) + abs(height*sin(angle_rad)));

    %Initialize the rotated image as a full white one with the new declared
    %dimensions
    rotated_img = 255*ones(new_height, new_width);

    %center of the original image, used to as reference for the below
    %mapping algorithm
    center = ceil([width, height])/2;
    
    %We use the below mapping to form the pixels of the generated image
    %based on the original image.
    for y=1:new_height %height of resized image
        for x=1:new_width % width of resized image
            x_rotated =ceil(center(1) + (x - center(1)) * cos(-angle_rad) + (y - center(2)) * sin(-angle_rad));
            y_rotated =ceil(center(2) + (x - center(1)) * sin(-angle_rad) + (y - center(2)) * cos(-angle_rad));
            if x_rotated >= 1 && x_rotated <= width && y_rotated >= 1 && y_rotated <= height
                rotated_img(y, x, :) = x(y_rotated, x_rotated, :);
            else
                rotated_img(y, x) = 0; %if we get out-of-bounds of the original image
                %we set the pixel as black by default
            end
        end
    end
 end