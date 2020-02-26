clear;clc; tic %start timer
%% Paramaters
%path to waveforms
mydata='/uufs/chpc.utah.edu/common/home/koper-group1/mesimeri/Array_Detection/Backprojection_SSA/DATA';
%-------------------------------------------------------------------------
% Parallel settings
workers=12;                 %Set number of cores to work on a local machine
%Define grid points
%Minimum  - Maximum - Latitude
minlat=38.7; maxlat=38.9;  inclat=0.1;
%Minimum  - Maximum - Longitude 
minlon=-112.9; maxlon=-112.7; inclon=0.1;
%Minimum - Maximum - Depth [km]
mindepth=2.0; maxdepth=3.0; incdepth=1.0;
%Minimum - Maximum - Origin time [sec] [time before the detection]
minorigin=0; maxorigin=2; incorigin=0.1;
%--------------------------------------------------------------------------
%Define phase 
pha='P';   %Case sensitive
%--------------------------------------------------------------------------
%% 00.Setup
parpool('local',workers); %Start parallel pool
mydir=pwd; pdir=sprintf('%s/src/',pwd); % get working directory path
addpath(genpath(pdir));  %add src to path (includes taup and readsac)
%--------------------------------------------------------------------------
%% 01. Load data (Sac files)
disp('Loading files..')
[y,header]=my_loadfiles(mydata);
%% Load Velocity model
load velocity_model.mat 

%% 02. Calculate travel times
disp('Calculate travel tcimes...')
[tt_table,grid]=make_tt_table(pha,model,minlat, maxlat,inclat, minlon, maxlon,inclon, mindepth, maxdepth, incdepth, minorigin, maxorigin, incorigin,header);

save  data.mat tt_table grid

delete(gcp)
fprintf('Elapsed time %6.2f minutes... \n',toc/60) %stop timer

