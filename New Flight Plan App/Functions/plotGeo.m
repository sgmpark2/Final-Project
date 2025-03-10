function plotGeo(app)

    % plotFlightPlanWithTerrain: Overlays a flight plan on a terrain map
    %
    % Inputs:
    % latitudes   - Array of latitudes for the flight plan
    % longitudes  - Array of longitudes for the flight plan

    latitudes = app.latlon(:,1);
    longitudes = app.latlon(:,2);

    % Set the basemap to 'satellite' for terrain display
    geobasemap(app.UIAxes,'colorterrain');

    % Plot the flight plan on the terrain map
    geoplot(app.UIAxes,latitudes, longitudes, 'r-', 'LineWidth', 2);

    % Hold on to add other elements if needed
    hold(app.UIAxes, 'on');


end