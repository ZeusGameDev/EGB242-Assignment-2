%% EGB242 Assignment 2, Section 1 %%
% This file is a template for your MATLAB solution to Section 1.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;
load DataA2 audioMultiplexNoisy fs sid;
% Begin writing your MATLAB solution below this line.
global saveImages;
saveImages = 1;

length = size(audioMultiplexNoisy,2)/fs; % 20 seconds
samples = fs*length;
t = linspace(0, length, samples + 1); t(end) = [];
ts = 1/fs; % sampling period

%% 1.1

figure(1)
plot(t, audioMultiplexNoisy);
xlabel("Seconds (s)")
ylabel("Amplitude")
title("Waveform of transmission channel over 20 seconds")
legend("audio")
fontsize(gcf,scale=1.6)
saveimagewrapper(gcf)

f = linspace(-fs/2, fs/2, samples + 1); f(end) = [];

figure(2)
plot(f,abs(fftshift(fft(audioMultiplexNoisy))))
xlabel("Frequency (Hz)")
ylabel("Magnitude")
legend("transmission channel")
title("Frequencies present in transmission channel over 20 seconds")
ax = gca;
ax.XAxis.Exponent = 0;
ax.YAxis.Exponent = 0;
ax.XAxis.TickDirection = "both";
fontsize(gcf,scale=1.6)
saveimagewrapper(gcf)

%% 1.2
function [audioSignal, demodulatedSignal] = demodulate(signal, carrierFrequency, bandwidth,fs,t)
    carrier = cos(2*pi*carrierFrequency.*t);
    halfBandwidth = bandwidth/2;
    passBand = [(carrierFrequency-halfBandwidth), (carrierFrequency+halfBandwidth)];
    bpFiltered = bandpass(signal, passBand, fs);
    demodulatedSignal = bpFiltered.*carrier;
    demodfft = fft(demodulatedSignal); 
    demodfft(1) = 0; % remove dc offset (recentre signal around 0)
    audioSignal = lowpass(real(ifft(demodfft)),halfBandwidth, fs);
end

% find exact carrier frequency
% visual peaks at approx 8830, 24020, 40190, 56250, 72280
bandwidth = 8000;
halfBandwidth = bandwidth/2;
fcApprox1 = 8830;
fcApprox2 = 24020;
fcApprox3 = 40190;
fcApprox4 = 56250;
fcApprox5 = 72280;

function [peak] = findPeakFrequencyInBand(centre,bandwidth,f, channel)
    halfBandwidth = bandwidth/2;
    searchMask = f > (centre-halfBandwidth) & f < (centre+halfBandwidth)
    [~,idx] = max(abs(fftshift(fft(channel))).* searchMask);
    peak = f(idx);
end

% TODO: do i need fftshift
carrier1 = findPeakFrequencyInBand(fcApprox1, bandwidth, f, audioMultiplexNoisy)

carrier2 = findPeakFrequencyInBand(fcApprox2, bandwidth, f, audioMultiplexNoisy)

carrier3 = findPeakFrequencyInBand(fcApprox3, bandwidth, f, audioMultiplexNoisy)

carrier4 = findPeakFrequencyInBand(fcApprox4, bandwidth, f, audioMultiplexNoisy)

carrier5 = findPeakFrequencyInBand(fcApprox5, bandwidth, f, audioMultiplexNoisy)
%demodulation
[signal1, ~] = demodulate(audioMultiplexNoisy, carrier1,bandwidth,fs,t);
audiowrite("signal1.wav",signal1,fs)
[signal2, ~] = demodulate(audioMultiplexNoisy, carrier2,bandwidth,fs,t);
audiowrite("signal2.wav",signal2,fs)
[signal3, ~] = demodulate(audioMultiplexNoisy, carrier3,bandwidth,fs,t);
audiowrite("signal3.wav",signal3,fs)
[signal4, ~] = demodulate(audioMultiplexNoisy, carrier4,bandwidth,fs,t);
audiowrite("signal4.wav",signal4,fs)
[signal5, ~] = demodulate(audioMultiplexNoisy, carrier5,bandwidth,fs,t);
audiowrite("signal5.wav",signal5,fs)

figure(7)
subplot(5,2,1)
plot(t, signal1);
title("signal 1")
ylabel("Amplitude")

