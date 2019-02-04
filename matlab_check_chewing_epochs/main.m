%% MAIN   Batch for running video scoring and video synchronization
clear; close all; clc

%% SCORE VIDEOS
IN_DIR = strsplit(pwd,filesep);
IN_DIR = strjoin(IN_DIR(1:(end-1)),filesep);
IN_DIR = fullfile(IN_DIR,'data');

VID_DIR = 'K:\Rat\Video\Window Discriminator\R18-159';
BLOCK_DIR = 'P:\Extracted_Data_To_Move\Rat\Intan\R18-159';

name = {'R18-159_2019_02_01_1'; ...
   'R18-159_2019_02_01_2'};

filename = cell(size(name));
block = cell(size(name));

for ii = 1:2
   filename{ii} = fullfile(VID_DIR,[name '.MP4']);
   block{ii} = fullfile(BLOCK_DIR,name);
   
   fig = getChewingEpochs(filename{1});
   waitfor(fig);
   [~,name{ii},~] = fileparts(filename{1});
   scoreName = fullfile(IN_DIR,[name{ii} '_Chewing.mat']);
   syncName = fullfile(IN_DIR,[name{ii} '_DIG_sync.mat']);
   
   vidOffset = syncVid(scoreName,syncName);
   offsetName = fullfile(IN_DIR,[name{ii} '_vidOffset.mat']);
   
   save(offsetName,'vidOffset','-v7.3');
end

%% NEED TO REFINE THESE EPOCHS USING WAVEFORM TRACES

for ii = 1:2
   fig = refineChewingEpochs(block{ii});
   waitfor(fig);
end

%% FOCUS ON ONE OF THE RECORDINGS (_2)
load(fullfile(pwd,'R18-159_2019_02_01_2_Chewing-Refined.mat'));
load(fullfile(pwd,'R18-159_2019_02_01_2_Filt_P1_Ch_004.mat'));
sampleIndices = getChewingSamples(chewEpochStart,chewEpochStop,fs);

chewData = data(sampleIndices);
% second input is sliding window len:
chew_rms = getChewingRMSWindowed(chewData,0.1,fs);

save('R18-159_2019_01_2_ChewRMS.mat','chew_rms','sampleIndices','-v7.3');

