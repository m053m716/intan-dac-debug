function fig = refineChewingEpochs(block)
%% REFINECHEWINGEPOCHS  Refine epochs of chewing based on filtered waves
%
%  block = '~\R18-159\R18-159_2019_02_01_0';
%  fig = REFINECHEWINGEPOCHS(block);
%
%  --------
%   INPUTS
%  --------
%   block      :     Directory to BLOCK folder hierarchy.
%
%  --------
%   OUTPUT
%  --------
%    fig       :     Figure handle to interface.
%
%  Set epoch start/stop times for when chewing artifact (which has
%  characteristic signature in BANDPASS-FILTERED unit frequency range) is
%  present.
%
% By: Max Murphy  v1.0  2019-02-02  Original version (R2017a)

%%
SCROLL_VALUE = 0.25;
fig = figure('Name','Chew Epoch Refinement Interface',...
   'Color','w',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8],...
   'WindowKeyReleaseFcn',@onKeyRelease,...
   'CloseRequestFcn',@(src,~)exitScoring);

name = strsplit(block,filesep);
name = name{end};
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');
saveName = fullfile(in_dir,[name '_Chewing-Refined.mat']);

if exist(saveName,'file')==0
   initData = struct('chewEpochStart',nan,...
      'chewEpochStop',nan,...
      'currentScrollTime',SCROLL_VALUE);
else
   initData = load(saveName);
end
currentScrollTime = initData.currentScrollTime;
chewEpochStop = initData.chewEpochStop;
chewEpochStart = initData.chewEpochStart;

[fig,h] = plotWaves(fig,nan,...
   'OFFSET',currentScrollTime,...
   'LEN',SCROLL_VALUE,...
   'DIR',fullfile(block,[name '_Filtered']));
set(h,'ButtonDownFcn',@onButtonClick);
y = max(h.YLim);
tStart = stem(h,...
   chewEpochStart,...
   ones(size(initData.chewEpochStart))*y,...
   'Color',[0.4 0.4 1.0],...
   'LineWidth',2,...
   'Marker','o',...
   'MarkerFaceColor','b');
tStop = stem(h,...
   chewEpochStop,...
   ones(size(initData.chewEpochStop))*y,...
   'Color',[1.0 0.4 0.4],...
   'LineWidth',2,...
   'Marker','h',...
   'MarkerFaceColor','r');

   function onButtonClick(src,evt)
      %% ONBUTTONCLICK  On button down for waves axes
      curTime = src.CurrentPoint(1,1);
      switch evt.Button
         case 1 % Left-click
            chewEpochStart = updateIndexVector(chewEpochStart,curTime);
            addRemoveStart(chewEpochStart,max(src.YLim));
         case 3 % Right-click
            chewEpochStop = updateIndexVector(chewEpochStop,curTime);
            addRemoveStop(chewEpochStop,max(src.YLim));
      end
   end

   function addRemoveStart(x,scale)
      %% ADDREMOVESTART    Add or remove an epoch START point
      
      if isvalid(tStart)
         set(tStart,'XData',x,...
                    'YData',ones(size(x)) * scale);
      else
         tStart = stem(h,...
            x,...
            ones(size(x))*y,...
            'Color',[0.4 0.4 1.0],...
            'LineWidth',2,...
            'Marker','o',...
            'MarkerFaceColor','b');
      end
      
      disp('Chew starts:');
      disp(x);
      
   end

   function addRemoveStop(x,scale)
      %% ADDREMOVESTOP    Add or remove an epoch STOP point
      if isvalid(tStop)
         set(tStop,'XData',x,...
                   'YData',ones(size(x)) * scale);
      else
         tStop = stem(h,...
            x,...
            ones(size(x))*y,...
            'Color',[1.0 0.4 0.4],...
            'LineWidth',2,...
            'Marker','h',...
            'MarkerFaceColor','r');
      end
      
      disp('Chew stops:');
      disp(x);
      
   end

   function x_new = updateIndexVector(x,curTime)
      %% UPDATEINDEXVECTOR    Update the time series vector
      
      % set TOLERANCE here (0.01 sec to refine chewing)
      inSet = abs(x - curTime) < 0.01;
      
      if any(inSet)
         x_new = x(~inSet);
      else
         x = [x, curTime];
         x_new = sort(x(~isnan(x)),'ascend');
      end
   end

   function saveScoring()
      %% SAVESCORING    Save scored data for chewing epochs
      data = struct('chewEpochStart',chewEpochStart,...
         'chewEpochStop',chewEpochStop,...
         'currentScrollTime',currentScrollTime);
      save(saveName,'-struct','data','-v7.3');
      disp('Scoring saved.');
   end

   function exitScoring(figHandle)
      %% EXITSCORING  Check whether to exit, then delete global variables
      str = questdlg('Exit scoring?','Exit?','Yes','No','Yes');
      if strcmp(str,'Yes')
         delete(figHandle);
         clear saveName tStart tStop currentScrollTime fig h
      end
   end

   function updateScrollTime(tNew)
      [fig,h] = plotWaves(fig,h,...
         'OFFSET',tNew,...
         'LEN',SCROLL_VALUE,...
         'DIR',fullfile(block,[name '_Filtered']));
      currentScrollTime = tNew;
   end

   function onKeyRelease(src,evt)
      %% ONKEYRELEASE   To perform when a key button is released
      switch evt.Key
         case {'d','rightarrow'}
            tNew = currentScrollTime + SCROLL_VALUE;
            try
               updateScrollTime(tNew);
            catch
               warning('Beginning of record.');
            end
            
         case {'a','leftarrow'}
            tNew = currentScrollTime - SCROLL_VALUE;
            if tNew > (SCROLL_VALUE/2)
               updateScrollTime(tNew);
            else
               warning('Beginning of record.');
            end
            
         case 's'
            if ismember(evt.Modifier,{'alt','control'})
               saveScoring();
            end
         case 'escape'
            exitScoring(src);
      end
   end



end