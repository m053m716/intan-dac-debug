%% DEBUGBENCH  Benchtop for debugging fimath problems
clc;

%% SEQUENTIALLY READ OUT VARIABLES OF INTEREST
if exist('HPF_input','var')~=0
   readOutFi(HPF_input,1,2.5);
end

if exist('HPF_state','var')~=0
   readOutFi(HPF_state,1,2.5);
end

if exist('multiplier_in_before_limit','var')~=0
   readOutFi(multiplier_in_before_limit,1,2.5);
end

clc;
if (exist('negative_overflow','var')~=0) && (exist('positive_overflow','var')~=0)
   if logical(negative_overflow)
      disp('Negative overflow.');
      pause(1);
   elseif logical(positive_overflow)
      disp('Positive overflow.');
      pause(1);
   end
end

if exist('multiplier_out','var')~=0
   readOutFi(multiplier_out,1,2.5);
end

if exist('HPF_new_state','var')~=0
   readOutFi(HPF_new_state,1,2.5);
end

if exist('HPF_output','var')~=0
   readOutFi(HPF_output,1,2.5);
end

if exist('DAC_register_pre','var')~=0
   readOutFi(DAC_register_pre,1,2.5);
end
clc;