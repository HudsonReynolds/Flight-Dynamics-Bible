function [totCoM, totMass, MoI] = VariableCoM(dt, tspan, graph)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: VariableCoM
% Author: Preston Wright - Created: 9/28/2024
%
% Description: This function calculates an array for the center of mass in 
% meters from the nose of the rocket. Uses given initialized parameters for 
% the rocket to approximate the center of mass 
%
% Inputs: 
% dt = given simulation time step [s]
% tspan = array of time values for total simulation run time for the given
%         time step [s]
% graph = boolean operator that controls the output of CoM visualizations:
%         1 will output visuals, 0 will not
%
% Outputs:
% totCoM  = array of all center of mass values for the rocket with respect
%           to time [s|m]
% totMass = array of all total mass values for the rocket with respect to
%           time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Individual testing
    % Comment the function header out, uncomment this for testing
    % Uncomment function header, comment this out for normal use
% dt = 0.1;
% time = 500;
% arrayLength = (time / dt);
% tspan = linspace(0,time,arrayLength+1);
% graph = 1;

%% Conversions

% Initialize all the conversion multipliers
% NOTE: all conversions are scalar multiples in the code
IN2M = 0.0254;                          % Inches to meters
LBM2KG = 0.45359237;                    % Pound mass to kilograms
FT2M = 0.3048;                          % Feet to meters
IN2M3 = 0.00001639;                     % Inches cubed to meters cubed
densImp2Met = 27679.9;                  % Imperial to metric density units


%% Initializations

% Propellant initializations
massDry = 49.877;                       % Initial dry mass [kg]
massWetInit = 19.252;                   % Initial wet mass [kg]
ullageFactor = 0.95;                    % Tank fill factor 
loxVol = 1201.10 * ullageFactor;        % Initial lox vol [in^3]
fuelVol = 1299.95 * ullageFactor;       % Initial fuel vol [in^3]
loxDens = 0.03922015;                   % Density of lox [kg/m^3]
fuelDens = 0.01450439;                  % Density of fuel [kg/m^3]

% Flow rate initializations
loxFlow = 2.916 * LBM2KG;               % Flow rate of lox [kg/s]
fuelFlow = 1.188 * LBM2KG;              % Flow rate of fuel [kg/s]
rocketHeight = 16.81 * FT2M;            % Total height of rocket [m]
tankResidual = 0.07;                    % Amount leftover 

% Tank size initializations
tankOD = 6.625 * IN2M;                  % Outer diameter of tank [m]
wallThick = 0.134 * IN2M;               % Wall thickness [m]
tankID = tankOD - 2 * wallThick;        % Inner diameter of tank [m]
tankIArea = pi * (tankID/2)^2;          % Inner tank area [m^2]

% Mass initializations
noseMass = 11 * LBM2KG;                 % Nose mass [kg]
heTMass = 18 * LBM2KG;                  % He tank mass [kg]
midAFMass = 23 * LBM2KG;                % Inner stage mass [kg]
empLoxTMass = 9.05 * LBM2KG;            % Empty lox tank mass [kg]
empFuelTMass = 9.91 * LBM2KG;           % Empty fuel tank mass [kg]
finCanMass = 28 * LBM2KG;               % Fin can mass [kg]
engineMass = 11 * LBM2KG;               % Engine mass [kg]

% Height initializations
noseHeight = 33 * IN2M;                 % Height of the nose [m]
heHeight = 43 * IN2M;                   % He tank height [m]
midAFHeight = 16 * IN2M;                % Inner stage height [m]
loxTHeight = 35.6 * IN2M;               % Lox tank height [m]
fuelTHeight = 39 * IN2M;                % Fuel tank height [m]
finCanHeight = 22 * IN2M;               % Fin can height [m]
engineHeight = 11.77 * IN2M;            % Engine height [m]
totHeight = noseHeight + heHeight ...
    + midAFHeight + loxTHeight + ...
    fuelTHeight + finCanHeight + ...
    engineHeight;                       % Total rocket height [m]

