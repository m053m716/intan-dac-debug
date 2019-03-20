clear; clc; close all force;

%% DEFINE WHAT TO RUN
% NAME = {'R18-159_2019_02_01_1'; ...
%         'R18-159_2019_02_01_2'; ...
%         'R18-159_2019_02_01_3'};
% NAME = {'R18-159_2019_02_01_2'; ...
%    'R18-159_2019_02_01_3'};
NAME = 'R18-159_2019_02_01_2';

%% DEFINE WINDOW PARAMETERS
% For window state machine:
params = struct;
params.DAC_en         = [  1  1   1   1   1   1    1   1];
params.DAC_edge_type  = [  1  1   0   1   0   1    1   0]; % 0==Inc, 1==Exc
params.dac_thresholds = [-25 60 -30  -5  15 -45 -110 -40];
params.window_start   = [  0 19   7  18  22  13    4   6];
params.window_stop    = [  3 24   8  21  24  15   24   7];
params.refractory_period     = 0; % samples

% For monopolar threshold:
% params = struct;
% params.DAC_en         = [  0  0   0   0   0   0    0   1];
% params.DAC_edge_type  = [  1  1   0   1   0   1    1   0]; % 0==Inc, 1==Exc
% params.dac_thresholds = [-25 60 -30  -5  15 -45 -110 -40];
% params.window_start   = [  0 19   7  18  22  13    4   0];
% params.window_stop    = [  3 24   8  21  24  15   24   1];
% params.refractory_period     = 60; % samples --> 2 ms

params.fs = 30000;
params.make_spike_fig = false;

%% RUN SIMULATION
[fsm_window_state,fig] = simulateFSM(NAME,params);
doOfflineDACdetect(NAME,fsm_window_state);

%% GET SPIKES AND REJECTS
maxWindow = max(params.window_stop.*params.DAC_en);
spikes = getFSMDetectedSpikes(NAME,maxWindow,fsm_window_state);
rejects = getFSMRejectedSpikes(NAME,maxWindow,fsm_window_state);

%% PLOT SPIKES AND REJECTS
if iscell(NAME)
   all_params = repmat({params},numel(NAME),1);
else
   all_params = params;
end
   
fig2 = plotFSMsnippets(NAME,spikes,rejects,all_params);

%% GET STIMS
% stimName = 'R18-159_2019_02_01_3';
stimName = 'R18-159_2019_01_31_2';
stimParams = getFSMParams(stimName);
wlen = max([stimParams.window_stop_sample]);
[stimWaveSamples,stimTriggers] = getFSMTriggeredStims(stimName,wlen);
stimWaveforms = getFSMstimsOutsideBlanking(stimName,stimWaveSamples,...
   stimTriggers,wlen);

%% PLOT STIMS
fig3 = plotFSMsnippets(stimName,stimWaveforms,[],stimParams);


