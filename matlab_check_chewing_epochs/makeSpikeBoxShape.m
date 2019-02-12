function S = makeSpikeBoxShape(spikeStruct,dac,col)
%% MAKESPIKEBOXSHAPE  Make struct for patches to highlight chewing box
%
%  S = MAKESPIKEBOXSHAPEE(spikeStruct);
%  S = MAKESPIKEBOXSHAPEE(spikeStruct,col);
%
% By: Max Murpy   v1.0  2019-02-11  Original version (R2017a)

%%
COL = [0.8 0.8 0.8; ...
       1.0 0.0 0.0; ...
       0.0 0.0 1.0];
BOX_START_OFFSET = 0.001;
BOX_STOP_OFFSET = 0.001;
FACE_ALPHA = 0.35;    

if nargin < 3
   col = COL;
end
    
%%


if isfield(spikeStruct,'wMax')
   tStart = spikeStruct.ts - (spikeStruct.wMax / dac.fs);
   tStop = spikeStruct.ts;
   
   t = getBoxTimeValues(reshape(tStart,1,numel(tStart)),...
      reshape(tStop,1,numel(tStop)));
   
else
   tStart = spikeStruct.ts - BOX_START_OFFSET;
   tStop = spikeStruct.ts + BOX_STOP_OFFSET;
   t = getBoxTimeValues(reshape(tStart,1,numel(tStart)),...
      reshape(tStop,1,numel(tStop)));
   
end
y = getBoxAmplitudes(round(spikeStruct.ts * dac.fs)-dac.startIdx,dac.data);

%%
v = [t.',y.'];
nVertices = size(v,1);
nBox = numel(spikeStruct.ts);

cl = spikeStruct.class;
cl = cl + (spikeStruct.sort == spikeStruct.class);

S = struct;
S.Vertices = v;
S.Faces = reshape(1:nVertices,4,nBox).';
S.FaceVertexCData = col(cl,:);
S.FaceColor = 'flat';
S.EdgeColor = 'none';
S.FaceAlpha = FACE_ALPHA;
S.LineWidth = 2;

end
