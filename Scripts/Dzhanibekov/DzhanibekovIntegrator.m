function [out] = DzhanibekovIntegrator(time, input)
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
% input - Array of angular velocity and quaternions
%         [rad/s|unitless] 
%
% Outputs:
% out = derivative of state vector [rad/s^2|unitless^2]


omega = [input(1); input(2); input(3)];

quat = [input(4); input(5); input(6); input(7)];

%bodyVectorEarth = RotationMatrix(bodyVector, quat, 1); % Body vector in inertial frame

%% Moments:
Jxx = 0.09;
Jyy = 0.01;
Jzz = 0.03;

J = [Jxx,0,0;0,Jyy,0;0,0,Jzz];

momentVector = zeros(3,1);
% use euler equations to find the final moments:

wx = omega(1);
wy = omega(2);
wz = omega(3);

alpha(1) = (Jyy-Jzz)/(Jxx)*wy*wz;
alpha(2)= (Jzz-Jxx)/(Jyy)*wx*wz;
alpha(3)= (Jxx-Jyy)/(Jzz)*wx*wy;

alpha = alpha';

B = [0, -wx, -wy, -wz;
     wx, 0, wz, -wy;
     wy, -wz, 0, wx;
     wz, wy, -wx, 0];

quatRates = 0.5 * B * quat;

out = [alpha;quatRates];

end