function [threshSpk,fsmSpk] = getComparisonPerformance(name,fs,sortName)
%% GETCOMPARISONPERFORMANCE  Characterize ROC for FSM detection performance
%
%  [threshSpk,fsmSpk] = GETCOMPARISONPERFORMANCE(name,fs);
%
%  --------
%   INPUTS
%  --------
%    name      :     Name of recording block (e.g. 'R18-159_2019_02_01_2')
%
%     fs       :     Sample rate (Hz)
%
%  sortName    :     Name of sort
%
%  --------
%   OUTPUT
%  --------
%  threshSpk   :     Struct with data about threshold crossing spikes
%
%   fsmSpk     :     Struct with data about state machine detector spikes
%
% By: Max Murphy  v1.0  2019-02-11  Original version (R2017a)

%% DEFAULTS
if nargin < 3
   sortName = 'Sorted';
end

%% USE RECURSION IF CELL INPUT
if iscell(name)
   threshSpk = cell(size(name));
   fsmSpk = cell(size(name));
   for ii = 1:numel(name)
      [threshSpk,fsmSpk] = getComparisonPerformance(name{ii},fs,sortName);
   end
   return;
end

%% LOAD THRESHOLD SPIKE DATA
threshSpk = struct;
load(fullfile(pwd,'thresh-spikes',name,[name '_wav-sneo_CAR_Spikes'],...
   [name '_ptrain_P0_Ch_000.mat']),'peak_train');
load(fullfile(pwd,'thresh-spikes',name,[name '_wav-sneo_SPC_CAR_' sortName],...
   [name '_sort_P0_Ch_000.mat']),'class');
threshSpk.idx = peak_train;
threshSpk.ts = threshSpk.idx / fs;
threshSpk.target = abs(class - 3); % switch so spike is "1" (for matrix)
threshSpk.output = ones(size(class)); % They are all spikes

%% GET SPIKE TIMES ACCORDING TO FSM
fsmSpk = struct;
load(fullfile(pwd,'window-spikes-only',name,[name '_wav-sneo_CAR_Spikes'],...
   [name '_ptrain_P0_Ch_000.mat']),'peak_train');
load(fullfile(pwd,'window-spikes-only',name,[name '_wav-sneo_SPC_CAR_' sortName],...
   [name '_sort_P0_Ch_000.mat']),'class');
fsmSpk.idx = peak_train;
fsmSpk.ts = fsmSpk.idx / fs;
fsmSpk.target = abs(class - 3); % switch so spike is "1" (for matrix)
fsmSpk.output = ones(size(class));

%% PARSE ALL OBSERVED "EVENTS" AND FORMAT FOR OUTPUT
threshSpk.confusion = makeDummyArray(threshSpk.output,threshSpk.target);
fsmSpk.confusion = makeDummyArray(fsmSpk.output,fsmSpk.target);


%% FUNCTION TO TRANSLATE ARRAY
   function confusionStruct = makeDummyArray(outputClass,targetClass)
      % Here, code is: 1 --> spike; 2 --> artifact
      n = max(numel(unique(outputClass)),numel(unique(targetClass)));
      
      outputs = zeros(n,numel(outputClass));
      targets = zeros(n,numel(targetClass));
      
      for i = 1:n
         idxOut = outputClass==i;
         idxTar = targetClass==i;
         
         outputs(i,idxOut) = ones(1,sum(idxOut));
         targets(i,idxTar) = ones(1,sum(idxTar));
      end
      confusionStruct.outputs = outputs;
      confusionStruct.targets = targets;
   end
  

end
