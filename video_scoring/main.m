%% MAIN   Batch for running video scoring and video synchronization
clear; close all; clc

%% SCORE VIDEO FOR _1
filename = fullfile(...
   'K:\Rat\Video\Window Discriminator\R18-159',...
   'R18-159_2019_02_01_1.MP4');

fig = getChewingEpochs(filename);
waitfor(fig);
[~,name,~] = fileparts(filename);
scoreName = fullfile(pwd,[name '_Chewing.mat']);
syncName = fullfile(pwd,[name '_DIG_sync.mat']);

vidOffset = syncVid(scoreName,syncName);
offsetName = fullfile(pwd,[name '_vidOffset.mat']);

save(offsetName,'vidOffset','-v7.3');

%% SCORE VIDEO FOR _2
filename = fullfile(...
   'K:\Rat\Video\Window Discriminator\R18-159',...
   'R18-159_2019_02_01_2.MP4');

fig = getChewingEpochs(filename);
waitfor(fig);
[~,name,~] = fileparts(filename);
scoreName = fullfile(pwd,[name '_Chewing.mat']);

vidOffset = syncVid(scoreName,syncName);
offsetName = fullfile(pwd,[name '_vidOffset.mat']);

save(offsetName,'vidOffset','-v7.3');

