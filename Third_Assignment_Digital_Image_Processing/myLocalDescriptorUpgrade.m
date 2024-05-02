function d = myLocalDescriptorUpgrade(I,p,rhom,rhoM,rhostep ,N)

    %Width and height of the input image
    [width,height] = size(I);
    I = im2double(I);
    
    %The local descriptor's vector with length the number of circles
    %multiplied by N 
    d = [];
    
    %Calcuate the angle in rad corresponding to one point of one 
    %concentric circle
    circle_angle = 2*pi;
    circle_point = circle_angle/N;%rad
    
    
    %For each specific concentric circle 
    for i=rhom:rhostep:rhoM %Number of consecutive concentric circles of the local descriptor
        %Vector for each circle containing the interpolated pixel's value for
        %each circle's point
        x_r = zeros(N, 1);
        %For each point of the specific concentric circle
        for j=1:N
            %It doesn't matter from which point we start, because this
            %local descriptor is rotation invariant
            theta = j * circle_point;
            
            %Taking the pixel's coordinates of the specific point.
            %i is the radius of the circle this point belongs to
            col = floor(p(1) + i*cos(theta)); %x
            row = floor(p(2) + i*sin(theta)); %y
            
            %If any point of the local descriptor is found to be
            %out-of-bounds, we disqualify the descriptor and return an empty 
            %vector
            if (col > 1 && row > 1 && col < width && row < height)
                
                %Bilinear Interpolation to compute the pixel's value
                x_1 = col - 1;
                x_2 = col + 1;
                y_1 = row - 1;
                y_2 = row + 1;
                Q_11 = [x_1, y_1];
                Q_12 = [x_1, y_2];
                Q_21 = [x_2, y_1];
                Q_22 = [x_2, y_2];
                I_11 = I(Q_11(1), Q_11(2));
                I_12 = I(Q_12(1), Q_12(2));
                I_21 = I(Q_21(1), Q_21(2));
                I_22 = I(Q_22(1), Q_22(2));
                
                x_r(j) = 1/((x_2 - x_1)*(y_2 - y_1)) *[x_2 - col col-x_1]...
                    *[I_11 I_12 ; I_21 I_22]*[y_2 - row ; row - y_1];
    
            else
                d = zeros(N*length(rhom:rhostep:rhoM), 1);
                return;
            end
        end
        %The upgrade we implemented is normalizing the vector x_r in
        %order to have zero mean and unit norm for eacg circle
        temp = x_r - mean(x_r);
        temp = temp / norm(x_r);
        d =[d; temp];
    end

end 
