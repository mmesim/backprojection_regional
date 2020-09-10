function [R,T]=my_rotation(headerE,rlat,rlon,yN_proc,yE_proc)
%function to rotate horizontal components
%to radial and transverse
%---------------------------------------------------------------

%Preallocate memory
R=cell(1,length(yN_proc));
T=cell(1,length(yE_proc));

parfor i=1:length(headerE)
%grab station coordinates 
%use one of the two components
%E-W
Estlo=headerE(i).STLO;
Estla=headerE(i).STLA;
%Calcualte azimuth from reference point to station
phi=azimuth(rlat,rlon,Estla,Estlo,'radians');
%grab waveforms
N=yN_proc{1,i};
E=yE_proc{1,i};
% Rotate
R{1,i}=cos(phi)*N+sin(phi)*E;
T{1,i}=-sin(phi)*N+cos(phi)*E;
%next

end 
end