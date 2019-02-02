%% MAIN   Batch for running video scoring and video synchronization
clear; close all; clc

%% SCORE VIDEO FOR _1
filename{1} = fullfile(...
   'K:\Rat\Video\Window Discriminator\R18-159',...
   'R18-159_2019_02_01_1.MP4');

fig = getChewingEpochs(filename{1});
waitfor(fig);
[~,name,~] = fileparts(filename{1});
scoreName = fullfile(pwd,[name '_Chewing.mat']);
syncName = fullfile(pwd,[name '_DIG_sync.mat']);

vidOffset = syncVid(scoreName,syncName);
offsetName = fullfile(pwd,[name '_vidOffset.mat']);

save(offsetName,'vidOffset','-v7.3');

%% SCORE VIDEO FOR _2
filename{2} = fullfile(...
   'K:\Rat\Video\Window Discriminator\R18-159',...
   'R18-159_2019_02_01_2.MP4');

fig = getChewingEpochs(filename{2});
waitfor(fig);
[~,name,~] = fileparts(filename{2});
scoreName = fullfile(pwd,[name '_Chewing.mat']);

vidOffset = syncVid(scoreName,syncName);
offsetName = fullfile(pwd,[name '_vidOffset.mat']);

save(offsetName,'vidOffset','-v7.3');

%% NEED TO REFINE THESE EPOCHS USING WAVEFORM TRACES

for ii = 1:2
   fig = refineChewingEpochs(filename{ii});
   waitfor(fig);
end