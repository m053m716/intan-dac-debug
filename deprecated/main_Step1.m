%% MAIN_STEP1  Batch for evaluating prior performance of ADS window discrim
clear; clc;
close all force;

%% KNOWN PARAMETERS
BLOCK = 'R18-00_2018_12_18';
REC = '_1';

[flag,x] = get_files_of_interest(BLOCK,[BLOCK REC]);
if ~flag
   error('Something went wrong with saving files of interest.');
end

%% DATA - NOTE: GET_FILES_OF_INTEREST should be run first
% Times (sec) for recording
load(fullfile(BLOCK,[BLOCK REC '-Time.mat']),'t','fs');

% STIM DATA: CHANNEL B-002 (P2_Ch_002)
% stim = load(fullfile(BLOCK,[BLOCK '-StimData.mat']));

% DIG-IN-13: STIM TRIGGER     ||       Row 1
% DIG-IN-14: FSM-ACTIVE       ||       Row 2
% DIG-IN-15: FSM-IDLE         ||       Row 3
dig = load(fullfile(BLOCK,[BLOCK REC '-DigData.mat']));

% ANALOG-OUT-1: CHANNEL A-011 (P1_Ch_011)  || Hardware Filter Data
dac = load(fullfile(BLOCK,[BLOCK REC '-DACData.mat']));

% Load window params extracted by GET_FILES_OF_INTEREST
load(fullfile(BLOCK,[BLOCK REC '-WindowParams.mat']),'W','TH','COL');

%% FIGURES
% figure('Name','State Machine Realization - Example',...
%    'Color','w',...
%    'Position',[942,407,1014,654]);
% idx = t>=166.1426 & t<=166.1514;
% t_idx = t(idx);
%
% h(1)=subplot(3,1,1);
% plot(t_idx,dig.data(:,idx),'LineWidth',2);
% ylim([-0.1 1.1]);
% xlabel('Time (sec)','FontName','Arial','FontSize',14);
% ylabel('Logical State','FontName','Arial','FontSize',14);
% legend({'FSM-Complete';'FSM-Active';'FSM-Idle'},'Location','East');
%
% h(2)=subplot(3,1,2);
% plot(t_idx,stim.data(:,idx),'LineWidth',2);
% ylim([-75 75]);
% xlabel('Time (sec)','FontName','Arial','FontSize',14);
% ylabel('Stim Amplitude (\muV)','FontName','Arial','FontSize',14);
%
% h(3)=subplot(3,1,3);
% plot(t_idx,dac.data(:,idx),'LineWidth',2);
% ylim([-0.5 0.5]);
% xlabel('Time (sec)','FontName','Arial','FontSize',14);
% ylabel('DAC Amplitude (mV)','FontName','Arial','FontSize',14);
%
% fsm_start = t_idx(find(dig.data(2,idx),1,'first'));
%
% % are we sure that the sample in which fsm_active is 1 is the actual sample?
% % or the next one with respect to the sampled data?
% % still to check on the FPGA code if the window limits are inclusive or not!
% % fsm_start = t_idx(find(dig.data(2,idx),1,'first')-1); % note the -1
% hold on;
%
% w = convertFSMWindow(W);
%
% line((w(1,:))./fs + fsm_start, [I1 I1]*1e-3, 'Color','b','LineWidth',1.5,'MarkerIndices',1,'Marker','o','MarkerFaceColor','b');
% line((w(1,:))./fs + fsm_start, [E1 E1]*1e-3, 'Color','r','LineWidth',1.5,'MarkerIndices',1,'Marker','sq','MarkerFaceColor','r');
% line((w(2,:))./fs + fsm_start, [I2 I2]*1e-3, 'Color','b','LineWidth',1.5,'MarkerIndices',1,'Marker','o','MarkerFaceColor','b');
% line((w(2,:))./fs + fsm_start, [E2 E2]*1e-3, 'Color','r','LineWidth',1.5,'MarkerIndices',1,'Marker','sq','MarkerFaceColor','r');
%
% linkaxes(h,'x')

%% DO DATA VALUE CONVERSION BACK TO UINT16 FOR COMPARISONS
w = convertFSMWindow(W);

