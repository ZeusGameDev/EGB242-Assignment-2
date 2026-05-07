%%%% EGB242 Assignment 2, Section 3 %%
% This file is a template for your MATLAB solution to Section 3.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;
load DataA2 imagesReceived;

% Begin writing your MATLAB solution below this line.

% 3.1
im1D = imagesReceived(1, :);

im2D = reshape(im1D, 480, 640);

figure;
imshow(im2D);

% 3.2
t = linspace(0, length(im1D) / 1000, length(im1D));

f_vec = linspace(-500,500,length(im1D));
f = abs(fftshift(fft(im1D)));

figure;
subplot(1, 2, 1);
plot(t, im1D);
xlim([0, t(end)]);
title("Time domain representation of image signal");
xlabel("Seconds (s)")
ylabel("Amplitude")

subplot(1, 2, 2);
plot(f_vec, f);
ylim([0, 50000])
title("Frequency domain representation of image signal");
xlabel("Frequency (Hz)")
ylabel("Magnitude")

% Time domain representation shows that the noise clears up in the middle
% of the transmission, which is supported by the image being clearer near
% the center column. The frequency Domain shows a gradual increas in the
% magnitude of frequencies after approximately 200 Hz when it si expected
% that they continue to tail off.

% 3.3

% Passive Filter 1 Response
passive_filter1 = (1j .* 212.77 .* f_vec) ./ (-(f_vec.^2) + 1j .* 473.40 .* f_vec + 17730.50);

% Passive Filter 2 Response
passive_filter2 = 17730.50 ./ (-(f_vec.^2) + 1j .* 396.10 .* f_vec + 17730.50);

% Active Filter 1 Response
active_filter1 = -(f_vec.^2) ./ (-(f_vec.^2) + 1j .* 2439.02 .* f_vec + 1487209.99);

% Active Filter 2 Response
active_filter2 = 1487209.99 ./ (-(f_vec.^2) + 1j .* 2439.02 .* f_vec + 1487209.99);



figure;
subplot(2, 2, 1)
plot(f_vec, passive_filter1);

subplot(2, 2, 2)
plot(f_vec, passive_filter2);

subplot(2, 2, 3)
plot(f_vec, active_filter1);

subplot(2, 2, 4)
plot(f_vec, active_filter2);