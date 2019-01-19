function [fig,x] = plotLongSegment(T,data,dig,th,col,w,varargin)
%% PLOTLONGSEGMENT   Plot long segment with overlaid FSM state events
%
%  fig = PLOTLONGSEGMENT(T,data,dig,th,col);
%  [fig,x] = PLOTLONGSEGMENT(T,data,dig,th,col);
%
%  --------
%   INPUTS
%  --------
%     T        :     Times to plot (2-element vector start/stop time, sec)
%
%    data      :     Data stream struct to plot. Should have 'bits' and 't'
%                       fields. Each element of t should have a bit value
%                       that was read at t.
%
%     dig      :     Digital struct containing a data field that is each of
%                       the different FSM digital states for each sample.
%                       Also has 't' field that corresponds with data
%                       struct.
%
%     th       :     Threshold levels
%
%     col      :     Threshold colors
%
%     w        :     (optional) Window durations (samples)
%
%  --------
%   OUTPUT
%  --------
%    fig       :     Output a data stream with the long vector and
%                       superimpose the threshold windows on top. On
%                       bottom, plot the digital states.
%
%     x        :     Timeseries object that appends completed cycles to the
%                       as events.
%
% By: Max Murphy  v1.0  12/20/2018  Original version (R2017a)

%% DEFAULTS
Q = 32768;
OFFSET_COMPLETE = 0;
OFFSET = 0;
OFFSET_START = 7; % samples
PLOT_TYPE = 'bits';

if nargin < 6
   w = [OFFSET_COMPLETE OFFSET_START OFFSET];
elseif isempty(w)
   w = [OFFSET_COMPLETE OFFSET_START OFFSET];
else
   w = [w(1,1) max(max(w)) OFFSET];
end

%% PARSE VARARGIN
for iV = 1:2:numel(varargin)
   eval([upper(varargin{iV}) '=varargin{iV+1};']);
end

if strcmpi(PLOT_TYPE,'filt')
   Q = 0;
end

%% MAKE FIGURE
fig = figure('Name','Data Stream Thresholds',...
   'Color','w',...
   'Units','Normalized',...
   'Position',[0.25,0.20,0.40,0.66]);

t_idx = (data.t >= T(1)) & (data.t <= T(2));
subplot(2,1,1);

% i_evt = find(dig.data(1,:)>0);
% t_evt = dig.t(i_evt-w(1));
% c_evt = t_evt((t_evt >= T(1)) & (t_evt <= T(2)));
% 
% t_evt = dig.t(i_evt-w(2));
% s_evt = t_evt((t_evt >= T(1)) & (t_evt <= T(2)));

a_evt = dig.t(find(dig.data(2,:)>0)-w(3));
a_evt = a_evt((a_evt>=T(1)) & (a_evt <= T(2)));

x = timeseries(data.(PLOT_TYPE)(1,t_idx),data.t(t_idx),...
   'Name',PLOT_TYPE);
x.TimeInfo.Units = 'seconds';
for iE = 1:numel(a_evt)
%    x = addevent(x,'FSM-Start',s_evt(iE));
%    x = addevent(x,'FSM-Complete',c_evt(iE));
   x = addevent(x,'FSM-Active',a_evt(iE));
end

plot(x);
xlim([min(x.Time) max(x.Time)]);

hold on;
for ii = 1:size(th,1)
   line(T,th(ii,:),'Color',col{ii},'LineWidth',1.5,'LineStyle','--');
end
line(T,[Q Q],'Color',[0.5 0.5 0.5],'LineWidth',2,'LineStyle',':');
title(sprintf('Data Stream (%s)',PLOT_TYPE),...
   'FontName','Arial','FontSize',14,'Color','k');

subplot(2,1,2);
plot(dig.t(t_idx),dig.data(:,t_idx),'LineWidth',1.75);
xlabel('Time (sec)','FontName','Arial','FontSize',14,'Color','k');
legend({'FSM-Complete';'FSM-Active';'FSM-Idle'},'Location','South');
xlim([min(x.Time) max(x.Time)]);

end