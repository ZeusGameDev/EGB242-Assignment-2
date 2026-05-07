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
f = fftshift(fft(im1D));

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

% Looking for a low pass filter with a pass band on 200 Hz

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
title("Frequency Domain representation of Passive Filter 1 Transfer Function");
xlabel("Frequencey (Hz)")
ylabel("Magnitude")
% Band Pass Filter - Wrong type of filter

subplot(2, 2, 2)
plot(f_vec, passive_filter2);
title("Frequency Domain representation of Passive Filter 2 Transfer Function");
xlabel("Frequencey (Hz)")
ylabel("Magnitude")
% Low Pass Filter - Sharp drop off with minimum at 200 Hz

subplot(2, 2, 3)
plot(f_vec, active_filter1);
title("Frequency Domain representation of Active Filter 1 Transfer Function");
xlabel("Frequencey (Hz)")
ylabel("Magnitude")
% Inverting High Pass Filter - Wrong type

subplot(2, 2, 4)
plot(f_vec, active_filter2);
title("Frequency Domain representation of Active Filter 2 Transfer Function");
xlabel("Frequencey (Hz)")
ylabel("Magnitude")
% Low Pass filter - Slow drop off, only reaches 0.7 by 500 Hz


% Passive filter 2 seems best

% 3.4

image_filtered_f = f .* passive_filter2;

image_filtered_t = ifft(ifftshift(image_filtered_f));

image_filtered = reshape(image_filtered_t, 480, 640);

figure;
subplot(2, 2, 1);
plot(f_vec, image_filtered_f);
ylim([0, 50000])
title("Frequency domain representation of filtered image signal");
xlabel("Frequency (Hz)")
ylabel("Magnitude")

subplot(2, 2, 2);
plot(t, image_filtered_t);
ylim([-10, 10])
title("Time domain representation of filtered image signal");
xlabel("Seconds (s)")
ylabel("Amplitude")

subplot(2, 2, 3);
imshow(im2D);
title("Original noisy image for reference");

subplot(2, 2, 4);
imshow(image_filtered);
title("Filtered image")

% Final image is much clearer, most noise is remove but still slightly
% visable. 

% 3.5

% Load Images
image2_noisy = imagesReceived(2, :);
image3_noisy = imagesReceived(3, :);
image4_noisy = imagesReceived(4, :);

% Transform to frequency domain
image2_f = fftshift(fft(image2_noisy));
image3_f = fftshift(fft(image3_noisy));
image4_f = fftshift(fft(image4_noisy));

% Filter
image2_filtered_f = image2_f .* passive_filter2;
image3_filtered_f = image3_f .* passive_filter2;
image4_filtered_f = image4_f .* passive_filter2;

% Transform back to time domain
image2_filtered = ifft(ifftshift(image2_filtered_f));
image3_filtered = ifft(ifftshift(image3_filtered_f));
image4_filtered = ifft(ifftshift(image4_filtered_f));

% Reshape to display image
image2 = reshape(image2_filtered, 480, 640);
image3 = reshape(image3_filtered, 480, 640);
image4 = reshape(image4_filtered, 480, 640);

figure;
subplot(2, 2, 1);
imshow(image_filtered);

subplot(2, 2, 2);
imshow(image2);

subplot(2, 2, 3);
imshow(image3);

subplot(2, 2, 4);
imshow(image4);

% Image 3 has the best landing spot, despite being pretty rocky it is the
% only wide open flat area of the given images
