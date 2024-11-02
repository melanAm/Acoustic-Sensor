close all;
clear all; 
clc;

[x, fs] = audioread('fanPosition8_KwhF.wav');
t1=8;t2=20;
x = x(t1*fs:t2*fs);

% STFT parameters 
M = 16383; 
H = (M+1)/2;
N = 16384;
win = blackman(M);

[xmX,xpX] = stft_t(x,win,N,H);
f = (fs*(0:N/2-1)/N)';

m = 5;
%find peaks
% fpks_8 = zeros(size(xmX,2)-4,5);
% pmags = zeros(size(xmX,2)-4,5);
top3pks_8 = zeros(size(xmX,2)-4,3);
for p=3:size(xmX,2)-2
    mX = mean(xmX(:,p-2:p+2),2);   
    mX = 20*log10(mX);
    [pmags,plocs] = findpeaks(mX,'MinPeakHeight',-40,'MinPeakProminence',15,'NPeaks',7);
    if p==13
        figure(2)
        plot(f,mX)
        hold on
        plot(f(plocs),pmags,'o','MarkerSize',12)
        grid on
    end
    [iplocs,ipmags] = peakInterp(mX,plocs);
    [sortedPeaks, sortedIndices] = sort(ipmags, 'descend');  
    topThreePeaks = sortedPeaks(1:3); % Get the three highest peaks  
    topThreeLocs = iplocs(sortedIndices(1:3)); % Corresponding locations of the highest peaks 
%     fpks_8(p-2,1:length(iplocs)) = (fs*((iplocs(1:end)-1)/N));
%     pmags(p-2,1:length(iplocs)) = ipmags;
    top3pks_8(p-2,1:3) = (fs*((topThreeLocs-1)/N));
end

% Sort peaks in descending order and get the three highest  
 
function [iploc,ipmag] = peakInterp(mX,ploc)
    val = mX(ploc);
    lval = mX(ploc-1);
    rval = mX(ploc+1);
    iploc = ploc + 0.5 * (lval - rval) ./ (lval - 2 * val + rval);
    ipmag =  val - 0.25 * (lval - rval) .* (iploc - ploc);
end

function [xmX,xpX] = stft_t(x,win,N,H)
    M = length(win);
    hN = (N/2);
    hM1 = floor((M+1)/2);
    hM2 = floor(M/2);
    x = [zeros(hM2,1);x;zeros(hM1,1)]; %reduce edge effect
    pin = hM1;                         %initialize sound pointer in middle of analysis window
    pend = length(x)-hM1+1;
    win = win / sum(win);              %normalize analysis window
    xmX = zeros(hN,floor(((length(x)-M)/H)+1));
    xpX = zeros(hN,floor(((length(x)-M)/H)+1));
    t = 1;
    while pin<=pend
        x1 = x(pin-hM1+1:pin+hM2);
        xw = x1.*win;
        X = fftshift(fft(xw,N));
%         mX = X.*conj(X);
        mX = abs(X);
        mX = mX/max(mX);
        mX = mX(N/2+1:end);
%         mX(2:end-1) = 2*mX(2:end-1);
        xmX(:,t) = mX;
        pX = unwrap(angle(X));
        xpX(:,t) = pX(N/2+1:end);
        t = t+1;
        pin = pin+H;
    end
end
