function   beam=my_beam(start,stop,tt_table,grid,env,delta,tcorr,beam_type)
%Create a beam for each grid point using Nth root stacking
%--------------------------------------------------------------------------

%define window in samples
mwindow=round((stop-start)./delta);
%length of parfor
N=length(grid);

%Loop through grid points and get beam
parfor i=1:N
%function to cut waveforms in time
beam(i,:)=my_cut_waveforms(mwindow,delta,tt_table(i,:),tcorr,grid(i,4),env,beam_type); 

end%end of parfor 

end %enf of function
