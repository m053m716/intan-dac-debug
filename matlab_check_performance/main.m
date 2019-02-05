%% MAIN  - Script for organizing code to analyze performance of FSM
clear; clc

%% SET INFO
NAME = {'R18-159_2019_02_01_2'};
FS = 30000; % Hz

%% CHARACTERIZE DETECTION ON BOTH RECORDINGS
[roc,y,t] = getFSMperformance(NAME,FS);

for ii = 1:numel(y)
   for iC = 1:numel(y{ii})
      figure('Name',['ROC - ' NAME{ii} ' - Cluster ' num2str(iC)],...
         'Color','w');
      plotconfusion(t{ii}{iC}.',y{ii}{iC}.');
   end   
end