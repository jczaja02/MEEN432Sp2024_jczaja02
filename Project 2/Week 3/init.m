%%% PROJECT 2 PARAMETERS %%% 
% The following parameters are to be used for Project 2, and some will be
% used for Project 3 which will be commented out at the bottom of the
% script. 

% Vehicle Parameters
carData.Inertia = 1600; % kg m^2  -  Car Inertia
carData.Mass = 1000; % kg      -  Car Mass 


% Initial Conditions
carData.init.X0 = 0;        % m - Initial X Position of the Car
carData.init.Y0 = 0;        % m - Initial Y Position of the Car
carData.init.vx0 = 0.1;     % m/s - Initial Velocity in X of the Car
carData.init.vy0 = 0;       % m/s - Initial Velocity in Y of the Car
carData.init.omega0 = 0;    % rad/s - Initial Yaw Rate of the Car
carData.init.psi0 = 0;      % rad - Initial Heading of the Car


% Vehicle Tire Information 
carData.Calpha_f = 40000; % N/rad - Front Tire Coefficient (slope)
carData.Calpha_r = 40000; % N/rad - Rear Tire Coefficient (slope)
carData.Fyfmax = 40000*1/180*pi; % N - Max Front Tire Force
carData.Fyrmax = 40000*1/180*pi; % N - Max Rear Tire Force
carData.lr = 1.5; % m - Distance from CG to rear axis
carData.lf = 1.0; % m - Distance from CG to front axis
carData.radius = 0.3; % m - Radius of tires


track_radius = 200;
carData.understeerCoeff = ... % Understeering Coefficient 
    carData.Mass / ((carData.lr + carData.lf) * track_radius) ...
      * (carData.lr / carData.Calpha_f - ...
         carData.lf / carData.Calpha_r);


carData.maxAlpha = 4 / 180 * pi; % Max Alpha Angle for Tires


carData.vxd = 10.0; % m/s - Desired Velocity in X
carData.vx_threshold1 = 0.1; % m/s - Threshold for Velocity in X

trackWidth = 15;
l_st = 900;
radius = 200;

path = [trackWidth, l_st, radius];

simout = sim("Project2Week2Simulink.slx");

X = simout.X.Data;
Y = simout.Y.Data;
t = simout.tout;

Race = raceStat(X,Y,t,path);

x_min = -400;
x_max = 1300;

y_min = -400;
y_max = 800;


% Now let's animate the car on the track
figure;
plot(X,Y,'.r');
axis equal;
grid on;
title('Oval Racetrack');
xlabel('X Position (m)');
ylabel('Y Position (m)');
hold on;

% Plot solid background color
patch([x_min, x_max, x_max, x_min], [y_min, y_min, y_max, y_max], [.5 .1 .1], 'EdgeColor', 'none');


% Plot the track in grey
plot(X, Y, 'Color', [0.5 0.5 0.5], 'LineWidth', trackWidth);
axis equal;
title('Racetrack');
xlabel('X');
ylabel('Y');
grid on;



% Define the car dimensions and create a patch
w = trackWidth; % Car width
car = [-w/2, -w; w/2, -w; w/2, w; -w/2, w]';
a = patch('XData', car(:,1), 'YData', car(:,2), 'EdgeColor', 'black', 'FaceColor', 'blue');

% Animated line for the car's trajectory
h = animatedline('Color', 'magenta', 'LineWidth', 2);

% Animate the car along the racetrack
for i = 1:length(X)
    x = X;
    y = Y;
    % Update the car's trajectory
    addpoints(h, x(i), y(i));
    
    % Car heading adjustment: -90 degrees to align with the track
    if i < 38
    
        heading = 90;
        elseif (i > 38) && (i < 220)
            heading = 90 - (i - 38);
        else
            heading = 90;
    end

    if i > 440
        heading = 270 - (i - 440);
    end

    if i == 618
        heading = 90;
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
    pause(0.001);
end

hold off;

Race

% Include the provided rotate function
function xyt = rotate(xy, theta)
    xyt = TF(deg2rad(theta)) * xy;
end

% Include the provided TF function
function y = TF(theta)
    y = [cos(theta), sin(theta); -sin(theta), cos(theta)];
end


