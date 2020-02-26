function  beam=my_cut_waveforms(mwindow,delta,tt_time,origin,y)

Nsta=length(y);

for k=1:Nsta
%Cut waveforms at theoretical P-arrival times
start=(round((origin+tt_time(1,k))./delta));
stop=(round((origin+tt_time(1,k))./delta))+mwindow;

%Save to an array
y_cut(:,k)=y{1,k}(start:stop);
%Use normalized envelopes instead of phasess
env(:,k)=my_envelope(y_cut(:,k));

end % end of for loop

beam=sum(env')./Nsta;

end % end of function
