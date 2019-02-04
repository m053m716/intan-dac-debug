function sampleIndices = getChewingSamples(start,stop,fs)
%% GETCHEWINGSAMPLES    Return sample indices for chewing samples
%
%  sampleIndices = GETCHEWINGSAMPLES(start,stop);
%
%  --------
%   INPUTS
%  --------
%    start     :     Chewing epoch start times (sec; REFINECHEWINGEPOCHS)
%
%    stop      :     Chewing epoch stop times (sec; REFINECHEWINGEPOCHS)
%
%     fs       :     Sample rate (def: 30000);
%
%  --------
%   OUTPUT
%  --------
%  sampleIndices :   Sample indexing vector of which samples are within the
%                      chewing epochs.
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%% PARSE INPUT

if nargin < 2
   error('Not enough inputs.');
end

N = numel(start);
if N ~= numel(stop)
   error('START (%d) and STOP (%d) must have same number of elements.',...
      N,numel(stop));   
end

if nargin < 3
   fs = 30000;
end

%%
start = start * fs;
stop = stop * fs;

sampleIndices = [];
for ii = 1:N
   sampleIndices = [sampleIndices, round(start(ii) : stop(ii))]; %#ok<AGROW>
end
sampleIndices = sort(unique(sampleIndices),'ascend');


end