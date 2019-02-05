function [roc,y,t] = getFSMperformance(name,fs)
%% GETFSMPERFORMANCE    Characterize ROC for FSM detection performance
%
%  roc = GETFSMPERFORMANCE(name,fs);
%  [roc,y,t] = GETFSMPERFORMANCE(name,fs);
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

%% DEFAULTS
W_LEN = 15;
TOL = W_LEN;       % Tolerance (samples one direction or another)

%% USE RECURSION IF CELL INPUT
if iscell(name)
   roc = cell(size(name));
   y = cell(size(name));
   t = cell(size(name));
   for ii = 1:numel(name)
      [roc{ii},y{ii},t{ii}] = getFSMperformance(name{ii},fs);
   end
   return;
end


%% LOAD DATA
in_dir = strsplit(pwd,filesep);
in_dir = strjoin(in_dir(1:(end-1)),filesep);
in_dir = fullfile(in_dir,'data');



in = load(fullfile(in_dir,[name '_DIG_fsm-complete.mat']));
fsm.complete = in.data;
in = load(fullfile(in_dir,[name '_DIG_fsm-active.mat']));
fsm.active = in.data;

spk = load(fullfile(in_dir,[name '_ptrain_P1_Ch_004.mat']));
sorting = load(fullfile(in_dir,[name '_sort_P1_Ch_004.mat']));

%% GET SPIKE TIMES ACCORDING TO FSM
idx_online = find(fsm.complete) - W_LEN;
idx_reject = find(getFSMrejectIndices(fsm.active,fsm.complete,W_LEN));

%% GET SPIKE TIMES ACCORDING TO SORT
idx_offline = find(spk.peak_train);

clu = sorting.class;

c = getClasses(clu);

roc = struct('tp',cell(numel(c),1),...
   'fp',cell(numel(c),1),...
   'tn',cell(numel(c),1),...
   'fn',cell(numel(c),1));


i = 0;
p_on = cell(numel(c),1);
p_off = cell(numel(c),1);
n_on = cell(size(p_on));
n_off = cell(size(p_off));

y = cell(numel(c),1);
t = cell(numel(c),1);

for iC = c
   i = i + 1;
   idx = reshape(idx_offline(clu==iC),sum(clu==iC),1);
   p_on{i} = nan(numel(idx_online),1);
   n_on{i} = nan(numel(idx_reject),1);
   p_off{i} = nan(size(idx));
   n_off{i} = nan(size(idx));
   
   
   for ii = 1:numel(idx)
      p_off{iC}(ii) = min(abs(idx_online - idx(ii)));
      n_off{iC}(ii) = min(abs(idx_reject - idx(ii)));
   end
   
   for ii = 1:numel(idx_online)
      p_on{iC}(ii) = min(abs(idx - idx_online(ii)));
      
   end
   
   for ii = 1:numel(idx_reject)
      n_on{iC}(ii) = min(abs(idx - idx_reject(ii)));
   end
   
   
   roc(i).tp.n = sum(p_off{iC} <= TOL);  % true positive
   roc(i).tp.tot = numel(p_off{iC});
   
   roc(i).fp.n = sum(p_on{iC} > TOL);    % false positive
   roc(i).fp.tot = numel(p_on{iC});
   
   roc(i).fn.n = sum(n_on{iC} <= TOL);   % false negative
   roc(i).fn.tot = numel(n_on{iC});
   
   roc(i).tn.n = sum(n_off{iC} > TOL);     % true negative
   roc(i).tn.tot = numel(n_off{iC});
   
   
   % Get "targets" first
   t{iC} = [ones(numel(idx),1), zeros(numel(idx),1)]; 
   t{iC} = [t{iC}; [ones(numel(p_on{iC}),1), zeros(numel(p_on{iC}),1)]];
   t{iC} = [t{iC}; [zeros(numel(n_on{iC}),1), ones(numel(n_on{iC}),1)]];
   
   % Get "observed" next
   y{iC} = [p_off{iC} <= TOL, p_off{iC} > TOL];
   y{iC} = [y{iC}; [p_on{iC} <= TOL, p_on{iC} > TOL]];
   y{iC} = [y{iC}; [n_on{iC} <= TOL, n_on{iC} > TOL]];  
   y{iC} = double(y{iC});
end

   
   


   function c = getClasses(clu)
      c = unique(clu);
      c = reshape(c,1,numel(c));
   end


end
