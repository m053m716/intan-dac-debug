clear; clc; close all force;

%% DEFINE WHAT TO RUN
% NAME = {'R18-159_2019_02_01_1'; ...
%         'R18-159_2019_02_01_2'; ...
%         'R18-159_2019_02_01_3'};
NAME = 'R18-159_2019_02_01_2';

%% DEFINE WINDOW PARAMETERS
params = struct;
params.DAC_en         = [  1  1   1   1   1   1    1   1];
params.DAC_edge_type  = [  1  1   0   1   0   1    1   0]; % 0==Inc, 1==Exc
params.dac_thresholds = [-25 60 -30  -5  15 -45 -150 -40];
params.window_start   = [  0 19   7  16  22  13    4   6];
params.window_stop    = [  3 24   8  21  24  15   24   7];

%% RUN SIMULATION
[fsm_window_state,fig] = simulateFSM(NAME,params);