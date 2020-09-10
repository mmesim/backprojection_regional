% Backprojectiona for local events                              %
% using strong motion data                                      %
%                                                               %
% Works for one event at a time                                 %
% Wavforms start at origin time                                 %
% ------------------------- M.Mesimeri 07/2020 ---------------  %

clear;clc; close all; tic %start timer

%% 00.Setup
parameters %load parameter file
parpool('local',workers); %Start parallel pool
mydir=pwd; pdir=sprintf('%s/src/',pwd); % get working directory path
addpath(genpath(pdir));  %add src to path (includes ttbox and readsac)
load data_all.mat tt_table grid %load grid and travel times
%--------------------------------------------------------------------------
%% 01. Load data (Sac files)
disp('Loading files..')
[yN,yE,headerN,headerE]=my_loadfiles(mydata);

%% 02. Preprocess data 
disp('Preprocessing..')
[yN_proc,yE_proc]=my_preprocessing(yN,yE,headerN(1).DELTA,type,co);

%% 03. Rotate
disp('Rotate..')
[~,T]=my_rotation(headerE,rlat,rlon,yN_proc,yE_proc);

%% 04. Time corrections
disp('Station corrections..')
[tcorr,CCmax]=my_time_corrections(T,trdel,headerE,sta,Sb_pick,Sa_pick,rlat,rlon,rdepth,tt_table,grid);

%% 05. Envelopes
disp('Envelopes..')
env=my_envelope(T);

%% 06. Crete beam for each grid point - Nth root
disp('Beam for each Grid point..')
beam=my_beam(cut_start,cut_stop,tt_table,grid,env,headerE(1).DELTA,tcorr,beam_type);

%% 07. Measure amplitude 
disp('Amplitudes..')
[ampls, all, maxgrid]=my_ampls(beam,grid);
 
%% 08. Output #1 Figures
disp('Figures..')
%my_figure(all,minlat, maxlat,inclat, minlon, maxlon,inclon, mindepth, maxdepth, incdepth,minorigin, maxorigin, incorigin);
 
%% 09. Output: Best Location
fprintf('Best Location: %7.4f %9.4f %6.2f %3.1f \n',grid(maxgrid,:))

%% 10. Shutdown parallel pool
delete(gcp)
fprintf('Elapsed time %6.2f minutes... \n',toc/60) %stop timer
disp('Ciao..')
