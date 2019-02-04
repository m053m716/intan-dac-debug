%% MAIN  Batch to keep scripts for analyzing DAC signals organized
clear; clc


%% SET INFO
NAME = {'R18-159_2019_02_01_2'};

%% GET DATA
spikes = getFSMDetectedSpikes(NAME);
rejects = getFSMRejectedSpikes(NAME);
params = getFSMParams(NAME);

%% PLOT
fig = plotFSMspikes(NAME,spikes,rejects,params);