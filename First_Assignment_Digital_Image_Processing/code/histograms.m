function [] = histograms(Csrgb, Clinear, Cxyz, Ccam)
    %function to show the histograms of the C matrices
    colors = ['r', 'g' , 'b'];
    cmatrices = ["Csrgb", "Clinear", "Cxyz", "Ccam"];

    for k=1:4
        figure('Name',cmatrices(k) + ' Histogram')
        switch (cmatrices(k))
            case "Csrgb"
                Temp = Csrgb;
            case "Clinear"
                Temp = Clinear;
            case  "Cxyz"
                Temp = Cxyz;
            case "Ccam"
                Temp = Ccam;
        end
        for l=1:3
            plot(imhist(Temp(:,:,l)),colors(l));
            hold on;
        end

        leg1 = legend('Red','Green', 'Blue');
        set(leg1,'Interpreter','latex', 'fontsize', 12);
        title(cmatrices(k), 'Interpreter', 'Latex', 'fontsize', 12);
    end

end