% for N = [0,1]
for N = 0
%       for N_SAMPLES = [max(max(W)),max(max(W))+1,max(max(W))+2,max(max(W))+3]
   for N_SAMPLES = max(max(W))
      
      
      th = convertThresh(TH,'N',N);
      
      % IDENTIFY ALL SPIKES
      figure('Name','Detected Spikes',...
         'Color','w',...
         'Position',[642,307,1014,949]);
      
      fsm_complete = find(dig.data(1,:));
      
      
      ivec = -2:(N_SAMPLES+1);
      
      spikes = cell(size(dac.data,1),1);
      
      for ik = 1:numel(spikes)
         fsm_init = fsm_complete - (N_SAMPLES); % FSM active some # samples before
         data = convertDacUInt16(dac.data(ik,:),'N',N);
         spikes{ik} = nan(numel(fsm_init),numel(ivec));
         keepvec = true(size(spikes{ik},1),1);
         for ii = 1:numel(fsm_init)
            if (min(ivec+fsm_init(ii))<1)||(max(ivec+fsm_init(ii))>size(data,2))
               keepvec(ii) = false;
            else
               spikes{ik}(ii,:) = data(ivec + fsm_init(ii));
            end
         end
         spikes{ik} = spikes{ik}(keepvec,:);
         subplot(numel(spikes)+1,1,ik);
         
         if size(spikes,1)>1500
            if ik==1
               idx = randperm(size(spikes,1),1500);
            end
            plot(ivec,spikes{ik}(idx,:),'k');
         else
            plot(ivec,spikes{ik},'k');
         end
         xlabel('Index');
         ylabel('Spike Amplitude (\muV)');
         hold on;
         
%          line(w(ik,:), th(ik,:), 'Color',COL{ik},'LineWidth',1.5,'MarkerIndices',1,'Marker','o','MarkerFaceColor',COL{ik});
         line(W(ik,:), th(ik,:), 'Color',COL{ik},'LineWidth',1.5,'MarkerIndices',1,'Marker','o','MarkerFaceColor',COL{ik});
         line([min(ivec) max(ivec)],[32768 32768],'Color',[0.8 0.8 0.8],'LineStyle',':');
      end
      subplot(numel(spikes)+1,1,ik+1);
      
      fsm_complete = nan(numel(fsm_init),numel(ivec));
      fsm_active = nan(numel(fsm_init),numel(ivec));
      keepvec = true(size(fsm_active,1),1);
      for ii = 1:numel(fsm_init)
         if (min(ivec+fsm_init(ii))<1)||(max(ivec+fsm_init(ii))>size(data,2))
            keepvec(ii) = false;
         else
            fsm_complete(ii,:) = dig.data(1,ivec+fsm_init(ii))+0.1;
            fsm_active(ii,:) = dig.data(2,ivec + fsm_init(ii));
         end
      end
      
      fsm_active = fsm_active(keepvec,:);
%       legtext = [];
      if size(spikes,1)>1500
         plot(ivec,fsm_active(idx,:),'Color',[0.8 0.8 0.8]);
%          k = numel(get(gca,'Children'));
%          legtext = [legtext; repmat({'FSM-Active'},k,1)]; %#ok<*AGROW>
         hold on; plot(ivec,fsm_complete(idx,:),'Color','b');
      else
         plot(ivec,fsm_active,'Color',[0.8 0.8 0.8]);
%          k = numel(get(gca,'Children'));
%          legtext = [legtext; repmat({'FSM-Active'},k,1)];
         hold on; plot(ivec,fsm_complete,'Color','b');
      end
      childLine = get(gca,'Children');
      n = numel(childLine);
%       legtext = [legtext; repmat({'FSM-Complete'},n-k,1)];
%       legend([1,n],legtext);
      legend([childLine(n),childLine(1)],{'FSM-Active','FSM-Complete'},...
         'Location','south');
      
      suptitle(['N = ' num2str(N) ' (' num2str(N_SAMPLES-1) ' samples offset)']);
   end
end

%% MAKE FIGURE FOR STREAM COMPARISON
fig = compareTriggerStreams(x.t,x.amplifier_data(1,:),dac.data(1,:));

