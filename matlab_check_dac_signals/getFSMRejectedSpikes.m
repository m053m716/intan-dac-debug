function rejects = getFSMRejectedSpikes(name)
%% GETFSMREJECTEDSPIKES    Get spikes rejected by state machine on DAC
%
%  rejects = GETFSMREJECTEDSPIKES(name);
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
%  rejects     :     Cell array same size as name. Each element contains
%                       spike waveform snippets corresponding to samples
%                       around waveforms that started the FSM but did not
%                       meet inclusion criteria for its duration.
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%% DEFAULTS
DATA_DIR = 'data';
SAMPLES_PRIOR = 10;
SAMPLES_AFTER = 20;
WLEN = 15;
DEBUG = false;

%% GET DATA DIRECTORY
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');

%% USE RECURSION FOR MULTIPLE ENTRIES
if iscell(name)
   rejects = cell(size(name));
   for ii = 1:numel(name)
      rejects{ii} = getFSMRejectedSpikes(name{ii});
   end
   return;
end

%% LOAD DATA
dac = load(fullfile(in_dir,[name '_ANA_ANALOG-OUT-1.mat']));
act = load(fullfile(in_dir,[name '_DIG_fsm-active.mat']));
trig = load(fullfile(in_dir,[name '_DIG_fsm-complete.mat']));

%% 
idx = getFSMrejectIndices(act.data,trig.data,WLEN,DEBUG);

vec = (-SAMPLES_PRIOR) : SAMPLES_AFTER;
vec = vec + idx;

exc = (vec < 1) | (vec > numel(dac.data));
vec(any(exc,2),:) = [];
rejects = dac.data(vec) * (0.195/0.0003125); % convert to uV



end