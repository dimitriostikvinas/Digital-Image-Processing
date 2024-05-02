function R_magnitude = contourDescriptors(letters, N, height_letters_training, width_letters_training , mean_height)
    R_magnitude = cell(0);
    for j = 1: length(letters)

        %Getting the contours of the letter image
        contour = getcontour(letters{j, 1}, height_letters_training, width_letters_training, mean_height);
        R_magnitude_temp = [];

        %for each contour it possesses
        for k=1:size(contour, 2)
            x = contour{k}(:,1);
            y = contour{k}(:,2);    
            
            %Calculating the DFT of the complex sequence
            dft =  fft(x + 1i*y);

            %Excluding the DC component
            dft(1) = [];

            %Normalizing the dft's magnitude
            abs_dft_normalized = abs(dft)/size(contour, 2);

            %Applying linear interpolation to adjust the number of each
            %contour's points into N 
            interp_abs_dft_normalized = interp1(linspace(0,1,length(abs_dft_normalized)),abs_dft_normalized,linspace(0,1,N));

            %Normalizing the interpolated values to sum to 1
            R = interp_abs_dft_normalized/sum(interp_abs_dft_normalized);

            %Temporal storing
            R_magnitude_temp=[R_magnitude_temp R];
        end
        R_magnitude{j} = R_magnitude_temp;
        
    end
 end