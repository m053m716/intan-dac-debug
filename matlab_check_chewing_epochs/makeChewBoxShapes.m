function S = makeChewBoxShapes(t,y)
%% MAKECHEWBOXSHAPES  Make struct for patches to highlight chewing box
%
%  S = MAKECHEWBOXSHAPES(t,y);
%
%
%%
v = [t.',y.'];
nVertices = size(v,1);
nBox = nVertices / 4;

S = struct;
S.Vertices = v;
S.Faces = reshape(1:nVertices,4,nBox).';
S.FaceVertexCData = zeros(nBox,1);
S.FaceColor = 'none';
S.EdgeColor = 'red';
S.LineWidth = 2;


end