function readOutFi(fi_in,t1,t2)
%% READOUTFI    Function for debugging fixed value / finite precision math
%
%  READOUTFI(fi_in);
%  READOUTFI(fi_in,t1);
%  READOUTFI(fi_in,t1,t2);
%
% By: Max Murphy  v1.0  12/21/2018  Original version (R2017a)

%% PARSE INPUT
if nargin < 1
   t1 = 1; % seconds to pause for first step
end

if nargin < 2
   t2 = 5; % seconds to pause for second step
end


%% SIMPLY READS OUT CONTENTS OF FI OBJECT
clc;
disp(inputname(1));
disp('---------------------');
disp(fi_in);
pause(t1);
disp(bin(fi_in));
pause(t2);


end