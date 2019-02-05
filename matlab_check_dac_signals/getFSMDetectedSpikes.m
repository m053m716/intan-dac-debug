function [spikes,idx] = getFSMDetectedSpikes(name)
%% GETFSMDETECTEDSPIKES    Get spikes detected by state machine on DAC
%
%  [spikes,idx] = GETFSMDETECTEDSPIKES(name);
%
%  --------
%   INPUTS
%  --------
%    name      :     Cell array of block names (e.g.
%                       {'R18-159_2019_02_01_1'})
%
%  --------
%   OUTPUT
%  --------
%   spikes     :     Cell array same size as name. Each element contains
%                       spike waveform snippets corresponding to samples
%                       around the detected spike index.
%
%     idx      :     Sample indices corresponding to spikes.
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%% DEFAULTS
DATA_DIR = 'data';
SAMPLES_PRIOR = 25;
SAMPLES_AFTER = 5;

%% GET INPUT DATA DIRECTORY
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,DATA_DIR);

%% USE RECURSION FOR MULTIPLE ENTRIES
if iscell(name)
   spikes = cell(size(name));
   for ii = 1:numel(name)
      spikes{ii} = getFSMDetectedSpikes(name{ii});
   end
   return;
end

%% LOAD DATA
dac = load(fullfile(in_dir,[name '_DAC.mat']));
trig = load(fullfile(in_dir,[name '_DIG_fsm-complete.mat']));

%% 
idx = find(trig.data);
idx = reshape(idx,numel(idx),1);
vec = (-SAMPLES_PRIOR) : SAMPLES_AFTER;

vec = vec + idx;

exc = (vec < 1) | (vec > numel(dac.data));
vec(any(exc,2),:) = [];
spikes = dac.data(vec) * (0.195/0.0003125); % convert to uV

idx(any(exc,2)) = [];

end
