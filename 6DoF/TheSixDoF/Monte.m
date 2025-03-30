%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: MainRK4
% Author: Hudson Reynolds
%
% Description: Runs the 6DoF with variable thrust-to-weight-ratio to analyze stability
%
% Inputs: N/A
%
% Outputs:
% see subfunctions for specific outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
close all
TRIALS = 25;


pos = [0;0;0];
vel = [0;0;0];
omega = [0;0;0];
DEG1 = 0.0174533; %[radians]



%output lists
Yf_list = [];
Zf_list = [];
T_list = [];

tic;

for i = 1:10

    TWR(i) = 3.9 + 0.1 * i;
    mInit = 74.69;
    g = 9.81;
    thrustMag = TWR(i) * mInit * g;
    burnTime = 49400 / thrustMag;

    dt = 0.1;
    time = burnTime;
    arrayLength = (time / dt);
    tspan = linspace(0,time,arrayLength+1);

    %huge stuff
    rasData = readmatrix("inputs\RasAeroData.CSV");
    [totCoM, totMass] = VariableCoM(dt, tspan, 0);
    
    windData = readmatrix("WindData.xlsx");

    for trial = 1:TRIALS
    %random angle
    angleVector = [0; randn*DEG1 ; randn*DEG1];
    quatVector = eul2quat(angleVector.', "XYZ").';
    Init = [pos;vel;omega;quatVector];

    %random constants
    randomThrust = 4270.29 + randn*500;
    params = [thrustMag,burnTime];

    %tic;
        [timeArray, out] = ode45(@(time,input) RK4Integrator(time,input,rasData,totCoM,totMass, windData, params), tspan, Init);
    %toc;

    posArray = [out(:,1), out(:,2), out(:,3)];
    %velArray = [out(:,4), out(:,5), out(:,6)];
    %omega = [out(:,7), out(:,8), out(:,9)];
    %quatArray = [out(:,10), out(:,11), out(:,12), out(:,13)];

    for k = 1:numel(timeArray)
        [~, machArray(k,1), AoArray(k,1)] = RK4Integrator(timeArray(k), out(k,:), rasData, totCoM, totMass, windData, params);
    end

    maxAoA(i, trial) = max(AoArray(1:130))


    end

end

maxAoA = transpose(maxAoA);

    stdev = std(maxAoA);
    meanval = mean(maxAoA);

toc;


figure(1)

hfig = figure;  % save the figure handle in a variable
hold on

fname = 'MonteCarlo2';

picturewidth = 20; % set this parameter and keep it forever
hw_ratio = .7; % feel free to play with this ratio
set(findall(hfig,'-property','FontSize'),'FontSize',16) % adjust fontsize to your document

errorbar(TWR, meanval, stdev ,'o', 'Color', 'b')
title('Maximum AoA during Engine Burn Monte Carlo')
xlabel('Thrust to Weight Ratio [-]')
ylabel('Maximum Angle of Attack [deg]')

grid on

xlim([2.9 6])

set(findall(hfig,'-property','Box'),'Box','off') % optional
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') 
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
%print(hfig,fname,'-dpdf','-painters','-fillpage')
print(hfig,fname,'-dpng','-r300')
