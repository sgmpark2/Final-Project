function plotGeo(app)

    % Inputs:
    % latitudes   - Array of latitudes for the flight plan
    % longitudes  - Array of longitudes for the flight plan
    delete(app.geoAxesPlot)
    app.geoAxesPlot = geoaxes(app.GeographicPlotTab,"Basemap","satellite");
    hold(app.geoAxesPlot,"on")
    latlim = [53.31500796665545 53.3221560993851];
    lonlim = [-4.033111429740774 -4.018773929947079];
    geolimits(app.geoAxesPlot,latlim,lonlim)

    latitudes = app.latlon(:,1);
    longitudes = app.latlon(:,2);

    % Plot the flight plan on the terrain map
    geoplot(app.geoAxesPlot,latitudes, longitudes, 'r-', 'LineWidth', 2);

    % Hold on to add other elements if needed
    hold(app.geoAxesPlot, 'on');

end