subplot(5,2,2)
plot(f, abs(fftshift(fft(signal1))) );
title("signal 1 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,3)
plot(t,signal2);
title("signal 2")
ylabel("Amplitude")

subplot(5,2,4)
plot(f, abs(fftshift(fft(signal2))) );
title("signal 2 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,5)
plot(t, signal3);
title("signal 3")
ylabel("Amplitude")

subplot(5,2,6)
plot(f, abs(fftshift(fft(signal3))) );
title("signal 3 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,7)
plot(t, signal4);
title("signal 4")
ylabel("Amplitude")

subplot(5,2,8)
plot(f, abs(fftshift(fft(signal4))) );
title("signal 4 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,9)
plot(t, signal5 );
title("signal 5")
xlabel("Seconds (s)")
ylabel("Amplitude")

subplot(5,2,10)
plot(f, abs(fftshift(fft(signal5))) );
title("signal 5 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
xlabel("Frequency (Hz)")
ylabel("Magnitude")

pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1), pos(2), pos(3), 1080]);
saveimagewrapper(gcf)

%% 1.3

% signal of area 1 , and infinite peak. ts is smallest unit of time,
% Area = ts*(1/ts) = 1
dirac = [1/ts,zeros(1,size(t,2)-1)];
impulseResponse = channel(sid, dirac, fs);
H = fft(impulseResponse);
% figure(3)
% plot(t,impulseResponse)

figure(4)
plot(f,abs(fftshift(H)),f ,abs(fftshift(fft(audioMultiplexNoisy))));
xlabel("Frequency (Hz)")
ylabel("Magnitude")
legend("frequency response of channel","audioMultiplexNoisy")
title("Frequencies present in transmission channel over 20 seconds")
fontsize(gcf,scale=1.6)
saveimagewrapper(gcf)

figure(5)
plot(f,sign(fftshift(H)).*abs(fftshift(H))./50,f ,sign(fftshift(fft(audioMultiplexNoisy))).*abs(fftshift(fft(audioMultiplexNoisy))));
% plot(f,abs(fftshift(H)),f ,abs(fftshift(fft(audioMultiplexNoisy))));
xlabel("Frequency (Hz)")
ylabel("Magnitude")
legend("frequency response of channel","audioMultiplexNoisy")
title("frequency response of channel around carrier1 (8330 Hz) and magnitude-frequency response of audioMultiplexNois  ")
ylim([-1*power(10,4) 1*power(10,4)])
xlim([carrier1-bandwidth*0.5 carrier1+bandwidth*0.5])

saveimagewrapper(gcf)

%% 1.4
 
% y(t) = x(t) conv h(t)
% y(f) = x(f) mult h(f)
% tute 6
audioRemoveLTINoise = real(ifft(fft(audioMultiplexNoisy)./H))*fs;

carrier1 = findPeakFrequencyInBand(fcApprox1, bandwidth, f, audioRemoveLTINoise)

carrier2 = findPeakFrequencyInBand(fcApprox2, bandwidth, f, audioRemoveLTINoise)

carrier3 = findPeakFrequencyInBand(fcApprox3, bandwidth, f, audioRemoveLTINoise)

carrier4 = findPeakFrequencyInBand(fcApprox4, bandwidth, f, audioRemoveLTINoise)

carrier5 = findPeakFrequencyInBand(fcApprox5, bandwidth, f, audioRemoveLTINoise)
%demodulation
[signal1, ~] = demodulate(audioRemoveLTINoise, carrier1,bandwidth,fs,t);
[signal2, ~] = demodulate(audioRemoveLTINoise, carrier2,bandwidth,fs,t);
[signal3, ~] = demodulate(audioRemoveLTINoise, carrier3,bandwidth,fs,t);
[signal4, ~] = demodulate(audioRemoveLTINoise, carrier4,bandwidth,fs,t);
[signal5, ~] = demodulate(audioRemoveLTINoise, carrier5,bandwidth,fs,t);

figure(12)
subplot(5,2,1)
plot(t, signal1);
title("signal 1")
ylabel("Amplitude")

subplot(5,2,2)
plot(f, abs(fftshift(fft(signal1))) );
title("signal 1 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,3)
plot(t,signal2);
title("signal 2")
ylabel("Amplitude")

subplot(5,2,4)
plot(f, abs(fftshift(fft(signal2))) );
title("signal 2 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,5)
plot(t, signal3);
title("signal 3")
ylabel("Amplitude")

subplot(5,2,6)
plot(f, abs(fftshift(fft(signal3))) );
title("signal 3 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,7)
plot(t, signal4);
title("signal 4")
ylabel("Amplitude")

subplot(5,2,8)
plot(f, abs(fftshift(fft(signal4))) );
title("signal 4 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,9)
plot(t, signal5 );
title("signal 5")
xlabel("Seconds (s)")
ylabel("Amplitude")

subplot(5,2,10)
plot(f, abs(fftshift(fft(signal5))) );
title("signal 5 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
xlabel("Frequency (Hz)")
ylabel("Magnitude")

pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1), pos(2), pos(3), 1080]);
saveimagewrapper(gcf)

audiowrite("signal1noLTI.wav",signal1,fs)
audiowrite("signal2noLTI.wav",signal2,fs)
audiowrite("signal3noLTI.wav",signal3,fs)
audiowrite("signal4noLTI.wav",signal4,fs)
audiowrite("signal5noLTI.wav",signal5,fs)

%% 1.5


function [signalToneFrequency,denoisedSignal] = removeSingleTone(fcTone,bandwidthToFindTone, f, signal)
    signalToneFrequency = findPeakFrequencyInBand(fcTone, bandwidthToFindTone, f, signal);

    % this is a bandstop filter for the single frequency tone
    toneBandwidth = 1;
    posMask = (f > (signalToneFrequency-toneBandwidth) & f < (signalToneFrequency+toneBandwidth));
    negMask = (f > (-signalToneFrequency-toneBandwidth) & f < (-signalToneFrequency+toneBandwidth));
    zeroMask= ~(posMask|negMask);
    signalFFT = fftshift(fft(signal)); signalFFT=signalFFT.*zeroMask;
    denoisedSignal = real(ifft(ifftshift(signalFFT)));
end

% visually the single frequency noise is located between 2000 and 3000 hz for
% all signals
fcTone=2500 % Hz
bandwidthTone = 500;




[signal1ToneFrequency,signal1] = removeSingleTone(fcTone, bandwidthTone, f, signal1);
[signal2ToneFrequency,signal2] = removeSingleTone(fcTone, bandwidthTone, f, signal2);
[signal3ToneFrequency,signal3] = removeSingleTone(fcTone, bandwidthTone, f, signal3);
[signal4ToneFrequency,signal4] = removeSingleTone(fcTone, bandwidthTone, f, signal4);
[signal5ToneFrequency,signal5] = removeSingleTone(fcTone, bandwidthTone, f, signal5);
signal1ToneFrequency % 2359 Hz
signal2ToneFrequency % 2023 Hz
signal3ToneFrequency % 2390 Hz
signal4ToneFrequency % 2817 Hz
signal5ToneFrequency % 2182 Hz
figure(13)
subplot(5,2,1)
plot(t, signal1);
title("signal 1")
ylabel("Amplitude")

subplot(5,2,2)
plot(f, abs(fftshift(fft(signal1))) );
title("signal 1 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,3)
plot(t,signal2);
title("signal 2")
ylabel("Amplitude")

subplot(5,2,4)
plot(f, abs(fftshift(fft(signal2))) );
title("signal 2 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,5)
plot(t, signal3);
title("signal 3")
ylabel("Amplitude")

subplot(5,2,6)
plot(f, abs(fftshift(fft(signal3))) );
title("signal 3 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,7)
plot(t, signal4);
title("signal 4")
ylabel("Amplitude")

subplot(5,2,8)
plot(f, abs(fftshift(fft(signal4))) );
title("signal 4 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
ylabel("Magnitude")

subplot(5,2,9)
plot(t, signal5 );
title("signal 5")
xlabel("Seconds (s)")
ylabel("Amplitude")

subplot(5,2,10)
plot(f, abs(fftshift(fft(signal5))) );
title("signal 5 fft")
ylim([-inf 0.5*power(10,5)])
xlim([-bandwidth*0.5 bandwidth*0.5])
xlabel("Frequency (Hz)")
ylabel("Magnitude")

pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1), pos(2), pos(3), 1080]);
saveimagewrapper(gcf)

audiowrite("signal1noLTInoTone.wav",signal1,fs)
audiowrite("signal2noLTInoTone.wav",signal2,fs)
audiowrite("signal3noLTInoTone.wav",signal3,fs)
audiowrite("signal4noLTInoTone.wav",signal4,fs)
audiowrite("signal5noLTInoTone.wav",signal5,fs)

% TODO: label all graphs
% TODO: export all images as svg?