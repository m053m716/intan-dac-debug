%% MAIN  - Script for organizing code to analyze performance of FSM
clear; clc

%% SET INFO
NAME = {'R18-159_2019_02_01_2'};
FS = 30000; % Hz

%% CHARACTERIZE DETECTION ON BOTH RECORDINGS
roc = getFSMperformance(NAME,FS);
