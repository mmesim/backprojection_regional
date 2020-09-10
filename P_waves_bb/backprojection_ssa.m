% Backprojectiona for local events                              %
% using a large N-array                                         %
%                                                               %
% Works for one event at a time                                 %
% Wavforms start at origin time                                 %
% ------------------------- M.Mesimeri 10/2019 ---------------  %

clear;clc; tic %start timer

%% 00.Setup
parameters %load parameter file
parpool('local',workers); %Start parallel pool
mydir=pwd; pdir=sprintf('%s/src/',pwd); % get working directory path
addpath(genpath(pdir));  %add src to path (includes taup and readsac)
%--------------------------------------------------------------------------
%% 01. Load data (Sac files)
disp('Loading files..')
[y,header]=my_loadfiles(mydata);

%% 02. Preprocess data 
disp('Preprocessing...')
y_proc=my_preprocessing(y,header(1).DELTA,type,lcorner,hcorner);

%% 03. Load travel times
load data.mat tt_table grid

%% 04. Crete beam for each grid point
disp('Beam for each Grid point..')
beam=my_beam(start,stop,tt_table,grid,y_proc,header(1).DELTA);

%% 05. Measure amplitude and energy
disp('Amplitudes..')
[ampls, all, maxgrid]=my_ampls(beam,grid);

%% 06. Output #1 Figures
disp('Figures..')
my_figure(all,minlat, maxlat,inclat, minlon, maxlon,inclon, mindepth, maxdepth, incdepth,minorigin, maxorigin, incorigin);

%% 07. Output: Best Location
fprintf('Location: %7.4f %9.4f %6.2f %3.1f \n',grid(maxgrid,:))

%% 08. Shutdown parallel pool
delete(gcp)
fprintf('Elapsed time %6.2f minutes... \n',toc/60) %stop timer

