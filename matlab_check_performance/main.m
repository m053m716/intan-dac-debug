%% MAIN  - Script for organizing code to analyze performance of FSM
clear; clc; % close all force

%% SET INFO
NAME = {'R18-159_2019_02_01_2'};
TOL = [2,4,6];
FS = 30000; % Hz
COL = {[0 0 1];[0.75 0.75 0.75];[1 0.25 0.25];[0 0 1]};
T = (-12:24)./FS * 1000;
TYPE = {'True Spike';'False Artifact';'False Spike';'True Artifact'};

CLUS = [2,4,5,6];

%% CHARACTERIZE DETECTION ON BOTH RECORDINGS
t = cell(numel(NAME),numel(TOL));
y = cell(size(t));
type = cell(size(y));

for ii = 1:numel(NAME)
   for iT = 1:numel(TOL)
      [t{ii,iT},y{ii,iT},type{ii,iT}] = ...
         getFSMperformance(NAME{ii},FS,TOL(iT),CLUS);
      
      figure('Color','w');
      str = sprintf('%s - TOL = %d',...
         strrep(NAME{ii},'_','-'),TOL(iT));
      plotconfusion(t{ii,iT},y{ii,iT},str);

      set(gcf,'Name',str);
   end
end

%% PLOT SPIKES

% for ii = 1:numel(NAME)
%    load(fullfile(pwd,NAME{ii},...
%       [NAME{ii} '_wav-sneo_CAR_Spikes'],...
%       [NAME{ii} '_ptrain_P0_Ch_000.mat']),'spikes');
%    for iT = 1:numel(TOL)
%       str = sprintf('Spikes: %s - TOL = %d',...
%          strrep(NAME{ii},'_','-'),TOL(iT));
%       figure('Name',str,'Color','w',...
%          'Units','Normalized','Position',[0.1 0.1 0.8 0.8]);
%       
%       for iPlot = 1:4
%          subplot(2,2,iPlot);
%          plot(T,spikes(type{ii,iT}==iPlot,:),...
%             'Color',COL{iPlot},...
%             'LineWidth',1.75);
%          xlabel('Time (ms)',...
%             'FontName','Arial','FontSize',14,'Color','k');
%          ylabel('Amplitude (\muV)',...
%             'FontName','Arial','FontSize',14,'Color','k');
%          title(TYPE{iPlot},...
%             'FontName','Arial','FontSize',16,'Color','k');
%          xlim([min(T) max(T)]);
%       end
%    end   
% end