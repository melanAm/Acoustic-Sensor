
function [xmX,f] = stftMag(x,fs,win,N,H)
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
        mX = abs(X);
        mX = mX/max(mX);
        mX = mX(N/2+1:end);
        xmX(:,t) = mX;
        pX = unwrap(angle(X));
        xpX(:,t) = pX(N/2+1:end);
        t = t+1;
        pin = pin+H;
    end
    f = (fs*(0:N/2-1)/N)';
end


