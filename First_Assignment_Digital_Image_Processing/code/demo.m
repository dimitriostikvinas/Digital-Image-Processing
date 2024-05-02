

%I tried my absolute best to turn off the produced warnings regarding the
%RAW DNG image loading, but I couldn't solve it


filename = "RawImage.DNG";

%choose Bayer Pattern for the mask. 'RGGB' works best
bayertype = 'RGGB';

% 'nearest' or 'linear'
method ='nearest';

%Import raw image and its meta data
[rawim ,XYZ2Cam ,wbcoeffs ] = readdng(filename); 

%store the M(height) and the N(width) of the RAW image
[M_0, N_0] = size(rawim);


M = 1080 ;%desired height of image defined by the user
N = 1920 ;%-//- width -//-

%convert the RAW format properly preprocessed image to RGB 
[Csrgb , Clinear , Cxyz, Ccam] = dng2rgb(rawim , XYZ2Cam , wbcoeffs , bayertype , method , M, N);

%% Print images
Show_C_matrices(Csrgb, Clinear, Cxyz, Ccam, method);

%% Print Histograms
histograms(Csrgb, Clinear, Cxyz, Ccam);