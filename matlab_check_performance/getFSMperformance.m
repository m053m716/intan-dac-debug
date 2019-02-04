function roc = getFSMperformance(name,fs)
%% GETFSMPERFORMANCE    Characterize ROC for FSM detection performance
%
%  roc = GETFSMPERFORMANCE(name);
%
%  --------
%   INPUTS
%  --------
%    name      :     Name of recording block (e.g. 'R18-159_2019_02_01_2')
%
%  --------
%   OUTPUT
%  --------
%    roc       :     Struct containing roc data.
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)



%% LOAD DATA
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');

load(fullfile(in_dir,[name '_DIG_fsm-complete.mat']));
fsm.complete = data;
load(fullfile(in_dir,[name '_DIG_fsm-active.mat']));
fsm.active = data;

spk = load(fullfile(in_dir,[name '_ptrain_P1_Ch_004.mat']));
sorting = load(fullfile(in_dir,[name '_sort_P1_Ch_004.mat']));
load(fullfile(in_dir,[name '_Filt_P1_Ch_004.mat']));

%% GET SPIKE TIMES ACCORDING TO FSM
idx = find(fsm.complete);
idx_online = nan(size(idx));

% Must make it align as it would for offline detection:
for iIdx = 1:numel(idx)
   vec = (idx(iIdx)-17):idx(iIdx);
   [~,tmp] = min(data(vec));
   idx_online(iIdx) = vec(tmp(1));
end

ts = idx_online / fs;

%% GET SPIKE TIMES ACCORDING TO SORT
idx_offline = find(spk.peak_train);

clu = sorting.class;

c = getClasses(clu);

roc = struct('tp',cell(numel(c),1),...
   'fp',cell(numel(c),1),...
   'tn',cell(numel(c),1),...
   'fn',cell(numel(c),1));

for iC = c
   idx = idx_offline(clu==iC);
   
   d{iC} = nan(size(idx));
   for ii = 1:numel(idx)
      d{iC}(ii) = min(abs(idx_online - idx(ii)));
   end
   
end



   function c = getClasses(clu)
      c = unique(clu);
      c = c(c > 1);
      c = reshape(c,1,numel(c));
   end


end
