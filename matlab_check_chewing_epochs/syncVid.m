function vidOffset = syncVid(vidScoreFile,vidSyncFile)
%% SYNCVID   Synchronize vid based on scoring and digital record
%
%  vidOffset = SYNCVID(vidScoreFile,vidSyncFile);
%
%  --------
%   INPUTS
%  --------
%  vidScoreFile   :     Scoring file with chewing epochs etc. from
%                          GETCHEWINGEPOCHS
%
%  vidSyncFile    :     _sync.mat digital record of when blue LED button
%                          was pushed during Intan recording.
%
%  --------
%   OUTPUT
%  --------
%  vidOffset      :     Time (seconds) of offset of video relative to
%                          digital recording. Positive value = video
%                          started after Intan recording started.
%
% By: Max Murphy  v1.0  2019/02/02  Original version (R2017a)

%% LOAD DATA
load(vidScoreFile,'syncFrame'); % This is TIME of sync frame (sec)
load(vidSyncFile,'data','fs');

%% GET OFFSET
idx = find(data,1,'first');
t = idx/fs; % This is when LED is HIGH for first time in INTAN record (sec)

% This is the TIME (sec) of video start, relative to start of INTAN record:
vidOffset = t - syncFrame;

end