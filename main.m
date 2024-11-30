close all;
clear; 
clc;


% STFT parameters 
M = 14400;  %300ms
H = M/2;
N = 16384;
win = blackman(M);

%fundamental frequency detection parameters
minf0 = 100;
maxf0 = 1000;
f0et = 20;
fundamental_freqs = zeros(1,6);
plts = [];

for i=3:8
   file_name = sprintf('fanPosition%i.wav',i);
   [x, fs] = audioread(file_name);
    if size(x,2)>1
        x = mean(x,2);
    end
    %last 3 seconds
    x = x(end:-1:end-3*fs);
    [xmX, f] = stftMag(x,fs,win,N,H);
    mX = mean(xmX,2);
    mX = 20*log10(mX);
    mX = mX';
    [ipfreq,ipmag,f0] = f0Detection(mX,fs,minf0,maxf0,f0et);
    fundamental_freqs(i-2) = f0;
    figure(1)
    plt = semilogx(f,mX','DisplayName', sprintf('fan position %i',i))
    hold on
    plts(end+1) = plt;
    figure(1)
    plot(ipfreq,ipmag,'o','MarkerSize',12)
    grid on
    title('Siren Anechoic Spectrum')
    xlabel('frequency (Hz)')
    ylabel('magnitude (dB)')
end

figure(1)
lgds = {'fan position3','fan position4','fan position5','fan position6','fan position7','fan position8'};
legend(plts,lgds)
fanSpeeds_avg = [3.58,3.99,4.68,5.36,5.98,6.64,7.71,8.53];

figure(2)
plot(fundamental_freqs,fanSpeeds_avg(3:end),'bo')
hold on

[pred,S] = polyfit(fundamental_freqs,fanSpeeds_avg(3:end),1); 

f0_test = [189,238,295,346,417,473];
[y_fit,delta] = polyval(pred,fundamental_freqs,S);

plot(fundamental_freqs,y_fit,'r-')
plot(fundamental_freqs,y_fit+2*delta,'m--',fundamental_freqs,y_fit-2*delta,'m--')
title('Linear Fit of Siren Data with 95% Prediction Interval')
xlabel('fundamental frequency (Hz)')
ylabel('fan speed (m/s)')
legend('Data','Linear Fit','95% Prediction Interval')







