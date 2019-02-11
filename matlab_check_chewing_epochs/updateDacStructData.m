function dacStruct = updateDacStructData(dacStruct,t_start,t_stop)
%% UPDATEDACSTRUCTDATA  Update DAC struct to reflect chewing indexes

iChew = (dacStruct.t > t_start) & (dacStruct.t < t_stop);
dacStruct.t = dacStruct.t(iChew);
dacStruct.data = dacStruct.data(iChew) * (0.195/0.0003125);
dacStruct.start = t_start;
dacStruct.stop = t_stop;
dacStruct.startIdx = find(iChew,1,'first');
dacStruct.stopIdx = find(iChew,1,'last');

end