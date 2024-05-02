 function [best_angle_degrees, spectrum] = findRotationAngle(x)

    %Turning it into grayscale
    img = im2gray(x);

    %We apply the Gaussian 2-D Filter in order to add noise in our image,
    %hence blur it in order to fuse the letters of each line together
    blur_kernel = fspecial('gaussian', [10 10], 10);
    img = imfilter(img, blur_kernel);
      
    %Computing the 2D DFT of the input image
    dft = fft2(img);

    %Removing the DC compoment offset before shifting it
    dft(1, 1) = 0;
    
    %Shifting the zero-frequency component to the center of the array
    dft_shifted = fftshift(dft);  
   
    %Computing the logarithm of the absolute value of the shifted DFT
    spectrum = 10 * log(1 + abs(dft_shifted));
    
    %Finding the maximum frequence in the spectrum
    peak = max(spectrum(:));
    
    % Extract coordinates from spectrum having values above the threshold
    [rows, cols] = find(spectrum > 0.97 * peak );
    
    %From those extracted we take the bordeline coordinates
    max_col = max(cols);
    max_row = max(rows);
    min_col = min(cols);
    min_row = min(rows);
    
    %Taking the differences in each dimension in order to find the line's
    %angle
    dy = max_col - min_col;
    dx = max_row - min_row;
    
    %Using the arctan we obtain our first estimation of the image's
    %rotation in rad using only DFT
    theta = atan(dy/dx);

    %We turn the rad into degrees
    theta_degrees = rad2deg(theta);

    
    %Beginning serial search for precise angle calculation
    best_angle_degrees = theta_degrees;
    max_diff = 0;
    
    %The range around the first angle's approximation in which we will
    %search
    angleRange = -1:0.02:1; 

    for angle = angleRange + theta_degrees
        % Undo rotation
        imgRot = imrotate(x, -angle, 'bilinear');
        
        % Calculate projection of brightness in horizontal axis
        proj = sum(imgRot, 2);
        
        % Calculate differences in brightness between adjacent rows
        diff = abs(proj(2:end) - proj(1:end-1));

        % Find maximum brightness difference
        diffMax = max(diff);

        % Update best angle and maximum difference if current angle is better
        if diffMax > max_diff
            best_angle_degrees = angle;
            max_diff = diffMax;
        end
    end
 end