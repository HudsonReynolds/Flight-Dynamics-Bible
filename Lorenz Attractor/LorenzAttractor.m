%clear everything out
clear; close all; clc

% change whether to output to video file or not
output = 0;

%initialize the parameters of the lorenz attractor
sigma = 10;
rho = 28;
beta = 8/3;

%put these parameters into a vector called beta
beta = [sigma, rho, beta];

% initialize the timestep
dt = 1e-3;

% create a timestep to integrate this over. Read this as timespan from 0 to
% 20 with a step of dt between each step
tspan = 0:dt:20;

%set the options for ode45. Because the Lorenz attractor is a chaotic
%system set this to have high accuracy
options = odeset('RelTol',1e-12, 'AbsTol',1e-12*ones(1,3));


for j = 1:3:10
    % set a delta for each particle to see this diverge over time
    delta = rand()*(1e-2);
    
    %set the initial vector for each particle
    x0 = [0+delta;1+delta;20+delta];

    %run ode45. Use a function handle to pass through the time and the x
    %and pass through the beta value seperately as a constant.
    [t,x(:,j:j+2)] = ode45(@(t,x)lorenz(t,x,beta), tspan, x0, options);

end

%plot the solution
figure(1)
hold on
plot3(x(:,1),x(:,2),x(:,3));
plot3(x(:,4),x(:,5),x(:,6));
plot3(x(:,7),x(:,8),x(:,9));

xl = xlim;
yl = ylim;
zl = zlim;

lims = [xl,yl,zl];

%draw the solution in an animation
LorenzAnimation(x, lims, tspan, t, output)

%% Lorenz
% Differential equation for the Lorenz Attraction
% inputs:
% t - timespan [s]
% x - state vector
% outputs:
% dx - derivative of state vector
function dx = lorenz(t, x, beta)

dx = [    
beta(1)*(x(2)-x(1));
x(1)*(beta(2)-x(3))-x(2);
x(1)*x(2) - beta(3)*x(3);
];

end
