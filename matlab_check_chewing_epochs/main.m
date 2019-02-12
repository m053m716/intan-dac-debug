%% MAIN  Make chewing epoch figure panel
clear; close all; clc

%% DEFAULTS
T_START = 36.1;  % (sec) // start of chewing epoch of interest
T_STOP = 36.3;   % (sec) // end of chewing epoch of interest

% CHEW_BURST_START = [36.15,36.40];
% CHEW_BURST_STOP = [36.29,36.56];

CHEW_BURST_START = 36.15;
CHEW_BURST_STOP = 36.29;

%% LOAD DATA
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');

load(fullfile(in_dir,'R18-159_2019_02_01_2_Chewing-Refined.mat'));
dac = load(fullfile(in_dir,'R18-159_2019_02_01_2_DAC.mat'));
dac.t = 0:(1/dac.fs):((numel(dac.data)-1)/dac.fs);

threshSpk = struct;
load(fullfile(in_dir,'R18-159_2019_02_01_2_DAC-Thresh_spikes.mat'),...
   'peak_train');
load(fullfile(in_dir,'R18-159_2019_02_01_2_DAC-Thresh_sort.mat'),...
   'class');
threshSpk.ts = peak_train/dac.fs;
threshSpk.sort = class; % They are all counted as spike

fsmSpk = struct;
load(fullfile(in_dir,'R18-159_2019_02_01_2_DAC-FSM_spikes.mat'),...
   'peak_train');
load(fullfile(in_dir,'R18-159_2019_02_01_2_DAC-FSM_sort.mat'),...
   'class');
fsmSpk.ts = peak_train/dac.fs;
fsmSpk.sort = class;
fsmSpk.wMax = 24;

%% GET INDEXING VARIABLES AND SHAPE FOR BURSTS
dac = updateDacStructData(dac,T_START,T_STOP);
burstIdx = round((mean([CHEW_BURST_START;CHEW_BURST_STOP],1) - T_START)*dac.fs);
t = getBoxTimeValues(CHEW_BURST_START,CHEW_BURST_STOP);
y = getBoxAmplitudes(burstIdx,dac.data,4500);
chewPeriods = makeChewBoxShapes(t,y);

%% GET SHAPE VARIABLES FOR SPIKES
fsmSpk = updateSpikeStructData(fsmSpk,dac);
threshSpk = updateSpikeStructData(threshSpk,dac);
threshSpikeBox = makeSpikeBoxShape(threshSpk,dac);
fsmSpikeBox = makeSpikeBoxShape(fsmSpk,dac);

%% MAKE FIGURE
fig = figure('Name','DAC Chewing Artifact Performance',...
   'Units','Normalized',...
   'Position',[0.3 0.3 0.5 0.6],...
   'Color','w'); 
ax1 = axes(fig,'Units','Normalized',...
   'Position',[0.05 0.525 0.9 0.425],...
   'Color','w',...
   'FontName','Arial',...
   'XColor','k',...
   'YColor','k',...
   'XTick',[],...
   'NextPlot','add');
ax2 = axes(fig,'Units','Normalized',...
   'Position',[0.05 0.05 0.9 0.425],...
   'Color','w',...
   'FontName','Arial',...
   'XColor','k',...
   'YColor','k',...
   'NextPlot','add');
plot(ax1,dac.t,dac.data,'Color','k','LineWidth',1.25);
plot(ax2,dac.t,dac.data,'Color','k','LineWidth',1.25);
patch(ax1,chewPeriods);
patch(ax2,chewPeriods);
patch(ax1,threshSpikeBox);
patch(ax2,fsmSpikeBox);
title(ax1,'Threshold Detector','FontName','Arial','FontSize',16,'Color','k');
title(ax2,'State Machine Detector','FontName','Arial','FontSize',16,'Color','k');
ylabel(ax1,'Amplitude (\muV)','FontName','Arial','FontSize',14,'Color','k');
ylabel(ax2,'Amplitude (\muV)','FontName','Arial','FontSize',14,'Color','k');
xlabel(ax2,'Time (sec)','FontName','Arial','FontSize',14,'Color','k');