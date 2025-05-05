function [photoNum] = calculatePhotoNum(app)

% This function calculates the number of photos required to reach the
% inputted % overlap from the user.

% Improvements to be made:
%   - This all calculates from average distances therefore it is not always
%   actually giving a 70% overlap 
%   - Figure out how to actually make it 70% overlap between consecutive
%   waypoints. This may require combining this function into the
%   photoProjection function to work dynamically rather than just
%   calculating from the average.

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