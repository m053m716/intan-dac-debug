function chew_rms = getChewingRMSWindowed(chewData,wLen,fs)
%% GETCHEWINGRMSWINDOWED   Return RMS in sliding window over chewing data
%
%  chew_rms = GETCHEWINGRMSWINDOWED(chewData,wLen,fs);
%
%  --------
%   INPUTS
%  --------
%  chewData    :     From filtered (bandpass or highpass only) data using
%                       indices from GETCHEWINGSAMPLES.
%
%   wLen       :     Length (seconds) of sliding window
%
%    fs        :     Sample rate
%
%  --------
%   OUTPUT
%  --------
%  chew_rms    :     Chewing root mean square error in windows throughout
%                       epochs that would have chewing artifact.
%
% By: Max Murphy  v1.0  2019-02-04  Original version (R2017a)

%%
N = round(wLen * fs);
M = numel(chewData) - N + 1;

x = nan(M,N);

for iM = 1:M
   idx = (iM) : (iM + N - 1);
   x(iM,:) = chewData(idx);
end

chew_rms = rms(x,2);

end