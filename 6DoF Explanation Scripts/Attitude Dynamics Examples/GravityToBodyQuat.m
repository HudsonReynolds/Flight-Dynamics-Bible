% Title: GravityToBodyQuat
% Author: Preston Wright
% Example converting a gravity force from the inertial to body frame and thrust force from body to inertial frame using quaternions

% Start with your initializations. Every angle should be in radians, and our forces are in Newtons
phi = 2.71;                     % x-axis Euler angle [rad]
theta = 0.2;                    % y-axis Euler angle [rad]
psi = 0.2;                      % z-axis Euler angle [rad]
gravityInertial = [-100;0;0];   % inertailly expressed gravity force [N]
thrustBody = [-1000;0;0];       % body expressed thrust force [N]
omega = [2.5;0.1;0.1];          % angular velocity [rad/s]
bMatrixQuat = [0, -omega(1), -omega(2), -omega(3); ...
               omega(1), 0, omega(3), -omega(2); ...
               omega(2), -omega(3), 0, omega(1); ...
               omega(3), omega(2), -omega(1), 0];

% Before moving on to calculating our rotation matrix, we want to convert the Euler angles to quaternions like so (remember our rotation order!):
quat = eul2quat([psi,theta,phi],"ZYX");

% Here we will also get into the habit of normalizing any quaternions we compute, as normalized quaternions (versors) are the only way to express quaternion encoded rotations
quat = quat/norm(quat);

% We can now call the funciton to find our rotation matrix
quatDCM = quat2dcm(quat);

% Multiplying our DCM by the gravity vector will give us the gravity vector expressed in the body frame. Multiplying the transpose (inverse) of the DCM by the thrust vector will give us the thrust vector in the inertial frame
gravityBodyQuat = quatDCM*gravityInertial;
thrustInertialQuat = (quatDCM')*thrustBody;

% To prepare for matrix multiplication in the following step, we need to transpose the given quaternion vector to make it a column vector
quat = quat';

% Calculating our quaternion rate using the known formula appears as follows:
quatRate = (1/2)*bMatrixQuat*quat;