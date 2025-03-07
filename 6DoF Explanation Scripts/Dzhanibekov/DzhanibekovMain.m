%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: DzhanibekovMain
% Author: Hudson Reynolds - Created: 2/24/2024
% Last Modified: 2-24-2025
%
% Description: This is the overarching function that runs a 6-DoF model of 
% the Dzhanibekov effect, calling all neccesary functions to run the
% simulation. The overarching structure uses ODE45.
%
% Inputs: N/A
%
% Outputs:
% Graph and value outputs. See subfunctions for specific outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization:
% clear the console and figures before running the code:
clear
clc
close all

%% Simulation Settings:
% create a time array to span the simulation time.

% set the simulation time parameters
dt = 0.025;
time = 35.9;
tspan = 0:dt:time;

% initialize the state vector
% position (x,y,z)
pos = [0;0;0];
% velocity (xdot,ydot,zdot)
vel = [0;0;0];
% initial angle(x angle, y angle, z angle)
angleVector = [0;0;0];
% initial rotation rate(x rate, y rate, z rate)
omega = [0.05;0.05;pi];
%initalize the quaternion based on the euler angle input:
quatVector = eul2quat(angleVector.', "XYZ").';
% initial state vector
Init = [pos;vel;omega;quatVector];


% run the RK4:
[timeArray, out] = ode45(@(time,input)DzhanibekovIntegrator(time,input), tspan, Init);

% parse rk4 outputs:
posArray = [out(:,1), out(:,2), out(:,3)];
velArray = [out(:,4), out(:,5), out(:,6)];
omega = [out(:,7), out(:,8), out(:,9)];
quatArray = [out(:,10), out(:,11), out(:,12), out(:,13)];
    

%% Plotting:
% Euler Parameters:
figure(1)
plot(timeArray, quatArray);
xlim([0,time]);
title("Euler Parameters")
xlabel("Time (s)")
ylabel("Euler Parameters")
legend('q0', 'q1', 'q2', 'q3');

% run the rotation visualizer script
playbackSpeed = 1;
quatArray = quatArray';
posArray = posArray';
RotationsVisualizer(posArray, quatArray, timeArray, time, dt, playbackSpeed, 1);
