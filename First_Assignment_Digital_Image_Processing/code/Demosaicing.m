function Ccam = Demosaicing(rawim, bayertype, method, M, N)

    %In this function we design the Demosaicing step of the workflow
    %using either the algorithm of the nearest neighbors
    % or of the linear interpolation

    %height and width of the picture
    [height, width] = size(rawim);

    %we create the Bayer Pattern defined in 'bayertype', based on the
    %Figure.8 at the report
    switch(bayertype)
        case 'BGGR'
            bayer_red = [0 0 ; 0 1];
            bayer_blue = [1 0 ; 0 0];
            bayer_green = [0 1 ; 1 0];
        case 'GBRG'
            bayer_red = [0 0 ; 1 0];
            bayer_blue = [0 1 ; 0 0];
            bayer_green = [1 0 ; 0 1];
        case 'GRBG'
            bayer_red = [0 1 ; 0 0];
            bayer_blue = [0 0 ; 1 0];
            bayer_green = [1 0 ; 0 1];
        case 'RGGB'
            bayer_red = [1 0 ; 0 0];
            bayer_blue = [0 0 ; 0 1];
            bayer_green = [0 1 ; 1 0];
    end

    %Creating CFA filter for each of the three colours based on the chosen 
    %Bayer Pattern 
    bayer_mask_red = repmat(bayer_red, ceil(size(rawim)/2));
    bayer_mask_blue = repmat(bayer_blue, ceil(size(rawim)/2));
    bayer_mask_green = repmat(bayer_green, ceil(size(rawim)/2));

    %we will shorten by cutting off the extra pixels at the edges of the 
    % filter to match the size of the image
    if(mod(width,2)==1)
       bayer_mask_red(size(bayer_mask__red,1),:)=[];
       bayer_mask_blue(size(bayer_mask_blue,1),:)=[];
       bayer_mask_green(size(bayer_mask_green,1),:)=[];
    end
    if(mod(height,2)==1)
       bayer_mask_red(:,size(bayer_mask_red,2))=[];
       bayer_mask_blue(:,size(bayer_mask_blue,2))=[];
       bayer_mask_green(:,size(bayer_mask_green,2))=[];
    end

    %using the Bayer filter as a mask to extract the R, G, B channel values of the
    %image and store them into images containing only the mentioned color 
    %by multiplying elementwise with the RAW input image
    red_rawim = rawim .* bayer_mask_red;
    blue_rawim = rawim .* bayer_mask_blue;
    green_rawim = rawim .* bayer_mask_green;
    
    
    %Nearest_Neighbors
    if method == "nearest"
        
        %we change the indices according to the 'bayertype' Bayer Filter
        %used. This process captures the non-vero values of the
        %(color)_rawim matrices into consistent matrices to be fed in the
        %Ccam matrix
        switch(bayertype)

            case 'BGGR'
                red = red_rawim(floor((0: height-1)/2) *2+2 , floor((0: width-1)/2) *2+2) ;
                green(floor((0: height-1)/2)*2+1 , :) = ...
                    green_rawim(floor((0: height-1)/2) *2+1 , floor((0: width-1)/2) *2+2) ;
                green( floor((0: height-1)/2) *2+2 , :) = ...
                    green_rawim( floor((0: height-1)/2) *2+2 , floor((0: width-1)/2) *2+1) ;
                blue = blue_rawim(floor((0: height-1)/2)*2+1 , floor((0: width-1)/2)*2+1) ;

            case 'GBRG'
                red = red_rawim(floor((0: height-1)/2) *2+2 , floor((0: width-1)/2) *2+1) ;
                green(floor((0: height-1)/2)*2+1 , :) = ...
                    green_rawim(floor((0: height-1)/2) *2+1 , floor((0: width-1)/2) *2+1) ;
                green( floor((0: height-1)/2) *2+2 , :) = ...
                    green_rawim( floor((0: height-1)/2) *2+2 , floor((0: width-1)/2) *2+2) ;
                blue = blue_rawim(floor((0: height-1)/2)*2+1 , floor((0: width-1)/2)*2+2) ;

            case 'GRBG'
                red = red_rawim(floor((0: height-1)/2) *2+1 , floor((0: width-1)/2) *2+2) ;
                green(floor((0: height-1)/2)*2+1 , :) = ...
                    green_rawim(floor((0: height-1)/2) *2+1 , floor((0: width-1)/2) *2+1) ;
                green( floor((0: height-1)/2) *2+2 , :) = ...
                    green_rawim( floor((0: height-1)/2) *2+2 , floor((0: width-1)/2) *2+2) ;
                blue = blue_rawim(floor((0: height-1)/2)*2+2 , floor((0: width-1)/2)*2+1) ;

            case 'RGGB'
                red = red_rawim(floor((0: height-1)/2)*2+1 , floor((0: width-1)/2)*2+1) ;
                green(floor((0: height-1)/2)*2+1 , :) = ...
                    green_rawim(floor((0: height-1)/2) *2+1 , floor((0: width-1)/2) *2+2) ;
                green( floor((0: height-1)/2) *2+2 , :) = ...
                    green_rawim( floor((0: height-1)/2) *2+2 , floor((0: width-1)/2) *2+1) ;
                blue = blue_rawim( floor((0: height-1)/2) *2+2 , floor((0: width-1)/2) *2+2) ;
        end
        

        %Image Resize using Nearest Neighbors Interpolation
        
        %The new matrices containing each color's values, with
        %sizes defined by the user through the variables M, N
        [red_resized, green_resized, blue_resized] = deal(zeros(M, N));
        
        %The scale factors of the original and the resized image
        x_factor = (N - 1) ./ (width - 1);
        y_factor = (M - 1) ./ (height - 1);
        
        %Resize inverse transformation matrix
        matrix = [x_factor 0; 0 y_factor]^(-1);

        for y = 0 : M - 1 %height of resized image -1
            for x = 0 : N - 1% width of resized image -1
                %using the inverse transformation matrix to map the new
                %coordinates (x, y) to (v_p(1,:), v_p(2, :)) of the initial
                %image
                v_p = matrix * [x; y];
    
                %change the coordinates (v_p(1,:), v_p(2, :)) from 0 to n-1 
                %to 0 to n in order to apply interpolation
                v_p(1, :) = v_p(1, :) + 1;
                v_p(2, :) = v_p(2, :) + 1;
                
                %calculate nearest neighbor
                v1 = round(v_p(1, :));
                v2 = round(v_p(2, :));
                
                %calculate color's value at the resized image based on 
                %the original image through mapping
                x_int = x + 1;
                y_int = y + 1;
                red_resized(y_int, x_int) = red(v2, v1);
                green_resized(y_int, x_int) = green(v2, v1);
                blue_resized(y_int, x_int) = blue(v2, v1);

            end
        end
        



    %Bilinear Interpolation
    elseif method == "linear"
        
        
        %we use two bilinear interpolation matrices and perform 
        %convolution with each channel's matrix produced by the Bayer
        %Filter
        red= conv2 (red_rawim , [1 2 1; 2 4 2; 1 2 1]/4 , 'same') ;
        green = conv2 (green_rawim , [0 1 0; 1 4 1; 0 1 0]/4 , 'same') ;
        blue = conv2 (blue_rawim , [1 2 1; 2 4 2; 1 2 1]/4 , 'same') ;
        
        %'rawim' is a 2-D array
        %'M' and 'N' are the desired spatial dimension of the new 2-D array.

        %The new matrices containing each color's values, with
        %sizes defined by the user through the variables M, N
        [red_resized, green_resized, blue_resized] = deal(zeros(M, N));
        
        %The scale factors of the original and the resized image
        if width > 1 && height > 1
            w_ratio = (width) / (N); 
            h_ratio = (height) / (M);
        else
            w_ratio = 0;
            h_ratio = 0;
        end
        
        
        pixel = zeros(3,1);

        %because the following process is quite heavy (O(n^2)), we use this piece of
        %code to know at certain moments in which iteration our algorithm
        %is 
        tic
        for i =1:M %height of resized image
            if toc > 1
             fprintf('%0.2f %% \n', (i/M) * 100)
             tic
            end
            for j =1:N % width of resized image
                %we will execute 2-D Bilinear Interpolations between 4
                %points each iteration, using 3 times 1-D Bilienar Interpolation, 2 times
                %in the width dimension and then 1 time in the height
                %dimension, and the result will be stored in the pixel
                %matrix for each color channel
                x_l = floor(w_ratio * j);
                y_l = floor(h_ratio * i);

                x_h = ceil(w_ratio * j);
                y_h = ceil(h_ratio * i);
                
                %limit the y coordinates of the points in [1, height] range
                if y_l < 1
                    y_l = 1;
                elseif y_l > height 
                    y_l = hright;
                end
           
                if y_h > height
                    y_h = height;
                elseif y_h < 1 
                    y_h = 1;
                end

                %limit the x coordinates of the points in [1, width] range
                if x_l < 1 
                    x_l = 1; 
                elseif x_l > width
                    x_l = width;
                end

                if x_h > width
                    x_h = width;
                elseif x_h < 1
                    x_h = 1;
                end
                
                
                %weighted average of the values associated with the two points,
                %where the weights are proportional to the distance
                x_weight = x_h - x_l;
                y_weight = y_h - y_l;
                
                %the coordinates of the four points that are closest to [i, j] 
                % are [y_l, x_l], [y_l, x_h], [y_h, x_l], [y_h, x_h], so we
                %store the color value of each channel to the a, b, c, d matrices
                %for each of the four points to apply afterwards the 2-D
                %Bilinear Interpolation

                a(:,:,1) = red(y_l, x_l);
                b(:,:,1) = red(y_l, x_h);
                c(:,:,1) = red(y_h, x_l);
                d(:,:,1) = red(y_h, x_h);

                a(:,:,2) = green(y_l, x_l);
                b(:,:,2) = green(y_l, x_h);
                c(:,:,2) = green(y_h, x_l);
                d(:,:,2) = green(y_h, x_h);

                a(:,:,3) = blue(y_l, x_l);
                b(:,:,3) = blue(y_l, x_h);
                c(:,:,3) = blue(y_h, x_l);
                d(:,:,3) = blue(y_h, x_h);
                
                %implement the 2-D Bilinear Interpolation
                for k=1:3
                    pixel(k) = a(:,:,k) * (1 - x_weight) * (1 - y_weight) ... 
                    + b(:,:,k) * x_weight * (1 - y_weight) + ...
                    c(:,:,k) * y_weight * (1 - x_weight) + ...
                    d(:,:,k) * x_weight * y_weight;
                end
                
                %The color channels of the resized image
                red_resized(i, j) = pixel(1);
                green_resized(i, j) = pixel(2);
                blue_resized(i, j) = pixel(3);
            end
        end
    end
    Ccam(:, :, 1) = red_resized;
    Ccam(:, :, 2) = green_resized;
    Ccam(:, :, 3) = blue_resized;

end
