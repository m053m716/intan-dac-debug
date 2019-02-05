function fig = plotFSMroc(roc)
%% PLOTFSMROC   Plot FSM receiver operating characteristic (ROC)
%
%  fig = PLOTFSMROC(roc);
%
%  --------
%   INPUTS
%  --------
%    roc       :     Struct with fields:
%                    'tp', 'fp', 'tn', 'fn', with sub-fields:
%                    'n', 'tot'
%
%  --------
%   OUTPUT
%  --------
%    fig       :     Handle to figure containing ROC
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%% ITERATE ON ROC IF CELL
if iscell(roc)
   fig = cell(size(roc));
   for ii = 1:numel(roc)
      fig{ii} = plotFSMroc(roc{ii});
   end
   return;
end

%% 


end