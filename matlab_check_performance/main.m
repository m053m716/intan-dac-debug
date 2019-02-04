%% MAIN  - Script for organizing code to analyze performance of FSM

%% CHARACTERIZE DETECTION ON BOTH RECORDINGS
roc = cell(size(name));
for ii = 1:2
   roc{ii} = getFSMperformance(name{ii});
end