function [PhotoData] = photoProjection(app)

        fovH = app.horizontalFOV.Value; % Stores horizontal FOV from user input
        fovV = app.verticalFOV.Value; % Stores vertical FOV from user input

        Gx = app.ProcessedData.Gx;
        Gy = app.ProcessedData.Gy;
        Gz = app.ProcessedData.Gz;
        Fx = app.ProcessedData.Fx;
        Fy = app.ProcessedData.Fy;
        Fz = app.ProcessedData.Fz;
        overlap = app.overlap.Value;
        Displacement = app.ProcessedData.Displacement;
        pathLength = app.stats.pathLength;
        numPhotos = app.stats.photoNum;

        numPts = height(app.ProcessedData.Gx);

        captureIndices = round(linspace(1,numPts,numPhotos));
        
        app.CaptureIndices = captureIndices;

        cla(app.UIAxes);
        hold(app.UIAxes,'on');
        view(app.UIAxes,3);
        grid(app.UIAxes,'on');

        h1 = plot3(app.UIAxes, Fx, Fy, Fz, 'b-','LineWidth',1.5,'DisplayName','Flight Path');
        h2 = scatter3(app.UIAxes, Gx, Gy, Gz,10,'g','filled','DisplayName','Ground Points');

        % Get tangent vectors from ProcessedData table
        tangentVectors = [app.ProcessedData.TangentX, app.ProcessedData.TangentY, app.ProcessedData.TangentZ];

        for i = captureIndices
            cx = Fx(i);
            cy = Fy(i);
            cz = Fz(i);
            d = Displacement(i);

            % Calculates horizontal and vertical coverage from FOVs and displacements
            coverageH = d * tan(deg2rad(fovH/2));
            coverageV = d * tan(deg2rad(fovV/2));

            % Get the tangent vector (drone's heading)
            tangent = [tangentVectors(i,1), tangentVectors(i,2), 0]; % Use XY components only, assuming horizontal plane
            tangent = tangent / norm(tangent); % Ensure it's normalized

            % Calculate the perpendicular vector in the horizontal plane
            perpendicular = [-tangent(2), tangent(1), 0]; % Perpendicular to tangent

            % Calculate the corners of the projection relative to the center (ground point)
            corners = [
                coverageH * tangent(1) + coverageV * perpendicular(1),   coverageH * tangent(2) + coverageV * perpendicular(2);
                -coverageH * tangent(1) + coverageV * perpendicular(1),   -coverageH * tangent(2) + coverageV * perpendicular(2);
                -coverageH * tangent(1) - coverageV * perpendicular(1),   -coverageH * tangent(2) - coverageV * perpendicular(2);
                coverageH * tangent(1) - coverageV * perpendicular(1),   coverageH * tangent(2) - coverageV * perpendicular(2)];

            % Simply shift the projection to the ground point (no rotation applied)
            Gx_proj = corners(:,1) + Gx(i);  % Add the ground point to the offset
            Gy_proj = corners(:,2) + Gy(i);  % Add the ground point to the offset
            Gz_proj = ones(size(Gx_proj)) * Gz(i);  % Assuming flat ground for now

            % Plot the projected area
            h3 = fill3(app.UIAxes, Gx_proj, Gy_proj, Gz_proj, 'c', 'FaceAlpha', 0.3);
            h4 = plot3(app.UIAxes, cx, cy, cz, 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r');

        end

        legend([h1, h2, h3, h4], {'Flight Path', 'Ground Points', 'Camera Coverage', 'Capture Points'}, 'Location', 'Best');
        hold(app.UIAxes,'off');
end
