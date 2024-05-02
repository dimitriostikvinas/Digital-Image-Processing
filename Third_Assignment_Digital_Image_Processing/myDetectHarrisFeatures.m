function corners = myDetectHarrisFeatures(I)

    I = im2double(I);

    [width, height] = size(I);
    
    crop_scale_x = round(width/100);
    crop_scale_y = round(height/100);
    k = 0.06;
    kernel_size = 3;
    sigma = 1;

    
    
    sobel = [1 0 -1 ; 2 0 -2 ; 1 0 -1];

    Ix = filter2(sobel, I, 'same');
    Iy = filter2(sobel', I, 'same');
    
    
    gauss = fspecial('gaussian',kernel_size, sigma);

    Ixx = conv2(Ix .* Ix, gauss, "same");
    Ixy = conv2(Ix .* Iy, gauss, "same");
    Iyy = conv2(Iy .* Iy, gauss, "same");

    TRACE = Ixx + Iyy;
    DET = Ixx.*Iyy - Ixy.*Ixy;
    R = DET - k * TRACE .* TRACE;
    
     Rthres = 0.01 * max(R(:));

    for x = 1:size(R, 1)
        for y = 1:size(R, 2)
            if R(x, y) > Rthres && x > crop_scale_x && x < width - crop_scale_x ...
                    && y > crop_scale_y && y < height - crop_scale_y
                continue;
            else
                R(x, y) = 0;
            end
        end
    end



   %To keep only one set of coordinates for the corner detection and
   %discard the rest, either we finetune the k parameter or do it manually
    
   %For each corner, we want to find the nearest points around it composing
   %clustered data and keep only one of them. To accomplish that, we will
   %find the local maxima for each corner
    
   %find local maxima
   local_maxima = imregionalmax(R);
   
   [x, y] = find(local_maxima);

   corners = [x, y];
 
end