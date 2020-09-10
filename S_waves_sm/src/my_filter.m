function [yf]=my_filter(yr,type,delta,co)
%Filter waveforms
%Zero phase butterworth filter Nth order 
%--------------------------------------------------------------------------
n=2; %second order filter
fnq=1/(2*delta); %Nyquist frequency


if strcmp(type,'bandpass') == 1
Wn=[co(1,1)/fnq co(2,1)/fnq]; %normalized cutoff frequency Wn  
elseif strcmp(type,'high') == 1
Wn=co(1,1)/fnq; %normalized cutoff frequency Wn    
elseif strcmp(type,'low') == 1
Wn=co(1,1)/fnq; %normalized cutoff frequency Wn
end

[b,a] = butter(n,Wn,type); %construct butterworth filter

yf=filtfilt(b,a,double(yr)); % zero phase digital filtering

end