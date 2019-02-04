%% CHECK_OFFLINE_THRESHOLDS   Look at how discrimination performs offline
clear; clc;
close all force;

%% SET WHICH BLOCK TO LOOK AT HERE:
BLOCK = 'R18-00_2018_12_18';     % Block "session" name
REC = '_1';                      % Recording block ID
Q = 32768;                       % Half-max 16-bit value

%% ENSURE THAT RECORDING FILES OF INTEREST ARE EXTRACTED
if ~get_files_of_interest(BLOCK,[BLOCK REC])
   error('Something went wrong with saving files of interest.');
end

%% DATA - NOTE: GET_FILES_OF_INTEREST should be run first
% Window parameters:
load(fullfile(BLOCK,[BLOCK REC '-WindowParams.mat']),'W','TH','COL');

% Streams corresponding to FSM state:
dig = load(fullfile(BLOCK,[BLOCK REC '-DigData.mat']));

% Streams saved after coming off the DAC (HPF + GAIN):
dac = load(fullfile(BLOCK,[BLOCK REC '-DACData.mat']));

% Raw data streams from the amplifier channels:
amp = load(fullfile(BLOCK,[BLOCK REC '-AMPData.mat']));

%% DO DATA CONVERSIONS
w = convertFSMWindow(W); % Window "stop" is non-inclusive. Represent that.
n_samples = max(max(w)); % Duration of FSM from onset to complete
th = convertThresh(TH);  % Obtain threshold bit value

%% IDENTIFY TRIGGERS
spikeFig = plotDetectedSpikes(dac,dig,w,n_samples,th,COL);

%% MAKE FIGURE FOR OVERALL PLOT
[segmentFig,x] = plotLongSegment([4 7],dac,dig,th,COL);

%% MAKE FIGURE FOR STREAM COMPARISON
% [fig1,fig2] = plotTriggerStreams(amp.t,amp.data(1,:),dac.bits(1,:));

