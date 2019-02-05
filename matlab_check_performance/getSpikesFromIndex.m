function [spikes,detSamples] = getSpikesFromIndex(detSamples,data)
%% GETSPIKESFROMINDEX   Get spikes from sample indices
%
%  spikes = GETSPIKESFROMINDEX(detSamples,data);
%
%  --------
%   INPUTS
%  --------
%  detSamples  :     Detected spike peak sample indices.
%
%  data        :     Data vector for spike waveform snippets.
%
%  --------
%   OUTPUT
%  --------
%    spikes    :     Matrix of spike waveforms. Rows correspond to elements
%                       of detSamples.
%
% By: Max Murphy  v1.0  2019-02-05  Original version (R2017a)

%%
SAMPLES_PRIOR = 12;
SAMPLES_AFTER = 24;

%%
detSamples = reshape(detSamples,numel(detSamples),1);
vec = (-SAMPLES_PRIOR) : SAMPLES_AFTER;

vec = vec + detSamples;

exc = (vec < 1) | (vec > numel(data));
vec(any(exc,2),:) = [];
detSamples(any(exc,2)) = [];
spikes = data(vec);

% Make sure all are unique
[detSamples,idx] = unique(detSamples);
spikes = spikes(idx,:);

end