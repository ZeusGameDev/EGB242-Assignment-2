%% EGB242 Assignment 2, Section 1 %%
% This file is a template for your MATLAB solution to Section 1.
%
% Before starting to write code, generate your data with the ??? as
% described in the assignment task.

%% Initialise workspace
clear all; close all;
load DataA2 audioMultiplexNoisy fs sid;
% Begin writing your MATLAB solution below this line.
% global saveImages;
% saveImages = 1;

maxNumCompThreads(java.lang.Runtime.getRuntime().availableProcessors()); % threads set to n of logical processors

length = size(audioMultiplexNoisy,2)/fs; % 20 seconds
samples = fs*length;
t = linspace(0, length, samples + 1); t(end) = [];


figure(1)
plot(t, audioMultiplexNoisy);
xlabel("Seconds (s)")
ylabel("Amplitude")
title("Waveform of transmission channel over 20 seconds")
legend("audio")
fontsize(gcf,scale=1.6)
saveimagewrapper(gcf)

f= linspace(-fs/2,fs/2,fs*length);
channelfft = abs(fftshift(fft(audioMultiplexNoisy)));

figure(2)
plot(f,channelfft)
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

ts = 1/fs; % sampling period/time??
% signal of area 1 , and infinite peak. ts is smallest unit of time,
% Area = ts*(1/ts) = 1
dirac = [1/ts,zeros(1,size(t,2)-1)];
impulseResponse = channel(sid, dirac, fs);
H = fft(impulseResponse);
f = linspace(-fs/2, fs/2, samples + 1); f(end) = [];
figure(3)
plot(t,impulseResponse)

figure(4)
plot(f,abs(fftshift(H)), f, channelfft)
% y(t) = x(t) conv h(t)
% y(f) = x(f) mult h(f)
% tute 6?
audioRemoveLSINoise = real(ifft(((fft(audioMultiplexNoisy)) ./ H)))*fs;
figure(67)
plot(f,abs(fftshift(H)),f ,abs(fftshift(fft(audioRemoveLSINoise))));

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
bandwidth = 8000;
halfBandwidth = bandwidth/2;
fcApprox1 = 8830;
fcApprox2 = 24020;
fcApprox3 = 40190;
fcApprox4 = 56250;
fcApprox5 = 77280;

function [carrier] = findPeakFrequencyInBand(centre,bandwidth,f, channel)
    halfBandwidth = bandwidth/2;
    searchMask = f > (centre-halfBandwidth) & f < (centre+halfBandwidth);
    % [~,idx] = maxk(abs(fftshift(fft(channel))).* searchMask,2);
    % carrier = (f(idx(1))+f(idx(2)))/2;
    [~,idx] = max(abs(fftshift(fft(channel))).* searchMask);
    carrier = f(idx);
end

% TODO: do i need fftshift
carrier1 = findPeakFrequencyInBand(fcApprox1, bandwidth, f, audioRemoveLSINoise)

carrier2 = findPeakFrequencyInBand(fcApprox2, bandwidth, f, audioRemoveLSINoise)

carrier3 = findPeakFrequencyInBand(fcApprox3, bandwidth, f, audioRemoveLSINoise)

carrier4 = findPeakFrequencyInBand(fcApprox4, bandwidth, f, audioRemoveLSINoise)

carrier5 = findPeakFrequencyInBand(fcApprox5, bandwidth, f, audioRemoveLSINoise)
%demodulation
[signal1, ~] = demodulate(audioRemoveLSINoise, carrier1,bandwidth,fs,t);
audiowrite("signal1.wav",signal1,fs)
[signal2, ~] = demodulate(audioRemoveLSINoise, carrier2,bandwidth,fs,t);
audiowrite("signal2.wav",signal2,fs)
[signal3, ~] = demodulate(audioRemoveLSINoise, carrier3,bandwidth,fs,t);
audiowrite("signal3.wav",signal3,fs)
[signal4, ~] = demodulate(audioRemoveLSINoise, carrier4,bandwidth,fs,t);
audiowrite("signal4.wav",signal4,fs)
[signal5, ~] = demodulate(audioRemoveLSINoise, carrier5,bandwidth,fs,t);
audiowrite("signal5.wav",signal5,fs)

