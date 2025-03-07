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

%figure plotting:
hfig = figure;  % save the figure handle in a variable
fname = 'Numerical Integrator Comparison Figure';

picturewidth = 20; % set this parameter and keep it forever
hw_ratio = 0.75; % feel free to play with this ratio
set(findall(hfig,'-property','FontSize'),'FontSize',18) % adjust fontsize to your document

plot(t, y, '.', LineStyle='-', MarkerSize= 12)
hold on
plot(t, yRK2, '.', LineStyle='-', MarkerSize= 12)
plot(t, yRK4, '.', LineStyle='-', MarkerSize= 12)
plot(tspanCurve, tspanCurve.^2, LineWidth=1)

legend('Explicit Euler', 'RK2', 'RK4', '$y=t^2$', 'Location', 'northwest')

%title('Explicit Euler Numerical Approximation')
xlabel('$t$')
ylabel('$y(t)$')

grid on
axis tight

set(findall(hfig,'-property','Box'),'Box','off') % optional
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') 
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
print(hfig,fname,'-dpng','-r400')


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