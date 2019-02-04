function fig = getChewingEpochs(filename)
%% GETCHEWINGEPOCHS     Manually score videos for chewing epochs
%
%  GETCHEWINGEPOCHS;
%  fig = GETCHEWINGEPOCHS(filename);
%
%  --------
%   INPUTS
%  --------
%  filename    :     Full path and filename of video to score.
%
%  --------
%   OUTPUT
%  --------
%  Graphical interface for marking onset/offset of chewing epochs. 
%  Saves results in file with extension _Chewing.mat, in this folder.
%
% By: Max Murphy  v1.0  2019/02/02  Original version (R2017a)

%% PARSE INPUT
if nargin < 1
   [fname,pname] = uigetfile('*.MP4','Select VIDEO',...
      'K:\Rat\Video\Window Discriminator\R18-159');
   if fname == 0
      error('No file selected. Script aborted.');
   end
   filename = fullfile(pname,fname);
else
   filename = fullfile(filename); 
end

%% LOAD VIDEO
V = VideoReader(filename);

isPlaying = false;
vTimer = timer('StartFcn',@(~,~)playVideo(),...
   'StopFcn',@(~,~)pauseVideo(),...
   'ExecutionMode','fixedRate',...
   'Period',0.05,... % Can't go any faster
   'TimerFcn',@(~,~)updateFrame());

[~,name,~] = fileparts(filename);
titleName = strrep(name,'_','\_');

in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');
saveName = fullfile(in_dir,[name '_Chewing.mat']);

if exist(saveName,'file')==0
   initData = struct('chewEpochStart',nan,...
      'chewEpochStop',nan,...
      'currentCursorTime',(1/V.FrameRate),...
      'syncFrame',nan);
else
   initData = load(saveName);
end
setVidTime(initData.currentCursorTime);

%% MAKE INTERFACE
fig = figure('Name',sprintf('Chewing Scorer: %s',name),...
   'NumberTitle','off',...
   'MenuBar','none',...
   'ToolBar','none',...
   'Color','w',...
   'Units','Normalized',...
   'Position',[0.1 0.1 0.8 0.8],...
   'WindowKeyPressFcn',@onKeyPress,...
   'WindowKeyReleaseFcn',@onKeyRelease,...
   'CloseRequestFcn',@(src,~)exitScoring());

% "Timeline" axis
tAx = axes(fig,'Units','Normalized',...
            'Position',[0.05 0.75 0.9 0.2],...
            'XLimMode','manual',...
            'XLim',[0 V.Duration],...
            'YLimMode','manual',...
            'YLim',[0 1.2],...
            'NextPlot','add',...
            'YTick',[],...
            'YColor','w',...
            'XColor',[0.54 0.54 0.54],...
            'Color',[0.94 0.94 0.94],...
            'ButtonDownFcn',@jumpToFrame);
xlabel('Time (sec)','FontName','Arial','Color',[0.54 0.54 0.54]);
title(titleName,'FontName','Arial',...
   'Color','k','FontWeight','bold','FontSize',20);   

tStart = stem(tAx,...
   initData.chewEpochStart,ones(size(initData.chewEpochStart)),...
   'Color',[0.4 0.4 1.0],...
   'LineWidth',2,...
   'Marker','o',...
   'MarkerFaceColor','b',...
   'ButtonDownFcn',@jumpToFrame);
tStop = stem(tAx,...
   initData.chewEpochStop,ones(size(initData.chewEpochStop)),...
   'Color',[1.0 0.4 0.4],...
   'LineWidth',2,...
   'Marker','x',...
   'MarkerFaceColor','r',...
   'ButtonDownFcn',@jumpToFrame);
tSync = stem(tAx,...
   initData.syncFrame,0.75,...
   'Color',[0.4 1.0 0.4],...
   'LineWidth',2,...
   'Marker','sq',...
   'MarkerFaceColor','r',...
   'ButtonDownFcn',@jumpToFrame);

% Video axis
vAx = axes(fig,'Units','Normalized',...
   'Position',[0.05 0.05 0.9 0.6],...
   'XColor','w','YColor','w',...
   'XLim',[0 1],'YLim',[0 1],...
   'NextPlot','add');
im = imagesc(vAx,[0 1],[1 0],V.readFrame);
set(get(vAx,'Title'),'String',...
    [num2str(V.CurrentTime,'%g') ' sec']);

