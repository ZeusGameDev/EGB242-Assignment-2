%% EGB242 Assignment 2, Section 1 %%
% This file is a template for your MATLAB solution to Section 1.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;
load DataA2 audioMultiplexNoisy fs sid;

% Begin writing your MATLAB solution below this line.

length = size(audioMultiplexNoisy,2)/fs % 20 seconds
t = linspace(0,length,length*fs);

figure(1)
plot(t, audioMultiplexNoisy);
xlabel("Seconds (s)")
ylabel("Amplitude")
title("Waveform of transmission channel over 20 seconds")
legend("audio")
saveimagewrapper(gcf)

f= linspace(-fs/2,fs/2,fs*length);
channelfft = abs(fftshift(fft(audioMultiplexNoisy)));

figure(2)
plot(f,channelfft)
xlabel("Frequency (Hz)")
ylabel("Magnitude")
legend("transmission channel")
title("Frequencies present in transmission channel prior to transmission")
ax = gca;
ax.XAxis.Exponent = 0;
ax.YAxis.Exponent = 0;
ax.XAxis.TickDirection = "both";
saveimagewrapper(gcf)

ts = 1/fs;

dirac = [1/ts,zeros(1,size(t,2)-1)];
impulseResponse = channel(sid, dirac, fs);
H = fft(impulseResponse) * ts;
f= linspace(-fs/2,fs/2,fs*length);
figure(3)
plot(t,impulseResponse)

figure(4)
plot(f,abs(fftshift(H)), f, channelfft*ts)

audioCleanSignal = (ifft(((fft(audioMultiplexNoisy) *ts) ./ H)) * fs);

function [audioSignal, demodulatedSignal] = demodulate(signal, carrierFrequency, bandwidth,fs,t)
    carrier = cos(2*pi*carrierFrequency.*t);
    halfBandwidth = bandwidth/2;
    passBand = [(carrierFrequency-halfBandwidth), (carrierFrequency+halfBandwidth)];
    bpFiltered = bandpass(signal, passBand, fs);
    demodulatedSignal = bpFiltered.*carrier;
    audioSignal = lowpass(demodulatedSignal,halfBandwidth, fs);
end

% find exact carrier frequency
% visual peaks at approx 8830, 24020, 40190, 56250, 77280
bandwidth = 10000;
halfBandwidth = bandwidth/2;
fcApprox1 = 8830;
fcApprox2 = 24020;
fcApprox3 = 40190;
fcApprox4 = 56250;
fcApprox5 = 77280;

searchMask = f > (fcApprox1-halfBandwidth) & f < (fcApprox1+halfBandwidth);
[~,idx] = max(channelfft.* searchMask);
carrier1 = f(idx);
searchMask = f > fcApprox2-halfBandwidth & f < fcApprox2+halfBandwidth;
[~,idx] = max(channelfft.* searchMask);
carrier2 = f(idx);
searchMask = f > fcApprox3-halfBandwidth & f < fcApprox3+halfBandwidth;
[~,idx] = max(channelfft.* searchMask);
carrier3 = f(idx);
searchMask = f > fcApprox4-halfBandwidth & f < fcApprox4+halfBandwidth;
[~,idx] = max(channelfft.* searchMask);
carrier4 = f(idx);
searchMask = f > fcApprox5-halfBandwidth & f < fcApprox5+halfBandwidth;
[~,idx] = max(channelfft.* searchMask);
carrier5 = f(idx);
%demodulation
[signal1, ~] = demodulate(audioCleanSignal, carrier1,bandwidth,fs,t);
signal1 = signal1 -0.5*cos((1/20).*pi.*t);
audiowrite("signal1.wav",signal1,fs)
[signal2, ~] = demodulate(audioCleanSignal, carrier2,bandwidth,fs,t);
signal2 = signal2 -0.5*cos((1/20).*pi.*t);
audiowrite("signal2.wav",signal2,fs)
[signal3, ~] = demodulate(audioCleanSignal, carrier3,bandwidth,fs,t);
signal3 = signal3 -0.5*cos((1/20).*pi.*t);
audiowrite("signal3.wav",signal3,fs)
[signal4, ~] = demodulate(audioCleanSignal, carrier4,bandwidth,fs,t);
signal4 = signal4 -0.5*cos((1/20).*pi.*t);
audiowrite("signal4.wav",signal4,fs)
[signal5, ~] = demodulate(audioCleanSignal, carrier5,bandwidth,fs,t);
signal5 = signal5 -0.5*cos((1/20).*pi.*t);
audiowrite("signal5.wav",signal5,fs)


figure(5)
plot(t, signal1);
xlabel("Seconds (s)")
ylabel("Amplitude")
title("Waveform of demodulated audio signal 1 over 20 seconds")
legend("audio signal 1")
saveimagewrapper(gcf)

f= linspace(-fs/2,fs/2,fs*length);
s1fft = abs(fftshift(fft(signal1)));

figure(6)
plot(f,s1fft)
xlabel("Frequency (Hz)")
ylabel("Magnitude")
legend("signal 1")
title("Frequencies present in demodulated signal 1")
ax = gca;
ax.XAxis.Exponent = 0;
ax.YAxis.Exponent = 0;
ax.XAxis.TickDirection = "both";
saveimagewrapper(gcf)

