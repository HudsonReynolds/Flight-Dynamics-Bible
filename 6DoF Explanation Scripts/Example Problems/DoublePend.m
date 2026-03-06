% simulate the double pendulum:
l = 1; % length of pend arms [m]
g = 9.81; % [m/s^2]
time = 60;
framerate = 24;
tspan = linspace(0,time, time*framerate); % time span for the simulation [s]

% define the initial state [theta, phi, theta_dot, phi_dot]
x0 = [pi;pi-.01;0;0];

% numerically integrate
[t,y] = ode45(@(t,x)integrator(t,x,l,g),tspan, x0);

% draw the output in an animation

% Convert polar to cartesian coordinates
x1 = l * sin(y(:,1));
y1 = -l * cos(y(:,1));
x2 = x1 + l * sin(y(:,2));
y2 = y1 - l * cos(y(:,2));

% Initialize Figure
figure('Color', 'w');
grid on;
axis equal;
% Set axis limits based on total length
lim = 2 * l + 0.1;
axis([-lim lim -lim lim]);
xlabel('x [m]'); ylabel('y [m]');
title('Double Pendulum Simulation');

% Create Plot Objects (Handles)
% 'Marker' creates the masses, 'LineWidth' creates the rods
arm = line([0, x1(1), x2(1)], [0, y1(1), y2(1)], ...
    'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 8, ...
    'MarkerFaceColor', 'k', 'Color', 'b');

% Uncomment below: Create a "tail" to show the path of the second mass
trail = animatedline('Color', [0.8 0.8 0.8], 'LineStyle', '--');

% Animation Loop
for i = 1:length(t)
    % Update the rod and mass positions
    set(arm, 'XData', [0, x1(i), x2(i)], 'YData', [0, y1(i), y2(i)]);
    
    % Uncomment below: Update the trail
    addpoints(trail, x2(i), y2(i));
    
    % Control the speed of playback
    pause(1/framerate*0.8)
    drawnow; 
end


% integrator
function out = integrator(t,x,l,g)

theta = x(1);
phi = x(2);
theta_dot = x(3);
phi_dot = x(4);

theta_ddot = -(l*sin(phi - theta)*phi_dot^2 + cos(phi - theta)*(l*sin(phi - theta)* ...
    theta_dot^2 + g*sin(phi)) - 2*g*sin(theta))/(l*(cos(phi - theta)^2 - 2));
phi_ddot = (2*l*sin(phi - theta)*theta_dot^2 - cos(phi - theta)*(2*g*sin(theta) - l* ...
    phi_dot^2*sin(phi - theta)) + 2*g*sin(phi))/(l*(cos(phi - theta)^2 - 2));

out = [theta_dot; phi_dot; theta_ddot; phi_ddot];
end