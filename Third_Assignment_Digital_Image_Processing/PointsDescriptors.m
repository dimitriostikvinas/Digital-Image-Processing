function features = PointsDescriptors(points , I ,rhom,rhoM,rhostep ,N)
    
    features =[];
    
    for i=1:size(points, 1)
        features = [features myLocalDescriptor(I, points(i,:),rhom,rhoM,rhostep ,N) ] ; 
    end
    
end