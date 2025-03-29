% Title: GravityToBodyQuat
% Author: Preston Wright
% Example converting a gravity force from the inertial to body frame using
% Quaternions

% Start with your initializations. Every angle should be in radians, and
% our force is in Newtons
phi = 2.71;
theta = 0.2;
psi = 0.2;
gravityInertial = [-100;0;0];
angularVel = [2.5;0.1;0.1];
bMatrixQuat = [0, -angularVel(1), -angularVel(2), -angularVel(3); ...
               angularVel(1), 0, angularVel(3), -angularVel(2); ...
               angularVel(2), -angularVel(3), 0, angularVel(1); ...
               angularVel(3), angularVel(2), -angularVel(1), 0];

% Before moving on to calculating our rotation matrix, we want to convert
% the Euler angles to quaternions like so (remember our rotation order!):
quat = eul2quat([psi,theta,phi],"ZYX");

% We can now call the funciton to find our rotation matrix
quatDCM = quat2dcm(quat);

% Multiplying our DCM by the gravity vector will give us the gravity vector
% expressed in the body frame
gravityBodyQuat = quatDCM*gravityInertial;

% To prepare for matrix multiplication in the following step, we need to 
% transpose the given quat vector to make it a column vector
quat = quat';

% Calculating our quaternion rate using the known formula appears as
% follows:
quatRate = (1/2)*(bMatrixQuat*quat);

% Once agian, at this point, we would use our numerical integration scheme
% to approximate the next timestep's quaternion using the quaternion rates
% we just found. We won't do that here, but you can see the implementation 
% in the 6DoF itself or the Dzhanibekov example!
