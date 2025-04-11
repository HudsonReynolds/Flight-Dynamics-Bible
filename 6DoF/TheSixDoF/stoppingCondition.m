function [value, isterminal, direction] = stoppingCondition(tspan, Init, condition)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: stoppingCondition
% Author: Hudson Reynodls - Created: 1/28/2025
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


if strcmpi('apogee', condition) == 1
    % if velocity is less than 0.
    value = (Init(4) < 0);
    isterminal = 1;   % Stop the integration
    direction  = 0;
else
    % if position is less than 0.
    value = (Init(1) < 0);
    isterminal = 1;   % Stop the integration
    direction  = 0;
end