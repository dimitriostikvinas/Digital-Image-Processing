function  p_new = NewPixelCoordinatesAfterRotation(I_original,p,theta)

    [width,height] = size(I_original);
    
    %Original Image center coordinates
    old_center = floor([width, height])/2;

    %We want the counterclockwise rotation angle to calculate the new
    %pixel's coordinates
    theta_rad = deg2rad(theta);
    
    %Calculating the height and width of the rotated image 
    new_height = floor(abs(height*cos(theta_rad)) + abs(width*sin(theta_rad)));
    new_width = floor(abs(width*cos(theta_rad)) + abs(height*sin(theta_rad)));

    % Rotated Image center coordinates 
    new_center = floor([new_width, new_height])/2;

    %Previous pixel's coordinates
    x_old = p(1);
    y_old = p(2);

    x_r =floor(new_center(1) + (x_old - old_center(1)) * cos(theta_rad) - (y_old - old_center(2)) * sin(theta_rad));
    y_r =floor(new_center(2) + (x_old - old_center(1)) * sin(theta_rad) + (y_old - old_center(2)) * cos(theta_rad));

    %New pixel's coordinates after rotation
    p_new = [x_r, y_r];
end