tCur = stem(tAx,V.CurrentTime,0.5,...
   'LineWidth',1.5,...
   'LineStyle','--',...
   'Color','k',...
   'Marker','none',...
   'ButtonDownFcn',@jumpToFrame);


   function jumpToFrame(src,evt)
      %% JUMPTOFRAME    Jump to a specific video frame
      if isa(src,'matlab.graphics.chart.primitive.Stem')
         src = src.Parent;
      end

      tUpdate = evt.IntersectionPoint(1) - (1/V.FrameRate);
      setVidTime(tUpdate); 
      updateFrame();
      
   end

   function setVidTime(t_new)
      %% SETVIDTIME  Set video time to new value
      V.CurrentTime = updateTime(t_new,V.Duration - (1/V.FrameRate));
   end

   function t_out = updateTime(t_in,max_t)
      %% UPDATETIME  Return a time-value that is valid for this video
      t_i = max(t_in,0);
      t_out = min(t_i,max_t);
   end

   function updateFrame()
      %% UPDATEFRAME    Set the current frame
      if (V.CurrentTime <= (V.Duration - (1/V.FrameRate)))
         im.CData = V.readFrame;
         set(get(im.Parent,'Title'),'String',...
            [num2str(V.CurrentTime,'%g') ' sec']);
         tCur.XData = V.CurrentTime;
         drawnow;
      else
         warning('End of video.');
      end
   end

   function playVideo()
      %% PLAYVIDEO   Execute when video is started
      isPlaying = true;
   end

   function pauseVideo()
      %% PAUSEVIDEO  Execute when video is paused
      isPlaying = false;
   end

   function addRemoveStart()
      %% ADDREMOVESTART    Add or remove an epoch START point
      x = tStart.XData;
      curTime = V.CurrentTime - (1/V.FrameRate);
      x_new = updateIndexVector(x,curTime);
      set(tStart,'XData',x_new,...
                 'YData',ones(size(x_new)));
      
      disp('Chew starts:');
      disp(x_new);
      
   end

   function addRemoveStop()
      %% ADDREMOVESTOP    Add or remove an epoch STOP point
      x = tStop.XData;
      curTime = V.CurrentTime - (1/V.FrameRate);
      x_new = updateIndexVector(x,curTime);
      set(tStop,'XData',x_new,...
                'YData',ones(size(x_new)));
      
      disp('Chew stops:');
      disp(x_new);
      
   end

   function x_new = updateIndexVector(x,curTime)
      %% UPDATEINDEXVECTOR    Update the time series vector
      
      % set TOLERANCE here (0.25 sec is fine for chewing)
      inSet = abs(x - curTime) < 0.25;
      
      if any(inSet)
         x_new = x(~inSet);
      else
         x = [x, curTime];
         x_new = sort(x(~isnan(x)),'ascend');
      end
   end

   function setSync()
      %% SETSYNC  Set the sync frame (first LED flash frame)
      % note that the VideoReader framerate should be 1 frame ahead
      tSync.XData = V.CurrentTime - (1/V.FrameRate);
      
      disp(tSync.XData);
   end

   function saveScoring()
      %% SAVESCORING    Save scored data for chewing epochs
      data = struct('chewEpochStart',tStart.XData,...
         'chewEpochStop',tStop.XData,...
         'currentCursorTime',V.CurrentTime,...
         'syncFrame',tSync.XData);
      save(saveName,'-struct','data','-v7.3');
      disp('Scoring saved.');
   end

   function exitScoring(figHandle)
      %% EXITSCORING  Check whether to exit, then delete global variables
      str = questdlg('Exit scoring?','Exit?','Yes','No','Yes');
      if strcmp(str,'Yes')
         delete(figHandle);
         delete(vTimer);
         clear saveName isPlaying tCur tStart tStop tSync im V vTimer
      end
   end

   function onKeyPress(src,evt)
      %%ONKEYPRESS   Do these functions on figure key press
      switch evt.Key
         case {'a','leftarrow'} % Move backwards
            setVidTime(V.CurrentTime - (2/V.FrameRate));
            updateFrame();
         case {'d','rightarrow'} % Move forwards
            updateFrame();
         case {'w','uparrow'}
            addRemoveStart();
         case {'x','downarrow'}
            addRemoveStop();
         case 's'
            if ismember(evt.Modifier,{'alt','control'})
               saveScoring();
            end
         case 'q'
            setSync();
         case 'escape'
            exitScoring(src);
      end
   end

   function onKeyRelease(~,evt)
      %%ONKEYRELEASE    Do these functions on figure key release
      switch evt.Key
         case 'space' % Play/pause
            if isPlaying
               stop(vTimer);
            else
               start(vTimer);
            end
      end
   end

end