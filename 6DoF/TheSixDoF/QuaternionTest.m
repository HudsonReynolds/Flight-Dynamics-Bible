function [eulerAngle, quaternionAngle] = QuaternionTest(angleVector, quatVector, output)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: QuaternionTest
% Author: Hudson Reynolds - Created: 8/25/2024
%
% Description: This function takes the euler angle and quaternion
% representation of the angle and compares the two for testing and
% debugging
%
% Inputs: 
% angleVector = 3x1 Column vector of the current angle
% quatVector = 1x4 vector of the current attitude
% output = 0 -> off, 1-> on.
%
% Outputs:
% eulerAngle = the euler angle representation of the angle
% quaternionAngle = quaternion converted into euler angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

quatVectorTrans = quatVector.';

quaternionAngle = quat2eul(quatVectorTrans, "ZYX");

eulerAngle = angleVector;

if output == 1
    disp(eulerAngle);
    disp(quaternionAngle);
end


%q = quaternion([angleArrayTrans(i,3),angleArrayTrans(i,2)- pi/2,angleArrayTrans(i,1) + pi/2],"euler","ZYX","frame");