% Array initializations
loxRelCoM = zeros(length(tspan),1);     % Relative CoM for lox in tank [m]
loxMassArr = zeros(length(tspan),1);    % Lox total mass [m]
fuelRelCoM = zeros(length(tspan),1);    % Relative CoM for fuel in tank [m]
fuelMassArr = zeros(length(tspan),1);   % Fuel total mass [m]
loxCoM = zeros(length(tspan),1);        % Lox CoM [m]
fuelCoM = zeros(length(tspan),1);       % Fuel CoM [m]
totCoM = zeros(length(tspan),2);        % Total CoM [m]
totMass = zeros(length(tspan),2);       % Total Mass [m]

%% Initial Calculations

% Initialized heights from nose
noseHFore = noseHeight/2;
heHFore = noseHeight + heHeight/2;
midAFHFore = noseHeight + heHeight + midAFHeight/2;
loxTHFore = noseHeight + heHeight + midAFHeight + loxTHeight/2;
fuelTHFore = noseHeight + heHeight + midAFHeight + loxTHeight + ...
    fuelTHeight/2;
finCanHFore = noseHeight + heHeight + midAFHeight + loxTHeight + ...
    fuelTHeight + finCanHeight/2;
engineHFore = noseHeight + heHeight + midAFHeight + loxTHeight + ...
    fuelTHeight + finCanHeight + engineHeight/2;

% Calculate empty CoM measured from nose
empCoM = (engineMass * engineHFore + finCanMass * finCanHFore + empFuelTMass ...
          * fuelTHFore + empLoxTMass * loxTHFore + midAFMass * midAFHFore ...
          + heTMass * heHFore + noseMass * noseHFore) / massDry;

% Measure height to fuel and lox from nose
heightToLox = noseHeight + heHeight + midAFHeight;
heightToFuel = heightToLox + loxTHeight;

% Measure propellant masses/CoM's from top of respective tank
loxMass = loxVol * loxDens * LBM2KG;
fuelMass = fuelVol * fuelDens * LBM2KG;
loxInitCoM = loxTHeight - (loxVol * ullageFactor * IN2M3 / tankIArea / 2);
fuelInitCoM = fuelTHeight - (fuelVol * ullageFactor * IN2M3 / tankIArea / 2);
finalLoxMass = loxMass / ullageFactor * tankResidual;
finalFuelMass = fuelMass / ullageFactor * tankResidual;

%% Calculations

