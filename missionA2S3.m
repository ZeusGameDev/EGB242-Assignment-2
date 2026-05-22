%% %% EGB242 Assignment 2, Section 3 %%
% This file is a template for your MATLAB solution to Section 3.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;
load DataA2 imagesReceived;

% Begin writing your MATLAB solution below this line.

%% 3.1
im1D = imagesReceived(1, :);

im2D = reshape(im1D, 480, 640);

imwrite(im2D,'Location_1_Noisy.png');

figure;
imshow(im2D);

%% 3.2
t = linspace(0, length(im1D) / 1000, length(im1D));

f_vec = linspace(-500,500,length(im1D));
f = fftshift(fft(im1D));

figure;
subplot(1, 2, 1);
plot(t, im1D);
xlim([0, t(end)]);
ylim([-10, 10])
title("Time domain representation of image signal");
xlabel("Seconds (s)")
ylabel("Amplitude")

subplot(1, 2, 2);
plot(f_vec, f);
ylim([0, 20000])
title("Frequency domain representation of image signal");
xlabel("Frequency (Hz)")
ylabel("Magnitude")

% Time domain representation shows that the noise clears up in the middle
% of the transmission, which is supported by the image being clearer near
% the center column. The frequency Domain shows a gradual increas in the
% magnitude of frequencies after approximately 200 Hz when it si expected
% that they continue to tail off.

%% 3.3

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

%% 3.4

image_filtered_f = f .* passive_filter2;

image_filtered_t = ifft(ifftshift(image_filtered_f));

image_filtered = reshape(image_filtered_t, 480, 640);

imwrite(image_filtered,'Location_1_Clean.png');

figure;
subplot(1, 2, 1);
plot(t, image_filtered_t);
xlim([0, t(end)]);
ylim([-4, 4])
title("Time domain representation of filtered image signal");
xlabel("Seconds (s)")
ylabel("Amplitude")

subplot(1, 2, 2);
plot(f_vec, image_filtered_f);
ylim([0, 20000])
title("Frequency domain representation of filtered image signal");
xlabel("Frequency (Hz)")
ylabel("Magnitude")

% Final image is much clearer, most noise is remove but still slightly
% visable. 

%% 3.5

function img_filtered_2D = filter_image(image_noisy_1D, filter)
    % Transform to frequency domain
    image_f = fftshift(fft(image_noisy_1D));
    % Filter
    image_filtered_f = image_f .* filter;
    % Transform back to time domain
    image_filtered = ifft(ifftshift(image_filtered_f));
    % Reshape to display image
    img_filtered_2D = reshape(image_filtered, 480, 640);
end

% Load Images
image2_noisy = imagesReceived(2, :);
image3_noisy = imagesReceived(3, :);
image4_noisy = imagesReceived(4, :);

% use funtion to filter image
image2 = filter_image(image2_noisy, passive_filter2);
image3 = filter_image(image3_noisy, passive_filter2);
image4 = filter_image(image4_noisy, passive_filter2);

figure;
subplot(2, 2, 1);
imshow(image_filtered);
title("Image 1");

subplot(2, 2, 2);
imshow(image2);
title("Image 2");

subplot(2, 2, 3);
imshow(image3);
title("Image 3");

subplot(2, 2, 4);
imshow(image4);
title("Image 4");

% Image 3 has the best landing spot, despite being pretty rocky it is the
% only wide open flat area of the given images
