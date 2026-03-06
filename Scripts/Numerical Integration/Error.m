% Numerical Integrator Error Showcase:
close all; clear; clc;

% initial condition, y(0) = 0
y = 0;
yRK2 = y;
yRK4 = y;

% timespan over which to integrate:
dt = 0.5;
tEnd = 3;
t = 0:dt:tEnd;

%integration loop:
for i=1:length(t)-1
    % numerically integrate with explicit euler
    y(i+1) = y(i) + YDot(t(i),y(i)) * dt;
    % numerically integrate with RK2
    yRK2(i+1) = rk2(@(t,y)YDot(t(i),y), dt, t, yRK2(i));
    % numerically integrate with RK4
    yRK4(i+1) = rk4(@(t,y)YDot(t(i),y), dt, t, yRK4(i));
end

% tspan for the original function:
tspanCurve = linspace(0,tEnd, 100);

figure;
plot(t,y, '.', LineStyle='-', MarkerSize= 12)
hold on
plot(tspanCurve,tspanCurve.^2)
xlabel('$t$')
ylabel('$y(t)$')
legend('Explicit Euler', '$y=t^2$', 'Location', 'northwest')
title('Explicit Euler Solution vs. True Solution')


%figure plotting:
figure;
plot(t, y, '.', LineStyle='-', MarkerSize= 12)
hold on
plot(t, yRK2, '.', LineStyle='-', MarkerSize= 12)
plot(t, yRK4, '.', LineStyle='-', MarkerSize= 12)
plot(tspanCurve, tspanCurve.^2, LineWidth=1.5)

legend('Explicit Euler', 'RK2', 'RK4', '$y=t^2$', 'Location', 'northwest')

xlabel('$t$')
ylabel('$y(t)$')
title('Comparison of Runge-Kutta Integration Orders')

% functions

%euler
function[out] = YDot(t,Y)
out = 2 * t;
end

%rk2
function out = rk2(fun, dt, tIn, xIn)
    f1 = fun(tIn,xIn);
    f2 = fun(tIn + dt/2, xIn + dt .* f1);
    
    out = xIn + (dt / 2)*(f1 + f2);
end

%rk4
function out = rk4(fun, dt, tIn, xIn)
    f1 = fun(tIn,xIn);
    f2 = fun(tIn + dt/2, xIn + (dt/2) .* f1);
    f3 = fun(tIn + dt/2, xIn + (dt/2) .* f2);
    f4 = fun(tIn + dt, xIn + dt*f3);
    
    out = xIn + (dt / 6)*(f1 + 2*f2 + 2*f3+f4);
end