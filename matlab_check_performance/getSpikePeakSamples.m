function [peak_train,class] = getSpikePeakSamples(fsm_window_state,countArt)
%% GETSPIKEPEAKSAMPLES  Get spike peaks as detected on DAC
%
%  [peak_train,class] = GETSPIKEPEAKSAMPLES(fsm_window_state);
%
%  --------
%   INPUTS
%  --------
%  fsm_window_state  :  State vector (0 1 2) that is duration of data.
%
%  countArt          :  (Optional) default is true; if false only look at
%                          spikes detected
%
%  --------
%   OUTPUT
%  --------
%  peak_train     :     Detected peak sample indices.
%
%    class        :     Class for detected spikes
%
% By: Max Murphy  v1.0  2019-02-05  Original version (R2017a)

%% PARSE INPUT
if nargin < 2
   countArt = true;
end

%% GET MAX WINDOW LENGTH
idx = find(fsm_window_state == 2,1,'first');
counter = 0;
while (fsm_window_state(idx - counter) > 0)
   counter = counter + 1;
end
wlen = counter;

%% GET PEAKS DEPENDING ON WINDOW STATE
peak_train = find(fsm_window_state > 0);
iStop = [(diff(peak_train) > 1),false];
peak_train = peak_train(iStop);
class = fsm_window_state(peak_train);  

if (logical(countArt))
   for i = 1:numel(peak_train)
      if class(i)==1 % If rejected
         if peak_train(i) > wlen
            idx = peak_train(i);
            counter = 0;
            iCount = true;
            while (idx >= (peak_train(i) - wlen))
               iCount = iCount && (fsm_window_state(idx) > 0);
               counter = counter + iCount;            
               idx = idx - 1;
            end
            % Match up to where it would have been if accepted
            peak_train(i) = peak_train(i) + (wlen - counter) + 1;
         else
            peak_train(i) = nan;
            class(i) = nan;
         end
      end
   end
else
   idx = class == 2;
   peak_train = peak_train(idx);
   class = class(idx);
end
   
peak_train = peak_train(~isnan(peak_train));
class = class(~isnan(class));

[peak_train,idx] = unique(peak_train);
class = class(idx);

end