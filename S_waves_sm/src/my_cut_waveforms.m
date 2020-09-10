function  beam=my_cut_waveforms(mwindow,delta,tt_time,correction,origin,y,beam_type)

j=1;
Nsta=length(y);
for k=1:Nsta
%Cut waveforms at theoretical S-arrival times
start=round((origin+tt_time(1,k)+correction(k,1))./delta);
stop=start+mwindow;
%Skip stations that start before origin time

if start >0
%Save to an array
y_cut(j,:)=y{1,k}(start:stop);
j=j+1;
end % end of if
end % end of for loop

%Nth root stacking
beam=my_stacking(y_cut,length(y_cut(:,1)),beam_type);
end % end of function
