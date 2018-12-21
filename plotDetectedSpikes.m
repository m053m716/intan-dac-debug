function fig = plotDetectedSpikes(dac,dig,w,th,COL)
%% PLOTDETECTEDSPIKES   Plot spikes detected by DAC comparator
%
%  fig = PLOTDETECTEDSPIKES(dac,dig);
%
% By: Max Murphy  v1.0  12/20/2018  Original version (R2017a)

%% DEFAULTS
Q = 32768;

%% MAKE FIGURE

fig = figure('Name','Detected Spikes',...
   'Color','w',...
   'Units','Normalized',...
   'Position',[0.25,0.20,0.40,0.66]);

%% IDENTIFY TIMING
% First row corresponds to FSM complete sample indicator:
fsm_complete = find(dig.data(1,:));

% Get some number of samples around the event of interest:
ivec = -2:(n_samples+1);

% Get max sample number for offset
n_samples = max(max(w));

%% FIND ALL SPIKES AND PLOT
% Each DAC channel is the same amplifier channel, routed to a different
% DAC. Because this occurs at (very slightly) different times within a
% single sample clock cycle, we should actually plot them separately since
% the values of the DAC will be (very slightly) different, even though they
% are theoretically from the exact same data source. 
spikes = cell(size(dac.bits,1),1);

% % Pre-allocate the uint16 streams as well, that will be used for comparison
% % to evaluate similarity of bit values as observed at different stages
% % within the FPGA based on saved bit values.
% dac.pre_gain_bits = zeros(size(dac.bits),'uint16');
% amp.data = zeros(size(amp.bits),'uint16');

% For this reason, we get the different spike samples from each different
% data stream that corresponds to the number of DAC comparator thresholds
% that were used on a given recording:
for ik = 1:numel(spikes)
   
   % Get the start of each "spike"
   fsm_init = fsm_complete - (n_samples); 
   
%    % We would like to look at and compare the DAC and amplifier
%    % waveforms after performing the corresponding transformations to verify
%    % that they are the same (or similar). 
%    dac.bits = convertDAC(dac.bits(ik,:));
   
%    % Also should convert the amplifier stream to microvolt values
%    amp.data = convertAMP(amp.bits(ik,:));
   
   spikes{ik} = nan(numel(fsm_init),numel(ivec));
   keepvec = true(size(spikes{ik},1),1);
   for ii = 1:numel(fsm_init)
      if (min(ivec+fsm_init(ii))<1)||(max(ivec+fsm_init(ii))>size(dac.bits,2))
         keepvec(ii) = false;
      else
         spikes{ik}(ii,:) = dac.bits(ivec + fsm_init(ii));
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
   
   line(w(ik,:), th(ik,:), ...
      'Color',COL{ik},...
      'LineWidth',1.5,...
      'MarkerIndices',1,...
      'Marker','o',...
      'MarkerFaceColor',COL{ik});
   
   line([min(ivec) max(ivec)],[Q Q],...
      'Color',[0.8 0.8 0.8],...
      'LineStyle',':');
end

%% ADD THE FSM STATES TO THE BOTTOM PLOT
subplot(numel(spikes)+1,1,ik+1);

fsm_complete = nan(numel(fsm_init),numel(ivec));
fsm_active = nan(numel(fsm_init),numel(ivec));
keepvec = true(size(fsm_active,1),1);
for ii = 1:numel(fsm_init)
   if (min(ivec+fsm_init(ii))<1)||(max(ivec+fsm_init(ii))>size(dig.data,2))
      keepvec(ii) = false;
   else
      fsm_complete(ii,:) = dig.data(1,ivec+fsm_init(ii))+0.1;
      fsm_active(ii,:) = dig.data(2,ivec + fsm_init(ii));
   end
end

fsm_active = fsm_active(keepvec,:);
if size(spikes,1)>1500
   plot(ivec,fsm_active(idx,:),'Color',[0.8 0.8 0.8]);
   hold on; plot(ivec,fsm_complete(idx,:),'Color','b');
else
   plot(ivec,fsm_active,'Color',[0.8 0.8 0.8]);
   hold on; plot(ivec,fsm_complete,'Color','b');
end
childLine = get(gca,'Children');
n = numel(childLine);
legend([childLine(n),childLine(1)],{'FSM-Active','FSM-Complete'},...
   'Location','south');

suptitle([num2str(n_samples-1) ' samples offset)']);

end