function [out, mach, AoA, accel] = DzhanibekovIntegrator(time, input)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: RK4Integrator
% Author: Hudson Reynolds - Created: 2/24/2025
%
% Description: This is the integration function to be used in ode45. This
% computes all funciton derivatives and differential equations for the
% translational and rotational dynamics.
%
% Inputs: 
% time - current simulation time [s]
% input - Array of position, velocity, rotational velocity, and quaternions
%         [m|m/s|rad/s|unitless] 
%
% Outputs:
% out = derivative of state vector [m/s|m/s^2|rad/s^2|unitless^2]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pos = [input(1);input(2);input(3)];

vel = [input(4);input(5);input(6)];

omega = [input(7); input(8); input(9)];

quat = [input(10); input(11); input(12); input(13)];

%bodyVectorEarth = RotationMatrix(bodyVector, quat, 1); % Body vector in inertial frame

accel = zeros(3,1);


%% Moments:
% just putting in values based on a cylinder moment of inertia for now.
Jxx = 0.09;
Jyy = 0.02;
Jzz = 0.02;

J = [Jxx,0,0;0,Jyy,0;0,0,Jzz];

momentVector = zeros(3,1);
% use euler equations to find the final moments:

momentVector(1) = momentVector(1) - omega(2)*omega(3)*(Jzz-Jyy);
momentVector(2) = momentVector(2) - omega(1)*omega(3)*(Jxx-Jzz);
momentVector(3) = momentVector(3) - omega(1)*omega(2)*(Jyy-Jxx);

alpha = inv(J) * momentVector;
alpha(isnan(alpha)) = 0;

wx = omega(1);
wy = omega(2);
wz = omega(3);

B = [0, -wx, -wy, -wz;
     wx, 0, wz, -wy;
     wy, -wz, 0, wx;
     wz, wy, -wx, 0];

quatRates = 0.5 * B * quat;

out = [vel;accel;alpha;quatRates];

end