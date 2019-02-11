function spikeStruct = updateSpikeStructData(spikeStruct,dac)
%% UPDATESPIKESTRUCTDATA   Update spike data structure to reflect chew epoc
%

spikeStruct.maxVal = max(dac.data);
spikeStruct.minVal = min(dac.data);

idx = (spikeStruct.ts > min(dac.t)) & (spikeStruct.ts < max(dac.t));
spikeStruct.ts = reshape(spikeStruct.ts(idx),1,sum(idx));
spikeStruct.class = reshape(spikeStruct.class(idx),1,sum(idx));
spikeStruct.class = min(spikeStruct.class,ones(size(spikeStruct.class))*2);
spikeStruct.sort = reshape(spikeStruct.sort(idx),1,sum(idx));

end