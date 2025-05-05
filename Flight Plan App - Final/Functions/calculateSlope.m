function [meanSlope] = calculateSlope(app)

x = app.GroundCoords(:,1);
y = app.GroundCoords(:,2);
z = app.GroundCoords(:,3);

slope = zeros([20,1]);

for i = 0:20
    
    delta_x = x(i+1) - x(end-i);
    delta_y = y(i+1) - y(end-i);
    delta_z = z(i+1) - z(end-i);

    horzDist = sqrt(delta_x^2 + delta_y^2);
    
    slopeRatio = delta_z / horzDist;

    slope(i+1,1) = rad2deg(atan(slopeRatio));

end
meanSlope = mean(slope);
end

