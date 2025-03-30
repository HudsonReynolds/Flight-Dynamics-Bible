% PSP FLIGHT DYNAMICS:
% 
% Title: MainRK4
% Author: Hudson Reynolds - Created: 9/21/2024
% Last Modified: 3-26-2025
% 
% Description: This is the overarching function that runs the 6-DoF,
% calling all neccesary functions to run the simulation. The overarching
% simulation structure uses an RK4 structure using ODE45.
% 
% Inputs: N/A
% 
% Outputs:
% Graph and value outputs. See subfunctions for specific outputs

%% KNOWN ISSUES:
% post apogee attitude dynamics are not fully finished, attitude in this
% regime is likely incorrect

% non-zero AoA calculations for lift and drag need better modelling

% Monte Script is not up to date with main.

% wind seems more powerful than in should be.

%% Initialization:
% clear the console and figures before running the code:
clear;clc;close all

%% Simulation Settings:

% endCondition
% possible:
% set to 'apogee' for apogee
% set to 'burnout' for burnout
% set to 'full' for full simulation w/ recovery
% set to '#.#' for a custom run time (numeric inputs only)
endCondition = 'apogee';

%turn outputs on and off
outputs = 'on';

% run rotation visualization (outputs must be on also)
rotationVis = 'on';

% change the month for wind data (First 3 letters of month):
month = 'Mar';

% turn wind on and off
windOnOff = 'on';

% CMS or Rocket 4, more options possible in future
% possible:
% CMS
% R4
rocket = 'CMS';

% create a time array to span the simulation time. Use 500s or more
% w/ recovery on.The code will self-terminate after reaching end condition so no
% need to reduce this value for faster computation.

dt = 0.1;

if strcmpi('burnout', endCondition) == 1
    time = constant.burnTime;
elseif ~isnan(str2double(endCondition)) == 1
    time = round(str2double(endCondition),1);
else
    time = 500;
end

arrayLength = (time / dt);
tspan = linspace(0,time,arrayLength+1);

