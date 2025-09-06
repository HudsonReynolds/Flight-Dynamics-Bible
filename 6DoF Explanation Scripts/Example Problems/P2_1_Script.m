% PSP FLIGHT DYNAMICS:
% Title: Problem 2-1 Script
% Author: Hudson Reynolds
% Last Modified:9-6-2025 
% 
% Description: This script runs a mass spring damper simulation. The
% analytical solution is compared against the numerical integration.
clear;clc;close all

% Write the analytical solution:
t = linspace(0,10,300);
xAnal = -5*sin(2*t);

% Run the ODE45 integration for the no damper scenario

% pos, vel
x0 = [0;-10];
[t,xNum] = ode45(@(t,x)integrator(t,x), t, x0);

% run the ODE45 for the damper situation:

% pos, vel
x0 = [0;-10];
[t,xNumDamp] = ode45(@(t,x)integrator2(t,x), t, x0);

% plot:
figure
sgtitle('Mass Spring Damper Simulation');
subplot(2,1,1)
plot(t,xAnal)
hold on;
plot(t, xNum(:,1), '--');
title('Undamped MSD')
xlabel('Time (s)');
ylabel('Position (m)');
legend('Analytical Solution', 'Numerical Solution', 'Location','best');
hold off;
yLims = ylim;


subplot(2,1,2)
plot(t,xNumDamp(:,1))
ylim(yLims)
title('Damped MSD')
xlabel('Time (s)');
ylabel('Position (m)');


function out = integrator(t,x)
vel = x(2);
accel = -4*x(1);

out = [vel;accel];
end

function out = integrator2(t,x)
vel = x(2);
accel = -4*x(1) - x(2);

out = [vel;accel];
end