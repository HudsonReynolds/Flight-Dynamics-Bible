function [paraDragForce, mainChuteTime] = PostApogeeDragForces(alt, vel, time, rho, mainChuteTime, output)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP-L FLIGHT DYNAMICS:
% 
% Title: PostApogeeDragForces
% Author: Preston Wright - Created: 8/3/24
% 
% Description: Takes the current specs of the rocket including: altitude, 
% velocity, euler angles, simulation timestamp, and main chute deployment
% time to calculate the vertical and lateral drag forces produced by the 
% drogue and main parachutes when applicable for each.
%
% Inputs: alt - current altitude of the rocket            [1x3 vector - m]
%         vel - current velocity of the rocket          [1x3 vector - m/s]
%         angle - current euler angles of the rocket    [1x3 vector - rad]
%         time - current time the simulation is at                     [s]
%         rho - current air density                               [kg/m^3]
%         mainChuteTime - time of simulation main chute opens          [s]
%         output - 0 to turn off recovery, 1 to turn on                [-]
%
% Outputs: paraForceBody - parachute drag force in the body frame      [N]
%          mainChuteTime - time of simulation main chute opens: this
%                          variable is zero until it takes a value     [s]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization

% Conversion Constants
ft2m = 0.3048; % ft to m

% Other Constants
deformVal = 0.70;                   % Deformation value of inflated chute area
                                    % *This is an approximate value due to
                                    % the difficulty to calculate it*

% Parachute parameters
drogueCd = 0.97;                    % cD for the drogue chute
drogueDia = 4.166666667 * ft2m;   % drogue  diameter [m]

mainCd = 2.2;                       % cD for the main parachute
mainDia = 16.66666667 * ft2m;       % main chute diameter [m]
mainDeployAlt = 304.8;              % main chute deployment altitude [m]
mainDeployTime = 5;                 % main chute deployment time [s]

% Velocity Components
velVert = vel(1);
velLat = [vel(2); vel(3)];

%% Parachute Drag Force Calculations

% Ensures drag from the parachutes is implemented only after the rocket has
% reached apogee, and that the correct parachutes are deployed at the
% correct altitudes. 
    
% Drogue deployment only
if alt(1) > mainDeployAlt
    totDia = drogueDia;
    totCd = drogueCd;
    mainChuteTime = 0;

% Main deployment
elseif alt(1) > 0

    % Initialize time main chute deploys at with respect to the
    % simulation
    if mainChuteTime == 0
        mainChuteTime = time;
        totDia = drogueDia;
        totCd = drogueCd;

    % Linearlly interpolate through the main chute deployment (this
    % will likely be improved later)
    elseif time - mainChuteTime <= mainDeployTime
        totDia = drogueDia + mainDia * (time - mainChuteTime)
        totCd = drogueCd + mainCd;

    % Final, full deployment of both the drogue and main chutes
    else
        totDia = drogueDia + mainDia;
        totCd = drogueCd + mainCd;
    end
end

    % Calculate the vertical and lateral area of the parachute: assume
    % adding diameters were sufficient for surface area calculations and
    % the inflated parachute is a perfect semisphere aside from vertical
    % deformation
    vertArea = deformVal * pi * (0.5 * totDia) ^ 2;
    latArea = 0.5 * pi * (0.5 * totDia) ^ 2;

    % Calculate the magnitude of the vertical and lateral drag force
    % produced by the parachute(s)
    vertForceMag = 0.5 * totCd * vertArea * rho * norm(velVert) ^ 2;
    latForceMag = 0.5 * totCd * latArea * rho * norm(velLat) ^ 2;

    % Convert the magnitude of the drag forces into vectors
    vertForce = vertForceMag .* [-velVert / norm(velVert);0;0];
    latForce = latForceMag .* [0;(-velLat / norm(velLat))];

    % Sum the components into a single vector to pass back out of the
    % function

    if output == 1
        paraDragForce = vertForce + latForce;
    else
        paraDragForce = [0;0;0];
    end

end
