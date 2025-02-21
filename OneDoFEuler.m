% Euler Method 1DoF

%constants:
m = 1;    % mass [kg]
g = 9.8;  % gravity [m/s^2]
k = 1e-3; % drag const [kg/m]
tb = 5;   % thrust time [s]
Ft = 100; % force of thrust [N]

% define constant forces
Fg = -m*g;

% pos and vel init:
x = 0;
v = 0;
t = 0;

% array init:
i = 1;

% timestep definition:
dt = 0.01;

while v >= 0
    % variables updated every loop
    Fd = -k*v(i)^2;
    Ft = Ft * (1-heaviside(t(i)-tb));

    % Euler Integration:
    a(i+1) = Ft+Fg+Fd;
    v(i+1) = a(i)*dt + v(i);
    x(i+1) = v(i+1)*dt + x(i);

    % Iteration update
    i = i+1;
    t(i) = i*dt;
end

% plot result:
figure(1)
plot(t,x)

figure(2)
plot(t,v)