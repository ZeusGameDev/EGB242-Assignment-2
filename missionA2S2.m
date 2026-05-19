%% EGB242 Assignment 2, Section 2 %%
% This file is a template for your MATLAB solution to Section 2.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;

% Begin writing your MATLAB solution below this line.

%2.1 - Inverse Laplace Transform.
%

%25 seconds, 10000 samples
t = linspace(0, 25, 10000);

% idk how to put u(t) in so ill do without for now
psiOut = 4*exp(-0.5*t) + 2*t - 4;

% step input
% = 1 doesnt work
% needs to be same length as t
stepInput = ones(size(t));

figure(1)
plot(t, psiOut, t, stepInput);
xlabel("Seconds (s)")
ylabel("Yaw (rad)")
title("Yaw Output Over The Time Domain")
legend("Step Response", "Step Input")

%yaw keeps increasing
%The motor alone is not sufficient. This is because the angle does not
%converge on a constant angle.


%
%
%2.2 / 2.3 - Supervisor suggests a potentiometer attached to the motors axle
%
%
% 
% The potentiometer should fix the problem by creating a damped system,
% resulting in the angle converging.
% Id say the suggestion is justified, as it now converges on a single point


%apparently Ive done too much working.
%potPsiOut = ((2*pi) / s) + (-2*pi*s -pi)/(s^2 + 0.5*s + (1/(2*pi)));
Fs = tf( 1, [1, 0.5, 1]);
%timePotPsiOut = ilaplace(potPsiOut);
%errors, needs to convert to double
figure(2)
%errors telling me to apply "subs: function first
%potTimeFinal = double(subs(timePotPsiOut, t, linspace(0, 25, 10000)));

figure(2)
lsim(Fs, stepInput, t); 

%
% The system now makes the angle of the motor converge on a single point
% which does improve on the previous situation where the motor kept
% turning. However, it converges on the angle of 1 randian, where we want
% the system to go between 0rad and 2pi radians. 
% 
% 
% 




