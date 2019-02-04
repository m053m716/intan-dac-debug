%% MAIN   Batch for running video scoring and video synchronization
clear; close all; clc

%% SCORE VIDEO FOR _2
filename{1} = fullfile(...
   'K:\Rat\Video\Window Discriminator\R18-159',...
   'R18-159_2019_02_01_1.MP4');
block{1} = fullfile(...
   'P:\Extracted_Data_To_Move\Rat\Intan\R18-159',...
   'R18-159_2019_02_01_1');

fig = getChewingEpochs(filename{1});
waitfor(fig);
[~,name{1},~] = fileparts(filename{1});
scoreName = fullfile(pwd,[name{1} '_Chewing.mat']);
syncName = fullfile(pwd,[name{1} '_DIG_sync.mat']);

vidOffset = syncVid(scoreName,syncName);
offsetName = fullfile(pwd,[name{1} '_vidOffset.mat']);

save(offsetName,'vidOffset','-v7.3');

%% SCORE VIDEO FOR _2
filename{2} = fullfile(...
   'K:\Rat\Video\Window Discriminator\R18-159',...
   'R18-159_2019_02_01_2.MP4');
block{2} = fullfile(...
   'P:\Extracted_Data_To_Move\Rat\Intan\R18-159',...
   'R18-159_2019_02_01_2');

fig = getChewingEpochs(filename{2});
waitfor(fig);
[~,name{2},~] = fileparts(filename{2});
scoreName = fullfile(pwd,[name{2} '_Chewing.mat']);

vidOffset = syncVid(scoreName,syncName);
offsetName = fullfile(pwd,[name{2} '_vidOffset.mat']);

save(offsetName,'vidOffset','-v7.3');

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

%% CHARACTERIZE DETECTION ON BOTH RECORDINGS
for ii = 1:2

end

