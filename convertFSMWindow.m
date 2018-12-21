function win_out = convertFSMWindow(win_in)
%% CONVERTFSMWINDOW  Short code to represent include/exclude window bounds

win_out = nan(size(win_in));
for ii = 1:size(win_in,1)
   win_out(ii,:) = [win_in(ii,1) win_in(ii,2)-1];
end

end