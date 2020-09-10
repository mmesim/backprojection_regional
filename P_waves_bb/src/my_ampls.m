function [ ampls, all, maxgrid]=my_ampls(beam,grid)
%Calculate maximum amplitude for each grid point
%Using Root mean square (L2)
%--------------------------------------------------------------------------
%Root mean square (L2)
sqr_beam=(beam.^2)'; 
%Amplitudes
ampls=sqrt(sqr_beam./length(sqr_beam)); 
%Find maximum 
[~,maxgrid]=max(max((ampls))); 

%New table -- Grid points, Maximum amplitude, Maximum Energy
all=[grid max(ampls)'];


end