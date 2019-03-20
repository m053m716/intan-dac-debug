function t = getBoxTimeValues(tStart,tStop)
%% GETBOXTIMEVALUES  Get times formatted for plotting shapes

t = [tStart;tStart;tStop;tStop];
t = reshape(t,1,numel(t));

end