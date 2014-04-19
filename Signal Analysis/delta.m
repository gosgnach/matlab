function [ deltaTime, deltaTimeArray ] = delta( time1, time2 )
% DELTA is a function to calculate the difference between two double, array
% or vector values.
% INPUT VARIABLES----------------------------------------------------------
% Name          Type            Description
% time1         double          Relative value, can be a be a single value
%                                 or an array/vector of values.
% time2         double          Measurement value, can be a be a single
%                                value or an array/vector of values.
% -------------------------------------------------------------------------
% OUTPUT VARIABLES---------------------------------------------------------
% Name              Type            Description
% deltaTime         double          Mean time difference between time1 and
%                                     time2.
% deltaTimeArray    double          time2 - time1.
% -------------------------------------------------------------------------

if (numel(time1) ~= numel(time2))
    disp('Unequal amount of bursts between the two data sets.')
else
    deltaTimeArray = time2 - time1;
end

deltaTime = mean(deltaTimeArray);
end

