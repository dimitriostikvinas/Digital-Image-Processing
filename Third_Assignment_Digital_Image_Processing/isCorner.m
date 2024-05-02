function [c, R] = isCorner(I, p, k, Rthres)
    
    [width, height] = size(I);

    if p(1) < 3 || p(2) < 3 || p(1) > width - 3 || p(2) > height - 3
        R = 0;
        c = false;
        return
    end
   
    I_p = I(p(1)-2:p(1)+2,p(2)-2:p(2)+2);

    prewitt = [1 0 -1 ; 1 0 -1 ; 1 0 -1];

    I_px = conv2(I_p, prewitt, 'same');
    I_py = conv2(I_p, prewitt', 'same');

    I_pxx = imgaussfilt(I_px .* I_px, 1);
    I_pxy = imgaussfilt(I_px .* I_py, 1);
    I_pyy = imgaussfilt(I_py .* I_py, 1);

    M = [I_pxx I_pxy ; I_pxy I_pyy];
    
    R = det(M) - k*trace(M)^2;
    
    if R > Rthres
        c = true;
    else 
        c = false;
    end

end