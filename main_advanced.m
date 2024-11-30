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
fundamental_freqs = zeros(4,6);
plts = [];

for i=3:8
   file_name = sprintf('fanPosition%i.wav',i);
   [x, fs] = audioread(file_name);
    if size(x,2)>1
        x = mean(x,2);
    end
    %last 3 seconds
    [xmX, f] = stftMag(x,fs,win,N,H);
    for j=1:4
        mX = mean(xmX(:,(j-1)*15+1:j*15),2);
        mX = 20*log10(mX);
        mX = mX';
        [ipfreq,ipmag,f0] = f0Detection(mX,fs,minf0,maxf0,f0et);
        fundamental_freqs(j,i-2) = f0;
        if j==3
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
    end
end

figure(1)
lgds = {'fan position3','fan position4','fan position5','fan position6','fan position7','fan position8'};
legend(plts,lgds)

fanSpeeds_avg = [3.58,3.99,4.68,5.36,5.98,6.64,7.71,8.53];

speeds = zeros(size(fundamental_freqs));
for i=1:6
    for j=1:size(speeds,1)
        speeds(j,i) = fanSpeeds_avg(i+2);
    end
end

fundamental_freqs = reshape(fundamental_freqs,1,numel(fundamental_freqs));
speeds = reshape(speeds,1,numel(speeds));

figure(2)
plot(fundamental_freqs,speeds,'bo')
hold on

[pred,S] = polyfit(fundamental_freqs,speeds,1); 
% 
% f0_test = [189,238,295,346,417,473];
[y_fit,delta] = polyval(pred,fundamental_freqs,S);
% 
plot(fundamental_freqs,y_fit,'r-')
plot(fundamental_freqs,y_fit+2*delta,'m--',fundamental_freqs,y_fit-2*delta,'m--')
title('Linear Fit of Siren Data with 95% Prediction Interval')
xlabel('fundamental frequency (Hz)')
ylabel('fan speed (m/s)')
legend('Data','Linear Fit','95% Prediction Interval')
% 
% 