% Loop through entire time array, updating CoM values along the way
for i = 1:length(tspan)

    % Initialize the first index in every array
    if i == 1

        % Start with initalized values above
        loxRelCoM(i) = loxInitCoM;
        loxMassArr(i) = loxMass;
        fuelRelCoM(i) = fuelInitCoM;
        fuelMassArr(i) = fuelMass;
        
        % Find CoM for propellants by adding relative CoM to tank location
        loxCoM(i) = loxRelCoM(i) + heightToLox;
        fuelCoM(i) = fuelRelCoM(i) + heightToFuel;

        % Initialize total CoM
        totCoM(i,2) = (loxCoM(i) * loxMassArr(i) + fuelCoM(i) * fuelMassArr(i) ...
                      + empCoM * massDry) / (loxMassArr(i) + fuelMassArr(i) ...
                      + massDry);
        totMass(i,2) = loxMassArr(i) + fuelMassArr(i) + massDry;
        
        % Update total simulation time
        totCoM(i,1) = tspan(i);
        totMass(i,1) = tspan(i);

    % Continue for all timesteps where both propellant masses are above the
    % final calculated mass (should approximately coincide with burn time)
    elseif loxMassArr(i-1)>finalLoxMass && fuelMassArr(i-1)>finalFuelMass
        
        % Update propellant masses
        loxMassArr(i) = loxMassArr(i-1) - loxFlow * dt;
        fuelMassArr(i) = fuelMassArr(i-1) - fuelFlow * dt;

        % Update relative propellant CoMs
        loxRelCoM(i) = loxTHeight - (loxMassArr(i) / (loxDens * ...
            densImp2Met) / tankIArea / 2);
        fuelRelCoM(i) = fuelTHeight - (fuelMassArr(i) / (fuelDens * ...
            densImp2Met) / tankIArea / 2);

        % Update propellant CoMs from nose
        loxCoM(i) = loxRelCoM(i) + heightToLox;
        fuelCoM(i) = fuelRelCoM(i) + heightToFuel;
        
        % Calculate total CoM from nose
        totCoM(i,2) = (loxCoM(i) * loxMassArr(i) + fuelCoM(i) * fuelMassArr(i) ...
                      + empCoM * massDry) / (loxMassArr(i) + fuelMassArr(i) ...
                      + massDry);
        totMass(i,2) = loxMassArr(i) + fuelMassArr(i) + massDry;
        
        % Update total simulation time
        totCoM(i,1) = tspan(i);
        totMass(i,1) = tspan(i);

    % Continue if fuel flow is zero (should approximately be post burn
    % time)
    else

        % Use final propellant masses
        loxMassArr(i) = finalLoxMass;
        fuelMassArr(i) = finalFuelMass;

        % Update relative propellant CoMs 
        loxRelCoM(i) = loxTHeight - (loxMassArr(i) / (loxDens * ...
            densImp2Met) / tankIArea / 2);
        fuelRelCoM(i) = fuelTHeight - (fuelMassArr(i) / (fuelDens * ...
            densImp2Met) / tankIArea / 2);

        % Update propellant CoMs from nose
        loxCoM(i) = loxRelCoM(i) + heightToLox;
        fuelCoM(i) = fuelRelCoM(i) + heightToFuel;
        
        % Update total CoM from nose
        totCoM(i,2) = (loxCoM(i) * loxMassArr(i) + fuelCoM(i) * fuelMassArr(i) ...
                      + empCoM * massDry) / (loxMassArr(i) + fuelMassArr(i) ...
                      + massDry);
        totMass(i,2) = loxMassArr(i) + fuelMassArr(i) + massDry;

        % Update total simulation time
        totCoM(i,1) = tspan(i);
        totMass(i,1) = tspan(i);
    end
end

Jxx = 1;
Jyy = 200;
Jzz = 200;

MoI = [Jxx,0,0;0,Jyy,0;0,0,Jzz];

%% Optional CoM graphing output
if graph == 1

    % Initialize arrays and text used for graphing
    totCoMTop = totCoM(:,2);
    loxRelCoMIndividual = loxTHeight - loxRelCoM(:,1);
    fuelRelCoMIndividual = fuelTHeight - fuelRelCoM(:,1);
    txtRock = ['Rocket height: ' num2str(totHeight) ' meters'];
    txtLox = ['Lox tank height: ' num2str(loxTHeight) ' meters'];
    txtFuel = ['Fuel tank height: ' num2str(fuelTHeight) ' meters'];

    % Figure 1 - total CoM of the rocket
    figure(1)
    plot(tspan, totCoMTop, lineWidth=1.5)
    text(25,2.975,txtRock)
    grid on
    title("totalCoM versus time")
    xlabel("time")
    ylabel("CoM from nose [m]")

    % Figure 2 - CoM of the lox tank
    figure(2)
    plot(tspan, loxRelCoM, lineWidth=1.5)
    hold on
    plot(tspan, loxRelCoMIndividual, lineWidth=1.5)
    text(25,0.45,txtLox)
    grid on
    title("loxCoM from top of tank")
    xlabel("time")
    ylabel("loxCoM from top of lox tank")
    legend("From top", "From bottom", location="best")

    % Figure 3 - CoM of the fuel tank
    figure(3)
    plot(tspan, fuelRelCoM, lineWidth=1.5)
    hold on
    plot(tspan, fuelRelCoMIndividual, lineWidth=1.5)
    text(25,0.45,txtFuel)
    grid on
    title("fuelCoM from top of tank")
    xlabel("time")
    ylabel("fuelCoM from top of fuel tank")
    legend("From top", "From bottom", location="best")
end
