function [yf]=my_filter(yr,type,delta,lcorner,hcorner)

n=2; %second order filter
fnq=1/(2*delta); %Nyquist frequency


if strcmp(type,'bandpass') == 1
Wn=[lcorner/fnq hcorner/fnq]; %normalized cutoff frequency Wn  
elseif strcmp(type,'high') == 1
Wn=hcorner/fnq; %normalized cutoff frequency Wn    
elseif strcmp(type,'low') == 1
Wn=lcorner/fnq; %normalized cutoff frequency Wn
end

[b,a] = butter(n,Wn,type); %construct butterworth filter

yf=filtfilt(b,a,double(yr)); % zero phase digital filtering

end