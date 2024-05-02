function [Csrgb , Clinear , Cxyz, Ccam] = dng2rgb(rawim , XYZ2Cam , wbcoeffs ,...
bayertype , method , M, N)
    
    % White Balance Correction

    % we generate the mask defined by the 'bayertype' Bayer Pattern, in order 
    % multiplying elementwise the linearized raw image with the mask  
    mask = wbmask(size(rawim, 1),size(rawim, 2),wbcoeffs,bayertype);
    rawim = rawim .* mask;
    
    %Demosaicing

    %according to the variable 'method', we use either bilinear or nearest
    %neighbors method to calcualte each channel R, G, B value for each
    %pixel of the image, storing it in the 3D camera color space matrix
    %Ccam

    Ccam = Demosaicing(rawim, bayertype, method, M, N);
    
    %XYZ standard color space C matrix 
    Cxyz = apply_cmatrix(Ccam, XYZ2Cam);
    
    %XYZ standard color space to RGB transformation matrix
    Txyz2rgb = [+3.2406 -1.5372 -0.4986 ; -0.9689 +1.8758 +0.0415; ...
        +0.0557 -0.2040 +1.0570];
    RGB2CAM = XYZ2Cam* Txyz2rgb^(-1); % Assuming previously defined matrices
    RGB2CAM = RGB2CAM ./ repmat(sum(RGB2CAM,2),1,3); % Normalize rows to 1
    CAM2RGB = RGB2CAM^-1;
    Clinear = apply_cmatrix(Ccam, CAM2RGB);% Clinear == Crgb 
    Clinear = max(0,min(Clinear,1)); % Always keep image clipped b/w 0-1
    
    % sRGB correction
    % brightness correction
    grayim = rgb2gray(Clinear);
    grayscale = 0.25/mean(grayim(:));
    bright_srgb = min(1, Clinear*grayscale);
    % gamma correction
    Csrgb = bright_srgb.^(1/2.2);
    
end