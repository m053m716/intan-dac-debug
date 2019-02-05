%% MAIN  - Script for organizing code to analyze performance of FSM
clear; clc; close all force

%% SET INFO
NAME = {'R18-159_2019_02_01_2'};
TOL = [5,15,35,60,100,200];
FS = 30000; % Hz

%% CHARACTERIZE DETECTION ON BOTH RECORDINGS
t = cell(numel(NAME),numel(TOL));
y = cell(size(t));

for ii = 1:numel(NAME)
   for iT = 1:numel(TOL)
      [t{ii,iT},y{ii,iT}] = getFSMperformance(NAME{ii},FS,TOL(iT));
      
      figure('Color','w');
      str = sprintf('Confusion Matrix: %s - TOL = %d',...
         NAME{ii},TOL(iT));
      plotconfusion(t{ii,iT},y{ii,iT},str);

      set(gcf,'Name',str);
   end
   
end