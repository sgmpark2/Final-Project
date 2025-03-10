% Function to generate flight path
function [flightPlan, stats] = generateFlightPath(~, groundCoords, biasVal, straightVal, slopeVal, minAlt, maxDisp, speed)
    [N, ~] = size(groundCoords); % Obtains the number of ground coordinates
    flightPlan = zeros(N,3); % Initializes the flight path matrix
    angles = zeros(N,1); % Initializes the drone angle offset vector
    displacements = zeros(N,1); % Initializes the drone displacement vector
    deviations = zeros(N,1); % Initialize deviation from the straight path vector

    for i = 1:N % Ensures that the number of ground and flight path coordinates match
        d_vertical = minAlt; % Stores the minimum altidude as the drones vertical position relative to the ground 
        groundHeight = groundCoords(i,3); % Stores the Gz variable as groundHeight
        droneAlt = groundHeight + d_vertical; % Sums the groundHeight and d_vertical to find the drones altitude

        dirVec = [1, -1]; % Creates a direction vector to offset the drone from the gound
        dirVec = dirVec / norm(dirVec); % Normalizes direction vector

        d_XY_angle = d_vertical * tan(deg2rad(slopeVal)); % Uses trigonometry to calculate the angle offset (reference for calculation) 
        d_XY_distance = maxDisp; % Stores the maximum displacement as d_XY_distance (reference for calculation)
        d_XY = biasVal * d_XY_angle + (1 - biasVal) * d_XY_distance; % Calculates the actual drone offset on the XY plane 
        offsetVec = [d_XY .* dirVec, d_vertical]; % Calculates the offset vecotor in 3D space

        if norm(offsetVec) > maxDisp % Checks whether the offset vector exceeds the maximum displacment
            offsetVec = offsetVec * (maxDisp / norm(offsetVec)); % Scales down displacement if max displacemnt is exceeded
        end

        flightPlan(i,:) = groundCoords(i,:) + offsetVec; % Stores flight path x and y coordinates based on ground coordinates and offset vector
        flightPlan(i,3) = droneAlt; % Stores flight path z coordinates based on drone altitude

        displacements(i) = norm(offsetVec); % Stores displacements based on displacement vector
        angles(i) = atan2d(norm(offsetVec(1:2)), d_vertical); % Stores offset angles using trigenometry and x, y flight path coordinates
    end

    smoothPlan = flightPlan; % Initializes smoothing
    for i = 2:(N-1)
        smoothPlan(i,:) = (flightPlan(i-1,:) + flightPlan(i+1,:)) / 2; % Creates a smooth plan using central differnce method
    end

    for i = 2:(N-1)
        flightPlan(i,:) = (1 - straightVal)*flightPlan(i,:) + straightVal*smoothPlan(i,:); % Implements the smooth plan based on the slider value
        deviations(i) = norm(flightPlan(i,:) - smoothPlan(i,:)); % Calculates the deviation of the flight plan from the "straight" path by 
                                                                 % subtracting one from the other 
    end

    % Calculate flight path length
    pathLength = 0; % Initializes Flight Path length
    for i = 2:size(flightPlan, 1)
        pathLength = pathLength + norm(flightPlan(i,:) - flightPlan(i-1,:)); % Calculates flight length by summing 
                                                                                     % distance between each point
    end
    
    % Get drone speed from UI
    droneSpeed = speed;
    
    % Calculate flight time
    flightTime = pathLength / droneSpeed; % Calculates flight time using values for flight length and drone speed
    
    % Putting into single structure:
    stats.pathLength = pathLength;
    stats.flightTime = flightTime;


    stats.mean_angle = mean(angles); % Calculates mean drone angle offset 
    stats.std_angle = std(angles); % Calculates standard deviation of drone angle offset
    stats.mean_displacement = mean(displacements); % Calculates mean drone displacement
    stats.std_displacement = std(displacements); % Calculates standard deviation of drone displacement
    stats.std_straight_deviation = std(deviations(2:end-1)); % Calculates standard deviation from the straight path
    stats.angles = angles; % Stores angles variable
    stats.displacements = displacements; % Stores displacements variable
end