
function [mX,ipfreq,ipmag,f,f0] = f0Detection(x,fs,win,H,N,fp)
    minf0 = 100;
    maxf0 = 1000;
    f0et = 20;
    f = (fs*(0:N/2-1)/N)';
    [xmX_dB,xpX] = stftMag_dB(x,win,N,H);
    mX = mean(xmX_dB,2);
    mX = mX';
    [~,ploc] = findpeaks(mX,'MinPeakHeight',-50,'MinPeakProminence',7,'NPeaks',10);
    [iploc,ipmag] = peakInterp(mX,ploc);
    ipfreq = (fs*(iploc-1)/N);
    f0 = f0Twm(ipfreq,ipmag,f0et,minf0,maxf0);
end

function f0 = f0Twm(pfreq,pmag,ef0max,minf0,maxf0)
    f0c = find(pfreq>minf0 & pfreq<maxf0);
    f0cf = pfreq(f0c);
    if isempty(f0c) 
        f0 = 0;
        return
    end
    [f0,f0error] = twm(pfreq,pmag,f0cf);
    
    if (f0>0 && f0error<ef0max)
       return 
    else 
        f0 = 0;
        return
    end
end


function [f0,f0error] = twm(pfreq,pmag,f0cf)
    %f0cf & pfreq & pmag are row vectors
    maxnpeaks = 10;
    nPeaks = length(pfreq);
    p = 0.5; q = 1.4; r = 0.5; rho = 0.33;
    Amax = max(pmag);
    minF0Candidate = min(f0cf);
    maxMeasuredFreq = max(pfreq);
    canMTXLen = max(maxnpeaks, ceil(maxMeasuredFreq/minF0Candidate)); 
    hn = (1:canMTXLen);
    predMTX = transpose(f0cf).*hn;
    pmag = 10.^((pmag-Amax)/20);
    ErrorPM = zeros(size(f0cf));
    for i=1:length(f0cf)
        [minFreqDist,ind] = min(abs(predMTX(i,:)'-pfreq),[],2);
        ponddif = minFreqDist'./(predMTX(i,:).^(p));
        
        magFactor = pmag(ind);
        ErrorPM(i) = sum(ponddif + magFactor.*(q.*ponddif-r));
    end
    ErrorMP = zeros(size(f0cf));
    for i=1:length(f0cf)
        minFreqDist = min(abs(pfreq(1:end)'-predMTX(i,:)),[],2);
        ponddif = minFreqDist'./(pfreq(1:end).^(p));
        ErrorMP(i) = sum(pmag.*(ponddif + pmag.*(q.*ponddif-r)));
    end
    Error = (ErrorPM + rho*ErrorMP)/nPeaks;
    [f0error, f0_ind] = min(Error);
    f0 = f0cf(f0_ind);
end


function [iploc,ipmag] = peakInterp(mX,ploc)
    val = mX(ploc);
    lval = mX(ploc-1);
    rval = mX(ploc+1);
    iploc = ploc + 0.5 * (lval - rval) ./ (lval - 2 * val + rval);
    ipmag =  val - 0.25 * (lval - rval) .* (iploc - ploc);
end