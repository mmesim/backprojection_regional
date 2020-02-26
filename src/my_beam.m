function   [beam]=my_beam(start,stop,tt_table,grid,y_proc,delta)
%Create a beam for each grid point using Nth root stacking
%--------------------------------------------------------------------------

%define window in samples
mwindow=round((stop-start)./delta);
%length of parfor
N=length(grid);
%N of stations to loop through
Nsta=length(y_proc);

%Loop through grid points and get beam
parfor i=1:N
%function to cut waveforms in time
beam(i,:)=my_cut_waveforms(mwindow,delta,tt_table(i,:),grid(i,4),y_proc); 

end%end of parfor 

end %enf od function
