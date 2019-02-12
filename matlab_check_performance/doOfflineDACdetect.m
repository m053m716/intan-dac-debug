function doOfflineDACdetect(name,fsm_window_state)
%% DOOFFLINEDACDETECT   Do simple threshold comparison on DAC
%
%  DOOFFLINEDACDETECT(name,fsm_window_state)
%
%  --------
%   INPUTS
%  --------
%    name      :     Name of recording block (or cell array)
%
%  --------
%   OUTPUT
%  --------
%  Makes a block in this directory where offline sorting can be done on the
%  threshold detection results from DAC.
%
% By: Max Murphy  v1.0  2019-02-05  Original version (R2017a)
%                 v1.1  2019-02-08  Modify how detection is performed (uses
%                                   fsm_window_state now)

%% DEFAULTS
COUNT_ARTIFACT = true;

%% PARSE INPUT
if iscell(name)
   for ii = 1:numel(name)
      doOfflineDACdetect(name{ii},fsm_window_state{ii});
   end
   return;
end

%% LOAD DATA
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');

dac = load(fullfile(in_dir,[name '_DAC.mat']));
data = dac.data * (0.195/0.0003125);

%% DO DETECTION ON THIS CHANNEL
[peak_train,class] = getSpikePeakSamples(fsm_window_state,COUNT_ARTIFACT);
[spikes,iRemove] = getSpikesFromIndex(peak_train,data);
peak_train(iRemove) = [];
class(iRemove) = [];

features = getSpikeFeatures(spikes);
pars = struct;
pars.FS = 30000;
pars.FEAT_NAMES = {'PC-1','PC-2','PC-3'}; %#ok<STRNU>

%% MAKE OUTPUT
block = fullfile(pwd,name);
if exist(block,'dir')==0
   mkdir(block);
end

spkdir = fullfile(block,[name '_wav-sneo_CAR_Spikes']);
if exist(spkdir,'dir')==0
   mkdir(spkdir);
end
save(fullfile(spkdir,[name '_ptrain_P0_Ch_000.mat']),...
   'pars','spikes','features','peak_train','-v7.3');

cludir = fullfile(block,[name '_wav-sneo_SPC_CAR_Clusters']);
if exist(cludir,'dir')==0
   mkdir(cludir);
end
save(fullfile(cludir,[name '_clus_P0_Ch_000.mat']),...
   'pars','class','-v7.3');


end
