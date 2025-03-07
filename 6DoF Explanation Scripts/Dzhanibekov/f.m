function [vecOut] = RotationMatrix(vecIn, quatIn, bodyOrEarth)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: DCM
% Author: Hudson Reynolds - Created: 7/2/2024
% Last Modified: 7/8/2024
%
% Description: This program takes inputs from the body or earth frame and
% converts it to the alternate frame given the euler angles using a
% rotation matrix.
%
%
% Inputs:
% vecIn = 3x1 column vector [x;y;z]
% angleIn = 3x1 vector with euler angle inputs (x-angle, y-angle, z-angle)
% quatIn = 4x1 vector with euler parameters
% bodyOrEarth = 0 -> convert earth to body, 1 -> convert body to earth
%
% Outputs:
% vecOut = 3x1 vector in the converted frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp(quatIn.')

% do this for some weird ass edge cases
rotIn = real(quatIn.');

R = quat2dcm(rotIn);

%perform transformation:
if bodyOrEarth == 0
    vecOut = R * vecIn;

elseif bodyOrEarth == 1
    vecOut = R.' * vecIn;
else
    fprintf("Input for body or earth frame is invalid\n");
end

end


