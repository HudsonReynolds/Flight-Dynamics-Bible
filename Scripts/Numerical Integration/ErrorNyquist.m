% Numerical Integrator Error Showcase:
close all; clear; clc;

% initial condition, y(0) = 0
y = 0;
yRK2 = y;
yRK4 = y;

% timespan over which to integrate:
dt = 0.5;
tEnd = 2;
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
tspanCurve = linspace(0,tEnd, 1000);

%figure plotting:
hfig = figure;  % save the figure handle in a variable
fname = 'Numerical Integrator Nyquist 1';

picturewidth = 20; % set this parameter and keep it forever
hw_ratio = 0.75; % feel free to play with this ratio
set(findall(hfig,'-property','FontSize'),'FontSize',18) % adjust fontsize to your document

plot(t, y, '.', LineStyle='-', MarkerSize= 12)
hold on
plot(t, yRK2, '.', LineStyle='-', MarkerSize= 12)
plot(t, yRK4, '.', LineStyle='-', MarkerSize= 12)
plot(tspanCurve, 1/(4*pi)*sin(4*pi*tspanCurve), LineWidth=1)

legend('Explicit Euler', 'RK2', 'RK4', '$y=\frac{1}{4\pi}sin(4\pi t)$', 'Location', 'northwest')

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

% Part II:

dtList = [0.4,0.26,0.1];

yRK42 = zeros(4, 32);
%tList = zeros(4,32);

forLength = tEnd ./ dtList;

tList1 = 0:dtList(1):tEnd;
tList2 = 0:dtList(2):tEnd;
tList3 = 0:dtList(3):tEnd;

int1 = rk4Integrate(dtList(1), tList1);
int2 = rk4Integrate(dtList(2), tList2);
int3 = rk4Integrate(dtList(3), tList3);

%figure plotting:
hfig = figure;  % save the figure handle in a variable
fname = 'Numerical Integrator Nyquist 2';

picturewidth = 20; % set this parameter and keep it forever
hw_ratio = 0.9; % feel free to play with this ratio
set(findall(hfig,'-property','FontSize'),'FontSize',18) % adjust fontsize to your document

plot(tList1, int1, '.', LineStyle='-', MarkerSize= 12, LineWidth=1)
hold on
plot(tList2, int2, '.', LineStyle='-', MarkerSize= 12, LineWidth=1)
plot(tList3, int3, '.', LineStyle='-', MarkerSize= 12, LineWidth=1)

plot(tspanCurve, 1/(4*pi)*sin(4*pi*tspanCurve), LineWidth=1.5)

legend('$\Delta t=0.4s$', '$\Delta t=0.26s$', '$\Delta t=0.1s$','$y=\frac{1}{4\pi}sin(4\pi t)$', 'Location', 'northwest')

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
out = cos(2*pi/0.5*t);
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

% rk4 integrator
function out = rk4Integrate(dt, t)
Y = 0;

    for i=1:length(t)-1
        % numerically integrate with RK4
        Y(i+1) = rk4(@(t,y)YDot(t(i),y), dt, t, Y(i));
    end
    out = Y;
end


