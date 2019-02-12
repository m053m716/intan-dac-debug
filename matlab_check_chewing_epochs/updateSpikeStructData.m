function spikeStruct = updateSpikeStructData(spikeStruct,dac)
%% UPDATESPIKESTRUCTDATA   Update spike data structure to reflect chew epoc
%

spikeStruct.maxVal = max(dac.data);
spikeStruct.minVal = min(dac.data);

idx = (spikeStruct.ts > min(dac.t)) & (spikeStruct.ts < max(dac.t));
spikeStruct.ts = reshape(spikeStruct.ts(idx),1,sum(idx));
spikeStruct.sort = reshape(spikeStruct.sort(idx),1,sum(idx));
spikeStruct.sort = min(spikeStruct.sort,ones(size(spikeStruct.sort))*2);
spikeStruct.class = ones(size(spikeStruct.sort)) * 2; % They are all counted as spike

end