function [windDataOut] = parseWind(windData, month)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: stoppingCondition
% Author: Hudson Reynolds - Created: 1/28/2025
%
% Description: This function stops the rk4 integration once a certain
% condition is met. Currently accepts apogee and full run as cases, but is
% generally extensible to any state.
%
% Inputs: 
% tspan = array of time values for total simulation run time for the given
%         time step [s]
%
% Init = initial cartesian elements vector
%
% condition = stopping condition expression
%
% Outputs:
% value  = value which has met condition
% isterminal = 1 when the integration is stopped
% direction = 0 in nominal case.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%output the wind height in meters
windHeight = windData(:,1) * 100;

switch lower(month)
    case 'jan'
        mag = 2;
        dir = 3;
    case 'feb'
        mag = 4;
        dir = 5;
    case 'mar'
        mag = 6;
        dir = 7;
    case 'apr'
        mag = 8;
        dir = 9;
    case 'may'
        mag = 10;
        dir = 11;
    case 'jun'
        mag = 12;
        dir = 13;
    case 'jul'
        mag = 14;
        dir = 15;
    case 'aug'
        mag = 16;
        dir = 17;
    case 'sep'
        mag = 18;
        dir = 19;
    case 'oct'
        mag = 20;
        dir = 21;
    case 'nov'
        mag = 22;
        dir = 23;
    case 'dec'
        mag = 24;
        dir = 25;
end


windMag = windData(:,mag);
windMag(isnan(windMag)) = 0;

windDir = windData(:,dir);
windDir(isnan(windDir)) = 0;

windDataOut = [windHeight, windMag, windDir];

