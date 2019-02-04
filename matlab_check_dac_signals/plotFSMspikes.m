function fig = plotFSMspikes(name,spikes,rejects,params)
%% PLOTFSMSPIKES  Plot spikes detected on DAC FSM
%
%  fig = PLOTFSMSPIKES(name,spikes,rejects,params);
%
%  --------
%   INPUTS
%  --------
%   name       :     Cell array of block names
%
%  spikes      :     Cell array of "good" spikes
%
%  rejects     :     Cell array of "rejected" spikes
%
%  params      :     Cell array of parameters used for FSM on DAC
%
%  --------
%   OUTPUT
%  --------
%    fig       :     Cell array of figure handles produced
%
% By: Max Murphy v1.0   2019-02-04  Original version (R2017a)

%% DEFAULTS
FS = 30000; % Hz
T = (-7:23) / FS * 1000; % msec

%% USE RECURSION TO ITERATE
if iscell(name)
   fig = cell(size(name));
   for ii = 1:numel(name)
      fig{ii} = plotFSMspikes(name{ii},spikes{ii},rejects{ii},params{ii});
   end
   return;
end

fig = figure('Name',['DAC spikes: ' name],...
   'Units','Normalized',...
   'Color','w',...
   'Position',[0.1,0.45,0.35,0.45]);

plot(T,rejects(randperm(size(rejects,1),100),:).',...
   'Color',[0.85 0.85 0.85],...
   'Linewidth',1.75);

hold on;
plot(T,spikes(randperm(size(spikes,1),100),:).',...
   'Color',[0.6 0.1 0.8],...
   'Linewidth',1.75);

for iP = 1:numel(params)
   x = [params(iP).window_start_sample,...
        params(iP).window_stop_sample - 0.9] / FS * 1000;
   y = [params(iP).voltage_threshold, ...
        params(iP).voltage_threshold];
   ie = params(iP).trigger_window_type;

   if ie == 0
      line(x,y,'Color','c','LineWidth',3,...
         'Marker','o','MarkerFaceColor','k',...
         'MarkerIndices',1,'MarkerSize',15);
   else
      line(x,y,'Color','r','LineWidth',3,...
         'Marker','o','MarkerFaceColor','k',...
         'MarkerIndices',1,'MarkerSize',15);
   end

end

xlabel('Time (ms)','FontName','Arial','FontSize',14,'Color','k');
ylabel('Amplitude (\muV)','FontName','Arial','FontSize',14,'Color','k');
title('FSM Detected Spikes','FontName','Arial','FontSize',18,'Color','k');
xlim([min(T) max(T)]);
ylim([-250 100]);


end