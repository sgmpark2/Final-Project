function [photoNum] = calculatePhotoNum(app)

    pathLength = app.stats.pathLength;
    fovH = deg2rad(app.horizontalFOV.Value);
    Disp = app.ProcessedData.Displacement;
    overlap = app.overlap.Value;

    % Calculate width of photo 'footprint':
    W = 2*mean(Disp)*tan(fovH/2);

    % Calculate step between each photo:
    S = W * (1-(overlap/100));

    % Calculate number of photos:
    photoNum = ceil(pathLength/S);

end