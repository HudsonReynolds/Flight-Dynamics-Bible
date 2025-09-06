% PSP FLIGHT DYNAMICS:
%
% Title: Problem 4-2 Script
% Author: Preston Wright
% Last Modified: 9-6-2025 
% 
% Description: This script computes a frame conversion of the thrust force 
% to determine the component acting in the inertial xy-plane.
clear;clc;close all

% Initialize known variables
thrustBody = [0;0;10000];   % Thrust force in body coordinates [N]
maxForce = 1000;            % Max force that can act in xy-plane [N]
psi = 0;                    % Yaw angle/z-axis angle [rad]
theta = 0.15;               % Pitch angle/y-axis angle [rad]
phi = -0.05;                % Roll angle/x-axis angle [rad]

% Convert the thrust force to be expressed in inertial coordinates
DCM = angle2dcm(psi,theta,phi,"ZYX");
DCM = DCM';
thrustInertial = DCM*thrustBody;

% Calculate the magnitude of the force acting in the xy-plane
thrustPlane = sqrt(thrustInertial(1)^2+thrustInertial(2)^2);

% Compare that magnitude to see if it exceeds the maximum allowable force
if thrustPlane > maxForce
    fprintf("The thrust exceeds the maximum allowable force and the soldiers will be blown away!\n")
else
    fprintf("The thrust is below the maximum allowable force and the soldiers will be fine.\n")
end

