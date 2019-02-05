function detSamples = getSpikePeakSamples(detMask,data)
%% GETSPIKEPEAKSAMPLES  Get spike peaks as detected on DAC
%
%  detSamples = GETSPIKEPEAKSAMPLES(detMask,data);
%
%  --------
%   INPUTS
%  --------
%  detMask     :     Thresholding mask applied to data where 1 means the
%                       threshold has been crossed.
%
%    data      :     Sample data vector from DAC (scaled to uV amplitude)
%
%  --------
%   OUTPUT
%  --------
%  detSamples  :     Detected peak sample indices.
%
% By: Max Murphy  v1.0  2019-02-05  Original version (R2017a)

%% WINDOW LENGTH
W_LEN = 15;

%% NARROW DOWN CONSECUTIVE THRESHOLD CROSSINGS
detSamples = find(detMask);
i = 2;
while i <= numel(detSamples)
   rmMask = [false(1,i-1),(detSamples(i:end) - detSamples(i-1)) < W_LEN];
   if any(rmMask)
      detSamples(rmMask) = [];
   else
      i = i + 1;
   end
end

%% THEN FIND PEAKS
for ii = 1:numel(detSamples)
   tmp = data(detSamples(ii):(detSamples(ii)+W_LEN));
   [~,idx] = min(tmp);
   detSamples(ii) = detSamples(ii) + idx - 1;
end

   
end