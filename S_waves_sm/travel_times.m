clear;clc; tic %start timer
%% Paramaters
%path to waveforms
mydata='horizontals';
%-------------------------------------------------------------------------
% Parallel settings
workers=12;                 %Set number of cores to work on a local machine
%Define grid points
%Minimum  - Maximum - Latitude
minlat=40.61; maxlat=40.89;  inclat=0.01;
%Minimum  - Maximum - Longitude 
minlon=-112.22; maxlon=-111.94; inclon=0.01;
%Minimum - Maximum - Depth [km]
mindepth=1; maxdepth=30.0; incdepth=1.0;
%Minimum - Maximum - Origin time [sec] [time before the detection]
minorigin=0; maxorigin=10; incorigin=0.1;
%--------------------------------------------------------------------------
%Define phase 
pha='S';   %Case sensitive
%--------------------------------------------------------------------------
%% 00.Setup
parpool('local',workers); %Start parallel pool
mydir=pwd; pdir=sprintf('%s/src/',pwd); % get working directory path
addpath(genpath(pdir));  %add src to path (includes taup and readsac)
%--------------------------------------------------------------------------
%% 01. Load data (Sac files)
disp('Loading files..')
[yN,yE,headerN,headerE]=my_loadfiles(mydata); header=headerN; %or header=headerE;
%% Load Velocity model
load velocity_model.mat 

%% 02. Calculate travel times
disp('Calculate travel tcimes...')
[tt_table,grid]=make_tt_table(pha,model,minlat, maxlat,inclat, minlon, maxlon,inclon, mindepth, maxdepth, incdepth, minorigin, maxorigin, incorigin,header);

save  data.mat tt_table grid

delete(gcp)
fprintf('Elapsed time %6.2f minutes... \n',toc/60) %stop timer

