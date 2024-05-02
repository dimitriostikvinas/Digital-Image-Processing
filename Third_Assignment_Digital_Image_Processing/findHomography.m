function H = findHomography(points1, points2)
%points1 : first pair
%points2 : second pair
    point1 = points1(1, :)';
    point2 = points1(2, :)';
    point3 = points2(1, :)';
    point4 = points2(2, :)';
    
    
    % A = B*C => C = inv(B)*A
    A = [point2(1) ; point2(2) ; point4(1) ; point4(2)]; %4x1 matrix
    B = [point1(1) -point1(2) 1 0 ;...
        point1(2) point1(1) 0 1 ; ...
        point3(1) -point3(2) 1 0 ; ...
        point3(2) point3(1) 0 1];%2x4 matrix

    C =  B \ A;

    R = [C(1) -C(2) ; C(2) C(1)];
    d = [C(3) ; C(4)];

    H = {R, d};

    T = fitgeotform2d(points2,points1,"similarity");
    disp(H{1})
    disp(T.A)
end