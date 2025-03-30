function [quatRates] = quatIntegrator(omegaVector, quatVector)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: angleIntegrator
% Authors: Hudson Reynolds and Preston Wright - Created: 9/14/2024
%
% Description: This function takes the omega vector in the body frame and
% the current quat vector and outputs the quat rotation rates
%
% Note: Professor Früh's notes from AAE 590 go through
% these steps in more detail
%
% Inputs: 
% omegaVector = array of the angular velocity in the body frame [rad/s]
% angleVector = array of the current quat
%
% Outputs:
% quatRates = the euler rate time derivative in the inertial frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wx = omegaVector(1);
wy = omegaVector(2);
wz = omegaVector(3);

% This formula is from Wertz Chap. 17 of "Spacecraft Attitude Determination
% and Control

% B = [0, wz, -wy, wx;
%      -wz, 0,  wx, wy;
%      wy, -wx, 0,  wz ;
%     -wx, -wy, -wz, 0 ];

B = [0, -wx, -wy, -wz;
     wx, 0, wz, -wy;
     wy, -wz, 0, wx;
     wz, wy, -wx, 0];

quatRates = 0.5 * B * quatVector;