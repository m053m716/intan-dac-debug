function idx = getFSMrejectIndices(fsmActive,fsmComplete,wlen,DEBUG)
%% GETFSMREJECTINDICES  Get indices of rejected FSM samples
%
%  idx = GETFSMREJECTINDICES(fsmActive,fsmComplete,wlen);
%  idx = GETFSMREJECTINDICES(fsmActive,fsmComplete,wlen,DEBUG);
%
%  --------
%   INPUTS
%  --------
%  fsmActive      :     Digital output representing times when FSM is in
%                          ACTIVE state (DIG-14)
%
%  fsmComplete    :     Digital output representing pulses when FSM is
%                          completed (DIG-13)
%
%    wlen         :     Max stop sample for window FSM
%
%   DEBUG         :     (Optional) boolean. Default is false. If true, make
%                          a DEBUG figure showing how the active samples
%                          are filtered out to find the FSM "entrances"
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%%
if nargin < 4
   DEBUG = false;
end

%%
idx = find(fsmActive);
idx = reshape(idx,numel(idx),1);
tmp = idx(100:200); % for debug

idx = idx([true;diff(idx) > 1]); % Want points of "entry"
idx(fsmComplete(idx + wlen)>0) = []; 

%% DEBUGGER
if (DEBUG)
   figure('Name','Debug ACTIVE trigger',...
      'Color','w',...
      'Units','Normalized',...
      'Position',[0.1 0.1 0.8 0.8]);
   subplot(3,1,1);
   stem(tmp,ones(size(tmp)),'LineWidth',2,'Color','r');
   title('All ACTIVE samples',...
      'FontName','Arial','Color','r','FontSize',16);
   tmp = tmp([true; diff(tmp) > 1]);
   subplot(3,1,2);
   stem(tmp,ones(size(tmp)),'LineWidth',2,'Color','k');
   title('Keep only START of FSM',...
      'FontName','Arial','Color','k','FontSize',16);
   tmp(fsmComplete(tmp + wlen)>0) = [];
   subplot(3,1,3);
   stem(tmp,ones(size(tmp)),'LineWidth',2,'Color','b');
   title('Remove GOOD spikes',...
      'FontName','Arial','Color','b','FontSize',16);
   xlabel('Sample Index');
end


end