%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
% Outputs: Graph of apogee and runtime with respect to Relative Tolerance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization:
clear
clc
close all
format longg

%% Simulation Settings:
%change whether to go until apogee (apogee) or full flight (any other
%input)
endCondition = 'full';

%turn outputs on and off
outputs = 'off';

% run rotation visualization (outputs must be on also)
rotationVis = 'off';

% change the month for wind data (First 3 letters of month):
month = 'Mar';

% turn wind on and off
windOnOff = 'off';

%% Initial values
% create a time array to span the entire simulation time. Use 500s or more
% w/ recovery on.The code will self-terminate after reaching end condition so no
% need to reduce this value for faster computation.
dt = 0.1;
time = 500;
arrayLength = (time / dt);
tspan = linspace(0,time,arrayLength+1);

pos = [0;0;0];
vel = [0;0;0];
angleVector = [0;0.1;0.1];
omega = [0;0;0];
quatVector = eul2quat(angleVector.', "XYZ").';

Init = [pos;vel;omega;quatVector];

%% Read Matrix
rasData = readmatrix("Inputs/RasAeroData.CSV"); %import aerodynamics data
windData = readmatrix("Inputs/WindData.xlsx"); %import wind data
windDataInput = parseWind(windData, month);
atmosphere = readmatrix("Inputs/AtmosphereModel.csv"); %import atmosphere;

%create an array of the center of mass, mass, and moment of inertia of the
%rocket
[totCoM, totMass, MoI] = VariableCoM(dt, tspan, 0);

X_data = [];
Y_data = [];
Z_data = [];

for lk = 0.25:0.25:10

    rt = 0.1^lk;
    opt = odeset( ...
        Events=@(tspan, Init) stoppingCondition(tspan, Init, endCondition), ...
        RelTol=rt ...
    );

    tic;
    [timeArray, out] = ode45(@(time,input) RK4Integrator(time,input,rasData,atmosphere,totCoM,totMass,MoI,windDataInput,windOnOff,1), tspan, Init, opt);
    Z_data(end+1) = toc; %runtime

    out = real(out);
    apogee = max(out(:,1));
    
    X_data(end+1) = rt;
    Y_data(end+1) = max(out(:,1)); %apogee
    disp(lk)
end

%% Plots
figure(1);
semilogx(X_data,Y_data,MarkerSize=30,Marker='.');
xlabel("Relative Tolerance (log scale)",FontSize=16)
ylabel("Apogee (m)",FontSize=16)
title("Apogee vs Relative Tolerance",FontSize=18)

figure(2);
semilogx(X_data,Z_data,Color='red',MarkerSize=30,Marker='.');
xlabel("Relative Tolerance (log scale)",FontSize=16)
ylabel("Runtime (s)",FontSize=16)
title("Runtime vs Relative Tolerance",FontSize=18)
