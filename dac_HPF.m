function [DAC_register,HPF_new_state] = dac_HPF(DAC_input,fc,fs,HPF_state)
%% DAC_HPF   Software estimate of hardware single-pole state high-pass filter
%
%  [DAC_register,HPF_new_state] = dac_HPF(DAC_input,fc,fs,state_in)
%
%  Example: If neural data sampled at 30 kSamples/sec, with desired cutoff
%           frequency of 300 Hz:
%
%           out = HPF(in,300,30000);
%
%  --------
%   INPUTS
%  --------
%  DAC_input   :     Input (raw) sample data (uint16)
%
%     fc       :     Desired cutoff frequency (Hz)
%
%     fs       :     Sampling frequency (Hz)
%
%  HPF_state   :     Use this if filtering "chunks" - the value given by
%                    state_out, which is used to initialize the state filter.
%                    Otherwise, the state filter is initialized to zero.
%
%  --------
%   OUTPUT
%  --------
%  DAC_register    : High-pass filtered sample data. The filter is essentially
%                    a single-pole butterworth high-pass filter realized using
%                    a hidden "state" variable.
%
%  HPF_new_state  :     Final value of hidden "state" variable, which is useful
%                       if you are filtering data in "chunks" so that the
%                       subsequent chunk has the correct state initialization.
%
% By: Intan Technologies
% Modified by Max Murphy   06/12/2018 (Matlab R2017b)

%% DEFAULTS
FS = 30000; % Default sample rate is 20 kSamples/sec
FC = 300;   % Default cutoff frequency

%% PARSE INPUT
switch nargin
   case 1
      warning('No cutoff frequency given. Using default FC (%d Hz).',FC);
      fc = FC;
      warning('No sample rate specified. Using default FS (%d Hz).',FS);
      fs = FS;
      HPF_state = 0;
   case 2
      warning('No sample rate specified. Using default FS (%d Hz).',FS);
      fs = FS;
      HPF_state = 0;
   case 3
      HPF_state = 0;
   case 4
      disp('All inputs specified.');
   otherwise
      error('Too many inputs. Check syntax.');
end

%% COMPUTE IIR FILTER COEFFICIENT
% A = exp(-(2*pi*fc)/fs);
% B = 1 - A;

% Implement it similar to in the C++ code
b = 1.0 - exp(-2.0 * 3.1415926535897 * fc / fs); 
filterCoefficient = floor(65536.0 * b + 0.5);
if (filterCoefficient < 1)
   filterCoefficient = 1;
elseif (filterCoefficient > 65535) % If too large
   filterCoefficient = 65535;
end

HPF_coefficient = fi(2*filterCoefficient,0,18,0,'ProductWordLength',36,'SumWordLength',32,'SumMode','KeepMSB','ProductMode','KeepMSB');
% the 2* is for one left shift? sounds smart :)
     
     % word length = 18, OverflowAction=saturate but input wire [15:0] HPF_coefficient
     % then it's used in multiplier18x18 adding 0 before and after. So in
     % this case it's role is the one called b in multiplier_18x18
     
%      module multiplier_18x18 (
%      input [17 : 0] a;
%      input [17 : 0] b;
%      output [35 : 0] p;

%% SPECIFY INPUT AND OUTPUT TYPES
DAC_register = zeros(size(DAC_input),'uint16');
DAC_input = fi(DAC_input,0,16,0,'ProductWordLength',36,...
         'SumWordLength',32,'SumMode','KeepMSB');
HPF_state = fi(HPF_state,1,32,0,'ProductWordLength',36,...
         'SumWordLength',32,'SumMode','KeepMSB','ProductMode','KeepMSB'); % I put 33 because otherwise we have a problem with the sum of 2 32 bit words.
     

%% RUN FILTER
fprintf(1,'Filtering...000%%\n');
pct = 0;
N = length(DAC_input);
for curr_sample = 1:N
    DAC_input_two_comp(curr_sample) = bitset(DAC_input(curr_sample),16,bitcmp(bitget(DAC_input(curr_sample),16))); % still formally unsigned but with binary values in two's complement
    HPF_input = fi(DAC_input_two_comp(curr_sample)*4,1,18,0,'ProductWordLength',36,'SumWordLength',19,'SumMode','KeepMSB','ProductMode','KeepMSB');
    % now shift to the left of two positions. I kept it formally unsigned
    % even though it's a two's complement
    
    HPF_state_31_14 = fi(bitsliceget(HPF_state,32,15),1,18,0,'ProductWordLength',36,'SumWordLength',19,'SumMode','KeepMSB','ProductMode','KeepMSB'); % to me this must be unsigned otherwise when state=0, cmp(0)=1111 interpreted as -1 if yb was signed
    multiplier_in_before_limit = HPF_input + bitcmp(HPF_state_31_14) + 1; % multiplier_in_before_limit = HPF_input + ~HPF_state[31:14] + 1; // HPF_input - HPF_state
    
    negative_overflow = getmsb(HPF_input) & bitcmp(getmsb(HPF_state)) & bitcmp(bitget(multiplier_in_before_limit,18));
    positive_overflow = bitcmp(getmsb(HPF_input)) & getmsb(HPF_state) & bitget(multiplier_in_before_limit,18);
    
    if logical(positive_overflow)
        multiplier_in = fi(131071,1,18,0,'ProductWordLength',36,'SumWordLength',32,'SumMode','KeepMSB','ProductMode','KeepMSB'); 
        % 2^17-1 = 20000
    else
        if logical(negative_overflow)
            multiplier_in = fi(131072,1,18,0,'ProductWordLength',36,'SumWordLength',32,'SumMode','KeepMSB','ProductMode','KeepMSB'); 
            % 2^17 = 1ffff
        else
            multiplier_in = fi(multiplier_in_before_limit,1,18,0,'ProductWordLength',36,'SumWordLength',32,'SumMode','KeepMSB','ProductMode','KeepMSB');
        end
    end
    
    % Concatenate buffer zeros to make 18-bit word for multiplier
    multiplier_out = multiplier_in*HPF_coefficient; %I kept the two numbers signed
    multiplier_out_34_3=fi(bitsliceget(multiplier_out,35,4),1,32,0,'ProductWordLength',36,'SumWordLength',32,'SumMode','KeepMSB','ProductMode','KeepMSB'); %
    HPF_new_state = HPF_state + multiplier_out_34_3;
    HPF_output = bitsliceget(multiplier_in,18,3); % mult_in [17:2] %% back to 16 bits
    
    %% so far it's ok..
    DAC_register_pre = fi(bitconcat(bitcmp(getmsb(HPF_output)),bitsliceget(HPF_output,15,1)),0,16,0); % two's complement back to unsignedInt16
    DAC_register(curr_sample) = cast(DAC_register_pre,'uint16'); %% it saturates usually
    HPF_state = HPF_new_state;
    
    
    %% And update the status indicator in Command Window:
    fraction_done = floor(100 * (curr_sample / N));
    if fraction_done ~= pct
        fprintf(1,'\b\b\b\b\b%.3d%%\n',fraction_done);
        pct = fraction_done;
    end
end

end
