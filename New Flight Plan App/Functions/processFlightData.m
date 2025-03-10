function [ProcessedData] = processFlightData(app)

    if isempty(app.FlightPlan) || isempty(app.stats)
        errordlg('No flight plan generated yet.', 'Error');
        return;
    end

    % Code which populates ground and flight path coordinates
    N = size(app.FlightPlan,1);
    t_original = linspace(0,1,N);
    t_dense = linspace(0,1,10*N); % Densifies vectors by a factor of 10

    % Performs Linear Interpolation on Flight Path coordinates
    Fx_dense = interp1(t_original, app.FlightPlan(:,1), t_dense, 'linear');
    Fy_dense = interp1(t_original, app.FlightPlan(:,2), t_dense, 'linear');
    Fz_dense = interp1(t_original, app.FlightPlan(:,3), t_dense, 'linear');

    % Performs Linear Interpolation on Ground coordinates
    Gx_dense = interp1(t_original, app.GroundCoords(:,1), t_dense, 'linear');
    Gy_dense = interp1(t_original, app.GroundCoords(:,2), t_dense, 'linear');
    Gz_dense = interp1(t_original, app.GroundCoords(:,3), t_dense, 'linear');

    % Performs linear interpolation on angle and displacement offsets
    angles_dense = interp1(t_original, app.stats.angles, t_dense, 'linear');
    disp_dense = interp1(t_original, app.stats.displacements, t_dense, 'linear');

    % Compute tangent vectors
    FlightPathDense = [Fx_dense', Fy_dense', Fz_dense'];
    numPoints = size(FlightPathDense,1);
    tangentVectors = zeros(numPoints,3);

    for i = 2:(numPoints-1)
        tangentVectors(i,:) = FlightPathDense(i+1,:) - FlightPathDense(i-1,:);
        tangentVectors(i,:) = tangentVectors(i,:) / norm(tangentVectors(i,:));
    end
    tangentVectors(1,:) = FlightPathDense(2,:) - FlightPathDense(1,:);
    tangentVectors(1,:) = tangentVectors(1,:) / norm(tangentVectors(1,:));
    tangentVectors(end,:) = FlightPathDense(end,:) - FlightPathDense(end-1,:);
    tangentVectors(end,:) = tangentVectors(end,:) / norm(tangentVectors(end,:));

    % Compute YawGimbalAngles
    YawGimbalAngles = zeros(numPoints,1);
    for i = 1:numPoints
        vecToTarget = [Gx_dense(i), Gy_dense(i), Gz_dense(i)] - FlightPathDense(i,:);
        vecToTarget = vecToTarget / norm(vecToTarget);
        angleRad = acos(dot(tangentVectors(i,:), vecToTarget));
        YawGimbalAngles(i) = rad2deg(angleRad);
    end

     % Store tangent vector components in ProcessedData table - Added
    ProcessedData = table(Gx_dense', Gy_dense', Gz_dense', ...
        Fx_dense', Fy_dense', Fz_dense', angles_dense', disp_dense', YawGimbalAngles, tangentVectors(:,1), tangentVectors(:,2), tangentVectors(:,3), ...
        'VariableNames', {'Gx','Gy','Gz','Fx','Fy','Fz','PitchGimbalAngle','Displacement','YawGimbalAngle', 'TangentX', 'TangentY', 'TangentZ'});

end