% position (x,y,z)
pos = [0;0;0];
% velocity (xdot,ydot,zdot)
vel = [0;0;0];
% initial angle (z angle, y angle, x angle) - following 3-2-1 sequence
angleVector = [0.1;0.1;0];
% initial rotation rate (x rate, y rate, z rate)
omega = [0;0;0];
% initalize the quaternion based on the euler angle input:
quatVector = eul2quat(angleVector.', "ZYX").';
% initial state vector
Init = [pos;vel;omega;quatVector];

% import aerodynamics data

if strcmpi(rocket, 'CMS') == 1
    rasData = readmatrix("Inputs/RasAeroDataCulled2.CSV");
elseif strcmpi(rocket, 'R4') == 1
    rasData = readmatrix("RASAero\Final_with_pumps.CSV");
else
end

% import wind data
windData = readmatrix("Inputs/WindData.xlsx");
windDataInput = parseWind(windData, month);

% import atmosphere;
atmosphere = readmatrix("Inputs/AtmosphereModel.csv");

% create an array of the center of mass, mass, and moment of inertia of the
% rocket
[totCoM, totMass, MoI] = VariableCoM(dt, tspan, 0);

% additional options for RK4 (stop after reaching final condition)
opt = odeset('Events', @(tspan, Init) stoppingCondition(tspan, Init, endCondition));

%% RK4:
tic;
[timeArray, out] = ode45(@(time,input) RK4Integrator(time,input,rasData,atmosphere,totCoM,totMass,MoI,windDataInput,windOnOff, rocket, 1), tspan, Init, opt);
toc;

%% Outputs:
% output additional arrays from the integrator
for k = 1:numel(timeArray)
    [~, machArray(k,1), AoArray(k,1), accel(k,:)] = RK4Integrator(timeArray(k), out(k,:), rasData,atmosphere,totCoM, totMass, MoI, windDataInput, windOnOff, rocket);
end

if strcmpi('on', outputs) == 1
    % make the outputs real (long monte carlo runs can generate complex values)
    out = real(out);
    AoArray = real(AoArray);
    
    % parse rk4 outputs:
    posArray = [out(:,1), out(:,2), out(:,3)];
    
    velArray = [out(:,4), out(:,5), out(:,6)];
    
    omega = [out(:,7), out(:,8), out(:,9)];
    
    quatArray = [out(:,10), out(:,11), out(:,12), out(:,13)];
    
    % find end conditions for graphs / animations
    
    if isempty((find(posArray(:,1) < 0, 1)))
        endTime = length(AoArray) * dt;
    else
        endTime = min((find(posArray(:,1) < 0, 1)) * dt, arrayLength * dt);
    end
    
    % grab parameters at max Q and off the rail
    [maxVel, maxIndex] = max(out(:,4));
    maxqAccel = accel(maxIndex,1);
    maxqpos = posArray(maxIndex,1);
    
    machTable = rasData(1:300,1);
    cdTable = rasData(1:300,3);
    maxqMach = machArray(maxIndex);
    [~, maxqMachIndex] = min(abs(machTable-maxqMach));
    maxqCD = cdTable(maxqMachIndex);
    
    [~, railIndex] = min(abs(posArray(1:100,1)-constant.railHeight));
    railVel = out(railIndex,4);
    railAccel = accel(railIndex,1);
    
    railMach = machArray(railIndex);
    [~, railMachIndex] = min(abs(machTable-railMach));
    railCD = cdTable(railMachIndex);
    
    apogee = max(posArray(:,1));
    
    fprintf("Parameters at Max Q:\n")
    fprintf(" Velocity: %.2f m/s\n Mach: %.3f\n Acceleration: %.3f m/s^2\n Drag Coefficient: %.4f\n",maxVel, maxqMach, maxqAccel, maxqCD);
    fprintf("Off-Rail Parameters:\n")
    fprintf(" Velocity: %.2f m/s\n Mach: %.3f\n Acceleration: %.3f m/s^2\n Drag Coefficient: %.4f\n",railVel, railMach, railAccel, railCD);
    fprintf("Rocket Apogee: %.2f\n", apogee)

%% Plotting:

    colorlist = ["#ff595e", "#ff924c", "#ffbe0b", "#8ac926", "#1982c4", "#6a4c93", "#06402B"];
    
    %figure(1)
    % Earth Frame XYZ position:
    
    hfig = figure;  % save the figure handle in a variable
    fname = 'Cartesian Elements';
    
    picturewidth = 20; % set this parameter and keep it forever
    hw_ratio = .6; % feel free to play with this ratio
    
    hold on
    plot(timeArray, posArray(:,1), 'Color', colorlist(1));
    plot(timeArray, posArray(:,2), 'Color', colorlist(2));
    plot(timeArray, posArray(:,3), 'Color', colorlist(3));
    
    xlim([0, endTime]);
    title("Rocket Cartesian Elements in Earth Frame")
    xlabel("Time (s)")
    ylabel("Distance [m]")
    
    yyaxis right
    plot(timeArray, velArray(:,1), 'Color', colorlist(4), 'LineStyle','-');
    plot(timeArray, velArray(:,2), 'Color', colorlist(5), 'LineStyle','-');
    plot(timeArray, velArray(:,3), 'Color', colorlist(6), 'LineStyle','-');
    ylabel("Velocity[m/s]")
    legend("$X$","$Y$","$Z$", "$V_x$", "$V_y$", "$V_z$");
    
    ax = gca;
    ax.YAxis(1).Color = 'k';
    ax.YAxis(2).Color = 'k';
    
    grid on
    
    set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
    pos = get(hfig,'Position');
    set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
    %print(hfig,fname,'-dpdf','-painters','-fillpage')
    %print(hfig,fname,'-dpng','-r300')
    
    % Euler Parameters:
    hfig = figure;
    plot(timeArray, quatArray);
    xlim([0,endTime]);
    title("Euler Parameters")
    xlabel("Time (s)")
    ylabel("Euler Parameters")
    legend('q0', 'q1', 'q2', 'q3');
    
    % Angle of Attack:
    hfig = figure;
    plot(timeArray, AoArray);
    xlim([0,endTime]);
    title("Angle of Attack")
    xlabel("Time (s)")
    ylabel("Angle of Attack [deg]")
    
    % Rocket Trajectory Plot:
    hfig = figure;
    plot3(posArray(1:int32(endTime / dt),3), posArray(1:int32(endTime / dt),2), posArray(1:int32(endTime / dt),1))
    % plot3(posArray(1:endTime / dt,3), posArray(1:endTime / dt,2), zeros(endTime / dt), '--')
    % plot3(posArray(1:endTime / dt,3), zeros(endTime / dt), posArray(1:endTime / dt,1), '--')
    % plot3(zeros(endTime / dt), posArray(1:endTime / dt,2), posArray(1:endTime / dt,1), '--')
    view(43,24);
    xlabel('Dist North (m)');
    ylabel('Dist East (m)');
    zlabel('Height (m)');
    axis equal;
    grid minor;


    if strcmpi('on', rotationVis) == 1
        % run the rotation visualizer script
        playbackSpeed = 1;
        quatArray = quatArray';
        posArray = posArray';
        
        RotationsVisualizer(posArray, quatArray, timeArray, endTime, dt, playbackSpeed, 0);
    
        %% csv outputs:
    
        output = horzcat(timeArray, machArray);
        
        writematrix(output, 'Outputs/MachTime.csv')
    end
end