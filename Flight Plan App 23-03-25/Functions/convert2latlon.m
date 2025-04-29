function [latlon,origin] = convert2latlon(app)
% Convert local coordinates into latitude and longitude

    % Cartesian Origin in Lat/Long [latitude longitude altitude]
        % This needs fine-tuning to be completely correct
    origin = [53.315298 -4.032796 0];
    origin = [53.31529 -4.033 0];
    
    % Retrieving Correct Data:
    x = app.ProcessedData.Fx;
    y = app.ProcessedData.Fy;
    z = app.ProcessedData.Fz;
    
    % Convert Flight Path to Latitude/Longitude
    [latitude, longitude] = local2latlon(x,y,z,origin);
    
    % Retriving Altitude Data
    altitude = app.ProcessedData.Fz;
    
    % Placeholder Capture Points Column
    isCapture = zeros(height(app.ProcessedData), 1);
    
    % Combining into one matrix 
    latlon = [latitude longitude altitude app.ProcessedData.PitchGimbalAngle app.ProcessedData.YawGimbalAngle isCapture];

end