function plotFlightPath(app)
    cla(app.UIAxes);
    if isempty(app.FlightPlan)
        disp('No flight plan yet.');
        return;
    end
    scatter3(app.UIAxes, app.GroundCoords(:,1), app.GroundCoords(:,2), app.GroundCoords(:,3),...
        'filled','MarkerFaceColor','g','DisplayName','Ground Points');
    hold(app.UIAxes, 'on');
    plot3(app.UIAxes, app.FlightPlan(:,1), app.FlightPlan(:,2), app.FlightPlan(:,3),...
        'b-', 'LineWidth',2,'DisplayName','Flight Path');
    legend(app.UIAxes,'Location','best','FontSize',12,'Color','w','TextColor','k');
    axis(app.UIAxes, 'equal');
    grid(app.UIAxes, 'on');
    hold(app.UIAxes, 'off');
end