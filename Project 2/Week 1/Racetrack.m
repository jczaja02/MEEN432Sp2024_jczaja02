% Define the track parameters
radius = 200; % meters
straightLength = 900; % meters
trackWidth = 15; % meters, not directly used in waypoint generation

% Define the number of waypoints for the straight and curved sections
numWaypointsStraight = 100; % Recommended to use at least 100 waypoints for straight
numWaypointsCurve = 100; % Recommended to use at least 100 waypoints for curve

% Initialize arrays for the waypoints
x = zeros(1, numWaypointsStraight + 2 * numWaypointsCurve + numWaypointsStraight);
y = zeros(size(x));
theta = zeros(size(x)); % We'll store the heading of the track here

% Starting point
x(1) = 0;
y(1) = 0;
theta(1) = 0;

% Compute waypoints for the first straight section
for i = 2:numWaypointsStraight+1
    x(i) = x(i-1) + straightLength / numWaypointsStraight;
    y(i) = 0;
    theta(i) = 0;
end

% Compute waypoints for the first 180 degree curve
startAngle = 270; % Start from the negative y-axis
for i = 1:numWaypointsCurve
    angle = startAngle + (i-1) * (180 / numWaypointsCurve);
    x(numWaypointsStraight+i) = straightLength + radius * cosd(angle);
    y(numWaypointsStraight+i) = radius + radius * sind(angle);
    theta(numWaypointsStraight+i) = angle;
end

% Compute waypoints for the second straight section
for i = 1:numWaypointsStraight
    x(numWaypointsStraight+numWaypointsCurve+i) = x(numWaypointsStraight+numWaypointsCurve+i-1) - straightLength / numWaypointsStraight;
    y(numWaypointsStraight+numWaypointsCurve+i) = 2 * radius;
    theta(numWaypointsStraight+numWaypointsCurve+i) = 90;
end

% Compute waypoints for the second 180 degree curve
startAngle = 90; % Start from the positive y-axis
for i = 1:numWaypointsCurve
    angle = startAngle + (i-1) * (180 / numWaypointsCurve);
    x(numWaypointsStraight+2*numWaypointsCurve+i) = radius * cosd(angle);
    y(numWaypointsStraight+2*numWaypointsCurve+i) = radius + radius * sind(angle);
    theta(numWaypointsStraight+2*numWaypointsCurve+i) = angle;
end

% Close the track by connecting the end of the second curve to the starting point
x(end) = 0;
y(end) = 0;
theta(end) = 0;

% Now let's animate the car on the track
figure;
plot(x, y, 'LineWidth', 2);
axis equal;
grid on;
title('Oval Racetrack');
xlabel('X Position (m)');
ylabel('Y Position (m)');
hold on;

% Define the car dimensions and create a patch
w = trackWidth; % Car width
car = [-w/2, -w; w/2, -w; w/2, w; -w/2, w]';
a = patch('XData', car(:,1), 'YData', car(:,2), 'EdgeColor', 'black', 'FaceColor', 'blue');

% Animated line for the car's trajectory
h = animatedline('Color', 'magenta', 'LineWidth', 2);

% Animate the car along the racetrack
for i = 1:length(x)
    % Update the car's trajectory
    addpoints(h, x(i), y(i));
    
    % Car heading adjustment: -90 degrees to align with the track
    if i < 101
    
        heading = - theta(i) + 90;
    else
        heading = -theta(i);
    end
    
    if i == 400
        heading = -theta(i) + 90;
    end

    % Generate un-rotated car at new location x(i), y(i)
    carShape = [x(i) - w/2, y(i) - w; x(i) + w/2, y(i) - w; x(i) + w/2, y(i) + w; x(i) - w/2, y(i) + w]';
    
    % Rotate the car according to the track's heading
    carRotated = rotate(carShape - [x(i); y(i)], heading) + [x(i); y(i)];
    
    % Update the car patch data
    set(a, 'XData', carRotated(1, :), 'YData', carRotated(2, :));
    
    % Redraw the plot
    drawnow;

    % Pause to control the animation speed
    pause(0.01);
end

hold off;

% Include the provided rotate function
function xyt = rotate(xy, theta)
    xyt = TF(deg2rad(theta)) * xy;
end

% Include the provided TF function
function y = TF(theta)
    y = [cos(theta), sin(theta); -sin(theta), cos(theta)];
end

