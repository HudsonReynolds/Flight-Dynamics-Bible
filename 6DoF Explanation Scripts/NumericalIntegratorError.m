% Numerical Integrator Error Showcase:
close all; clear; clc;

% Describe our initial ODE:

% describe the state vector, Y:

% initial condition, y(0) = 0
Y = 0;

% timespan over which to integrate:
dt = 0.5;
tEnd = 3;
t = 0:dt:tEnd;

% numerically integrate with explicit euler
for i=1:length(t)
    Y(i+1) = Y(i) + YDot(t(i),Y) * dt;
end

tspan = linspace(0,tEnd, 100);

hfig = figure;  % save the figure handle in a variable
fname = 'Explicit Euler Approximation Figure';

picturewidth = 20; % set this parameter and keep it forever
hw_ratio = 0.75; % feel free to play with this ratio
set(findall(hfig,'-property','FontSize'),'FontSize',18) % adjust fontsize to your document

plot(t, Y(1:end-1), '.', LineStyle='-', MarkerSize= 12)
hold on
plot(tspan, tspan.^2)

legend('Numerical Approximation', '$y=t^2$', 'Location', 'northwest')

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

function[out] = YDot(t,Y)
out = 2 * t;
end