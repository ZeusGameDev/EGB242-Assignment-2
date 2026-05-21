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
% 2.5
%
%


%newTransfer = (Gg) / (s*(s+0.5) * Hg * Gg);

%testing Kfd changing and Kfwd = 1;
testValues = [0.1, 0.2, 0.5, 1, 2];
figure(3);
for i = testValues
    %doesnt like me having these outside the for loop
    Kfwd = 1;
    Kfd = i;
    newTransfer = tf(Kfwd, [1, 0.5, Kfwd*Kfd]);
    lsim(newTransfer, stepInput, t);
    hold on;
end
legend("0.1", "0.2", "0.5", "1", "2")
title("the effect of Kfb on the step response")

% Kfd changed where the settling value is. at 0.1 it settles at around 10
% rads, with it decreasing down to 0.5 radians at a value of 2.
hold off;
figure(4);
for i = testValues
    %doesnt like me having these outside the for loop
    Kfwd = i;
    Kfd = 1;
    newTransfer = tf(Kfwd, [1, 0.5, Kfwd*Kfd]);
    lsim(newTransfer, stepInput, t);
    hold on;
end
legend("0.1", "0.2", "0.5", "1", "2")
title("the effect of Kfwd on the step response")
hold off;

%Kfwd appears to alter the response time, with the system reacting to the
%step input faster, but also increasing the %overshoot

%2.6

%Tp = 15
%between 0 and 2pi
% 0.1 * input = 10
% input = 100
% 100 * kfd = 2pi
% kfd = 100/2pi
% kfd = 50/pi

wn = 0.3261363341;
zeta = 0.766550592;

newKfd = 1/(2*pi);
newKfwd = (wn^2) / newKfd;
cameraTF = tf(newKfwd, [1, 0.5, newKfwd*newKfd]);
figure(5);
lsim(cameraTF, stepInput, t);

%stepinfo(cameraTF)

%
% 2.7
%

%panorama
%from 30 degrees to 210 degrees

% 30 * pi/180
% = pi/6
% /2pi to get voltage
%   1/12V

% 210 * pi/180
% = 7pi / 6
% /2pi to get voltage
% = 7/12

[startIm, finalIm] = cameraPan((1/12), (7/12), cameraTF);

% It took around 23 seconds to pan from the initial angle to the final
% angle. It overshot the final angle by 3-4 degrees before panning back. 
% time to 