function [fig1,fig2] = plotTriggerStreams(t,amp,dac,varargin)
%% PLOTTRIGGERSTREAMS   Plot subplot comparisons of trigger ADC & DAC 
%
%  fig1 = PLOTTRIGGERSTREAMS(amp,dac,'NAME',value,...);
%  [fig1,fig2] = PLOTTRIGGERSTREAMS(amp,dac,'NAME',value,...);
%
%  --------
%   INPUTS
%  --------
%      t       :     Time corresponding to each sample in amplifier streams
%
%     amp      :     Amplifier stream (single-channel) waveform. 1 x k
%                                                                 samples.
%
%     dac      :     DAC stream (single-channel; corresponds to amplifier
%                                               channel).
%
%  varargin    :     (Optional) 'NAME', value input argument pairs.
%
%                    -> FIGPOS [default figure position]
%
%  --------
%   OUTPUT
%  --------
%     fig1     :     Figure handle containing the comparison plots.
%
%     fig2     :     Figure handle containing power spectrum of error.
%
% BY: Max Murphy  v1.0  12/18/2018  Original version (R2017b)

%% DEFAULTS
FIGPOS = [0.08,0.070,0.85,0.85]; % normalized [x_bottom_left,y,w,h]
T_IDX = [10.04, 10.06];          % time (seconds) to look at
FC = 300;                        % Cutoff freq. (Hz)
Q = 32768;

FIGNAME = 'Trigger_Stream_Comparison2';

%% PARSE VARARGIN
for iV = 1:2:numel(varargin)
   eval([upper(varargin{iV}) '=varargin{iV+1};']);
end

%% GET RECONSTRUCTED DATA
rec = convertDacUInt16(dac);

%% MAKE FIGURE
fig1 = figure('Name', 'Trigger Stream Comparison',...
   'Color','w','Units','Normalized','Position',FIGPOS);

% Get subset to plot
t_idx = (t>=T_IDX(1)) & (t<=T_IDX(2));

% Get locations for text
tx = sum(T_IDX)/2;
ty = 0;

% Plot trigger amplifier channel being fed to DAC
subplot(5,1,1); 
plot(t(t_idx),amp(1,t_idx),'Color','k','LineWidth',1.75); 
title('Trigger: Raw Stream',...
   'FontName','Arial','FontSize',14,'Color','k');
ylabel('\muV',...
   'FontName','Arial','FontSize',14,'Color','k');
xlim(T_IDX);
text(tx,ty,'x[n]','Color','k','FontSize',14,'FontName','Arial');

% Plot recorded DAC values
subplot(5,1,2); 
plot(t(t_idx),dac(1,(t_idx)),'Color','r','LineWidth',1.75);  
title('DAC: Recorded (HPF) Stream',...
   'FontName','Arial','FontSize',14,'Color','k');
ylabel('bits (uint16)',...
   'FontName','Arial','FontSize',14,'Color','k');
xlim(T_IDX);
text(tx,Q+0.01*Q,'y_{rec}[n]','Color','r','FontSize',14,'FontName','Arial');
line(T_IDX,[Q Q],'Color',[0.8 0.8 0.8],'LineWidth',2,'LineStyle',':');

% Plot reconstructed DAC values
subplot(5,1,3); 
plot(t(t_idx),rec(1,(t_idx)),'Color','b','LineWidth',1.75); 
title('DAC: \muV Reconstructed (HPF) Stream',...
   'FontName','Arial','FontSize',14,'Color','k');
xlabel('Time (sec)',...
   'FontName','Arial','FontSize',14,'Color','k');
ylabel('\muV',...
   'FontName','Arial','FontSize',14,'Color','k');
xlim(T_IDX);
text(tx,ty,'y_{rec}[n]*1e3','Color','r','FontSize',14,'FontName','Arial');

% Plot HPF reconstruction from amplifier data
subplot(5,1,4); 
fs = mode(round(1./diff(t)));
amp_hp = HPF(amp(1,:),FC,fs);
plot(t(t_idx),amp_hp(1,(t_idx)),'Color','b','LineWidth',1.75); 
title('Trigger: HPF Stream',...
   'FontName','Arial','FontSize',14,'Color','k');
xlabel('Time (sec)',...
   'FontName','Arial','FontSize',14,'Color','k');
ylabel('\muV',...
   'FontName','Arial','FontSize',14,'Color','k');
xlim(T_IDX);
text(tx,ty,'y_{filt}[n] = conv(h[n],x[n])',...
   'Color','b','FontSize',14,'FontName','Arial');

% Plot error signal
subplot(5,1,5); 
e = amp_hp - rec;
plot(t(t_idx),e(1,(t_idx)),'Color','m','LineWidth',1.75); 
title('Error Stream',...
   'FontName','Arial','FontSize',14,'Color','k');
xlabel('Time (sec)',...
   'FontName','Arial','FontSize',14,'Color','k');
ylabel('\muV',...
   'FontName','Arial','FontSize',14,'Color','k');
xlim(T_IDX);
text(tx,ty+max(e(t_idx))*1.1,'e[n] = y_{filt}[n] - y_{rec}[n]',...
   'Color','m','FontSize',14,'FontName','Arial');

savefig(fig1,fullfile('figs', [FIGNAME '.fig']));
saveas(fig1,fullfile('figs', [FIGNAME '.png']));

fig2 = figure('Name','Spectrum of Error',...
   'Units','Normalized','Color','w','Position',FIGPOS); 
[pxx,f,pxxc] = periodogram(e,rectwin(length(e)),length(e),fs,...
    'ConfidenceLevel', 0.95);
plot(f,10*log10(pxx))
hold on
plot(f,10*log10(pxxc),'r-.')
title('Error Periodogram with 95%-Confidence');
xlabel('Hz')
ylabel('dB')

savefig(fig2,fullfile('figs', [FIGNAME '_errorFreqs.fig']));
saveas(fig2,fullfile('figs', [FIGNAME '_errorFreqs.png']));

end