% Parameter file for backprojection        %
%                                          %
% ---------- M. Mesimeri 07/2020 --------- %

%path to waveforms
mydata='horizontals';
%-------------------------------------------------------------------------
% Parallel settings
workers=12;                 %Set number of cores to work on a local machine
%-------------- Filtering parameters --------------------------------------
type='bandpass';        %'low', 'high', 'bandpass'
%co=1;                  %low or high corner frequency (high or low pass)
co=[2;8];               %low-high corner frequency for bandpass
%--------------------------------------------------------------------------
%Earthquake Location
rlat=40.75; rlon=-112.08; rdepth=12;
%--------------------------------------------------------------------------
%Reference Station
sta='MID';           %Reference station used for time corrections
trdel=-0.34;          %Time delay for reference station   
%--------------------------------------------------------------------------
%Correaltion window around S pick [in seconds]
Sb_pick=0.2;             %Time before Sb_pick
Sa_pick=2;               %Time after S pick   
%--------------------------------------------------------------------------  
%Cut waveforms [in seconds] for backprojection
cut_start=0;     %time before theoretical pick                     
cut_stop=0.3;   %time after theoretical pick
%--------------------------------------------------------------------------
% Choose beam type [1-4]:
beam_type=4;  % 1:linear  2:2nd root  3:3rd root  4:4th root
%--------------------------------------------------------------------------
% %Define grid points for plotting only
% %travel times should be calculated using arrival_times.m
%Define grid points
%Minimum  - Maximum - Latitude
minlat=40.61; maxlat=40.89;  inclat=0.01;
%Minimum  - Maximum - Longitude 
minlon=-112.22; maxlon=-111.94; inclon=0.01;
%Minimum - Maximum - Depth [km]
mindepth=5; maxdepth=15.0; incdepth=1.0;
%Minimum - Maximum - Origin time [sec] [time before the detection]
minorigin=0; maxorigin=10; incorigin=0.2;
