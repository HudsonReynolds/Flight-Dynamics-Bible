% Title: GravityToBodyEuler
% Author: Preston Wright
% Example converting a gravity force from the inertial to body frame using Euler angles

% Start with your initializations. Every angle should be in radians, and our force is in Newtons
phi = 2.71;
theta = 0.2;
psi = 0.2;
gravityInertial = [-100;0;0];
omega = [2.5;0.1;0.1];
bMatrix = [1, tan(theta)*sin(phi), tan(theta)*cos(phi); ...
           0,       cos(phi),         -sin(phi); ...
           0, sin(phi)/cos(theta), cos(phi)/cos(theta)];

% Calculate the DCM for the instantaneous orientation of the vehicle. Remember we're using a 3-2-1 rotation sequence for this problem; therefore, we will input the corresponding z, then y, then x angle and define our order at the end
DCM = angle2dcm(psi,theta,phi,"ZYX");

% Matrix multiply the DCM with the inertial gravity vector to find the body frame representation of the gravity vector
gravityBody = DCM*gravityInertial;

% We now want to multiply our b matrix by the angular velocity vector to get the Euler rate
eulerRate = bMatrix*omega;