figure(5)
plot(t, signal1);
xlabel("Seconds (s)")
ylabel("Amplitude")
title("Waveform of demodulated audio signal 1 over 20 seconds")
legend("audio signal 1")
saveimagewrapper(gcf)

% f= linspace(-fs/2,fs/2,fs*length);
s1fft = abs(fftshift(fft(signal1)))*ts;

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

figure(7)
subplot(3,2,1)
plot(t, signal1);
title("signal 1")


subplot(3,2,2)
plot(t,signal2);
title("signal 2")

subplot(3,2,3)
plot(t, signal3);
title("signal 3")

subplot(3,2,4)
plot(t, signal4);
title("signal 4")

subplot(3,2,5)
plot(t, signal5 );
title("signal 5")

subplot(3,2,6)
plot(f, abs(fftshift(fft(signal5))) );
title("signal 5 fft")
saveimagewrapper(gcf)


% xlabel("Seconds (s)")
% ylabel("Amplitude")
% title("Waveform of demodulated audio signal 1 over 20 seconds")
% legend("audio signal 1")
% TODO: filter in frequency domain
signal1 = highpass(signal1,40,fs);
signal1 = lowpass(signal1,4000,fs);
% signal2 = highpass(signal2,40,fs);
% signal2 = lowpass(signal2,4000,fs);
% signal3 = highpass(signal3,40,fs);
% signal3 = lowpass(signal3,4000,fs);
% signal4 = highpass(signal4,40,fs);
% signal4 = lowpass(signal4,4000,fs);
% signal1 = bandstop(signal1,[2340,2370],fs);
signal5 = signal5*10;
figure(10)
plot(f, abs(fftshift(fft(signal1))) );
title("signal 1")

% signal2 = highpass(signal2,40,fs);
% signal3 = highpass(signal3,40,fs);
% signal4 = highpass(signal4,40,fs);
% signal5 = bandstop(signal5,[1040,1060],fs);
% signal5 = bandstop(signal5,[1040,1060],fs);
% signal5 = bandstop(signal5,[3215,3265],fs);
% searchMask = f > (centre-halfBandwidth) & f < (centre+halfBandwidth);
% [~,idx] = max(abs(fftshift(fft(channel))).* searchMask);
% f2 = linspace(0,fs,fs*length);
% 2340,2370
% signal1 = real(ifft(fft(signal1).*( (f2>20) & (f2<4000) )));
% signal1 = real(ifft(fft(signal1).*~( (f2>2340) & (f2<2370) )));
% signal1 = (ifft(fft(signal1)))*fs;

% % signal1 = (ifft(fft(signal1).*( (f>20) & (f<8000) )));
% signal2 = real(ifft(fft(signal1).*(f>20 & f<8000)));
% signal3 = real(ifft(fft(signal1).*(f>20 & f<8000)));
% signal4 = real(ifft(fft(signal1).*(f>20 & f<8000)));


figure(8)
subplot(3,2,1)
plot(t, signal1);
title("signal 1")
% the noise looks vaguely (cos)sinusoidal, with a period of approx. 18s and
% an amp of approx 0.5

subplot(3,2,2)
plot(t,signal2);
title("signal 2")

subplot(3,2,3)
plot(t, signal3);
title("signal 3")

subplot(3,2,4)
plot(t, signal4);
title("signal 4")

subplot(3,2,5)
plot(t, signal5 );
title("signal 5")

subplot(3,2,6)
plot(f, abs(fftshift(fft(signal5))) );
title("signal 5 fft")

audiowrite("signal1c.wav",signal1,fs)
audiowrite("signal2c.wav",signal2,fs)
audiowrite("signal3c.wav",signal3,fs)
audiowrite("signal4c.wav",signal4,fs)
audiowrite("signal5c.wav",signal5,fs)

% TODO: label all graphs