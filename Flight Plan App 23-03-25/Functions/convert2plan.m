function convert2plan(app)

%% Fixing Yaw Angle to Face Correct Direction 

% Retrieving Correct Data:
Fx = app.ProcessedData.Fx;
Fy = app.ProcessedData.Fy;

% Loop through each row to create mission waypoints
for i = 1:size(app.latlon, 1) - 1
    % Collect Gimbal Angle from Main Data
    gimbalYaw = app.latlon(i,5);
    
    % Compute heading angle [rad]
    heading = rad2deg(atan2(Fy(i+1)-Fy(i), Fx(i+1)-Fx(i)));
    heading = mod(90 - heading, 360);
    
    if heading > 180 && heading < 270
        app.latlon(i,5) = gimbalYaw;
    elseif heading > 0 && heading < 90
        app.latlon(i,5) = -gimbalYaw;
    elseif heading > 90 && heading < 180
        app.latlon(i,5) = -180;
    end

end


%% Specifying capture indices
capInd = app.captureIndices;
app.latlon(capInd, 6) = 1;

% Only keep coordinates where a photo is to be taken (column 6 = 1):
app.latlon(app.latlon(:,6) == 0, :) = [];

% Set initial gimbal yaw angle
app.latlon(1,5) = 110;

%% --- Creating .plan file --------------------------------------

% Set take-off point
homeLat = 53.31910287764659;
homeLon = -4.025592424771316;
homeAlt = 0;               

% Initialize mission structure
mission.fileType = 'Plan';
mission.version = 1;
mission.groundStation = 'QGroundControl';

% Required mission fields
mission.mission.firmwareType = 12; % 12 = PX4, 2 = ArduPilot
mission.mission.vehicleType = 2;   % 2 = Multicopter
mission.mission.hoverSpeed = app.speed.Value;
mission.mission.plannedHomePosition = [homeLat, homeLon, homeAlt];
mission.mission.items = [];        % Initialize mission items

% Add required empty rally points section
mission.rallyPoints.points = [];
mission.rallyPoints.version = 2;
mission.geoFence.circles = [];
mission.geoFence.polygons = [];
mission.geoFence.version = 1;

% Define takeoff mission item (Command 22: Takeoff)
takeoffItem = struct();
takeoffItem.autoContinue = true;
takeoffItem.command = 22; % MAV_CMD_NAV_TAKEOFF
takeoffItem.doJumpId = 1; % First command
takeoffItem.frame = 3; % Altitude relative to launch
takeoffItem.params = [0, 0, 0, 0, homeLat, homeLon, 5]; % 5m takeoff altitude
takeoffItem.type = 'SimpleItem';

% Insert takeoff command at the beginning of the mission
mission.mission.items = [{takeoffItem}, mission.mission.items];


counter = 1;
data = app.latlon;
% Loop through each row to create mission waypoints
for i = 1:size(data, 1)

    % Extract coordinates and gimbal values
    lat = data(i, 1);
    lon = data(i, 2);
    alt = data(i, 3);
    gimbalPitch = data(i, 4);
    gimbalYaw = data(i,5);
                    
    % Create a waypoint mission item (Command 16: Navigate to waypoint)
    waypointItem = struct();
    waypointItem.autoContinue = true;
    waypointItem.command = 16;
    waypointItem.doJumpId = counter;
    waypointItem.frame = 0; % Altitudes are relative to AMSL
    waypointItem.params = [0, 0, 0, NaN, lat, lon, alt]; % [hold time, acceptance radius, stop or pass through, yaw, lat, lon, alt]
    waypointItem.type = 'SimpleItem';
    
    counter = counter + 1;

    % Add waypoint to the mission
    mission.mission.items{end+1} = waypointItem;

    % Create a camera control mission item (Command 530 = photo mode)
    cameraItem = struct();
    cameraItem.autoContinue = true;
    cameraItem.command = 530;
    cameraItem.doJumpId = counter; % Unique ID
    cameraItem.frame = 2; % MAV_FRAME_MISSION
    cameraItem.params = [0, 0, NaN, NaN, NaN, NaN, NaN]; % [cam mode (0=auto, 1=photo, 2=video), 0...]
    cameraItem.type = 'SimpleItem';

    counter = counter + 1;

    % Add gimbal control item to the mission
    mission.mission.items{end+1} = cameraItem;
    
    % Create a gimbal control mission item (Command 205: Set gimbal angles)
    gimbalItem = struct();
    gimbalItem.autoContinue = true;
    gimbalItem.command = 205;
    gimbalItem.doJumpId = counter; % Unique ID
    gimbalItem.frame = 2; % MAV_FRAME_MISSION
    gimbalItem.params = [gimbalPitch, 0, gimbalYaw, 0, 0, 0, 2]; % [pitch, roll, yaw, 0, 0, 0, mount mode (2 = MAVLINK)]
    gimbalItem.type = 'SimpleItem';
    
    counter = counter + 1;
    % Add gimbal control item to the mission
    mission.mission.items{end+1} = gimbalItem;

    % Create a camera trigger control mission item (Command 2000: Camera Trigger Control)
    cameraTriggerItem = struct();
    cameraTriggerItem.autoContinue = true;
    cameraTriggerItem.command = 2000;
    cameraTriggerItem.doJumpId = counter; % Unique ID
    cameraTriggerItem.frame = 2; % MAV_FRAME_MISSION
    cameraTriggerItem.params = [0, 0, 1, 0, NaN, NaN, NaN]; % [reserved (0) , time interval, # of photos, reserved (0)] 
    cameraTriggerItem.type = 'SimpleItem';

     % Add camera control item to the mission
    counter = counter + 1;
    
    mission.mission.items{end+1} = cameraTriggerItem;
end

% Define return-to-home mission item (Command 20: RTL)
rtlItem = struct();
rtlItem.autoContinue = true;
rtlItem.command = 20; % MAV_CMD_NAV_RETURN_TO_LAUNCH
rtlItem.doJumpId = length(mission.mission.items) + 1; % Unique ID after all waypoints
rtlItem.frame = 2; % MAV_FRAME_MISSION
rtlItem.params = [0, 0, 0, 0, 0, 0, 0]; % No specific lat/lon needed
rtlItem.type = 'SimpleItem';

% Append RTL command to the mission
mission.mission.items{end+1} = rtlItem;

% Convert mission structure to JSON format with indentation
jsonText = jsonencode(mission);
jsonText = strrep(jsonText, ',', sprintf(',\n'));

% Save JSON text to a .plan file
fid = fopen('qgc_mission.plan', 'w');
if fid == -1
    error('Cannot create output file.');
end

fprintf(fid, '%s', jsonText);
fclose(fid);

uialert(app.UIFigure, 'Exported as .plan File Type', 'Success','Icon','success');
end