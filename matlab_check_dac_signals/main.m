%% MAIN  Batch to keep scripts for analyzing DAC signals organized
clear; clc


%% SET INFO
NAME = {'R18-159_2019_02_01_1'; ...
        'R18-159_2019_02_01_2'; ...
        'R18-159_2019_02_01_3'};

%% GET DATA
spikes = getFSMDetectedSpikes(NAME);
rejects = getFSMRejectedSpikes(NAME);
params = getFSMParams(NAME);

%% PLOT
fig = plotFSMspikes(NAME,spikes,rejects,params);