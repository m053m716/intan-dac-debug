function y = getBoxAmplitudes(idx,data,offset)
%%  GETBOXAMPLITUDES    Get y-values for boxes to superimpose

%% OFFSET TO CHECK
OFFSET = 30;
if nargin < 3
   offset = OFFSET;
end

%%
y = nan(1,numel(idx) * 4);
for ii = 1:numel(idx)
   vec = ((ii - 1)*4 + 1):(ii * 4);
   iStart = max(idx(ii) - offset,1);
   iStop = min(numel(data),idx(ii) + offset);
   maxVal = max(data(iStart:iStop));
   minVal = min(data(iStart:iStop));
   y(vec) = [maxVal,minVal,minVal,maxVal];
end


end
