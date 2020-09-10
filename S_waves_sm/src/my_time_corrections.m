function [tcorr,CCmax]=my_time_corrections(y,trdel,headerE,sta,Sb_pick,Sa_pick,rlat,rlon,rdepth,tt_table,grid)
%function to calculate time corrections
%01. cut waveforms around S
%02. Do cross correlations
%03. Calculate station corrections
%Output - tcorr [corrections for each station]
%--------------------------------------------------------------------------
%Preallocate memory
staname=cell(length(headerE),1);
tcorr=ones(size(length(headerE),1))*NaN;
%-------------------------------------------------------------------------
%% 00. Find reference station
for i=1:length(headerE)
staname{i,1}=headerE(i).KSTNM;
end
sta_ind=find(strcmp(staname,sta)); % station index
yref=y{1,sta_ind};  %waveform for reference station
%Find index for travel times @ reference station
time_ind=find(grid(:,1)==rlat & grid(:,2)==rlon & grid(:,3)==rdepth & grid(:,4)==0);
%Cut waveform for reference station
nstart=round((headerE(sta_ind).T0+Sb_pick)./headerE(1).DELTA);
nstop=round(nstart+(Sa_pick./headerE(1).DELTA));
yref_cut=yref(nstart:nstop);

%% 01 cut waveforms
for j=1:length(y)
temp=y{1,j};
start=round((headerE(j).T0+Sb_pick)./headerE(1).DELTA);
stop=round(start+(Sa_pick./headerE(1).DELTA));
x=temp(start:stop);

%% 02. Do cross correaltion
[cc,lags]=xcorr(yref_cut,x,'coeff');
[CCmax(j),index]=max(cc);
delay=lags(index)./100;

%% 03. Time corrections
%Add arrival times to delay time
xcorr_time=headerE(sta_ind).T0+delay-headerE(j).T0;
%Fix time for refence station + travel times diff.
tcorr(j,1)=tt_table(time_ind,sta_ind)+trdel-xcorr_time-tt_table(time_ind,j);

end


end