% Parameter file for 4D backprojection     %
%                                          %
% ---------- M. Mesimeri 10/2019 --------- %

%path to waveforms
mydata='/uufs/chpc.utah.edu/common/home/koper-group1/mesimeri/Array_Detection/Backprojection_SSA/DATA';
%-------------------------------------------------------------------------
% Parallel settings
workers=32;                 %Set number of cores to work on a local machine
%-------------- Filtering parameters --------------------------------------
type='high';                %'low', 'high', 'bandpass'
lcorner=1;                  % lower corner frequency
hcorner=1;                  % higher corner frequency
%--------------------------------------------------------------------------
%Cut waveforms [in seconds]
start=0;     %time before theoretical pick                     
stop=6;      %time after theoretical pick
%--------------------------------------------------------------------------
%Define grid points for plotting only
%travel times should be calculated using arrival_times.m
%Minimum  - Maximum - Latitude
minlat=38.7; maxlat=38.9;  inclat=0.01;
%Minimum  - Maximum - Longitude 
minlon=-112.9; maxlon=-112.7; inclon=0.01;
%Minimum - Maximum - Depth [km]
mindepth=2.0; maxdepth=3.0; incdepth=1.0;
%Minimum - Maximum - Origin time [sec] [time before the detection]
minorigin=0; maxorigin=2; incorigin=0.1;