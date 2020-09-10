function [yr]=my_detrend(ym,n)
%Remove trend using polyfit function
%It doesnt't work well for order higher than ~5
%--------------------------------------------------------------------------
x=(1:length(ym))'; %define x vector

p=polyfit(x,ym,n); % apply linear regression nth order

trend=polyval(p,x); %find trend

yr=ym-trend; %remove trend

end