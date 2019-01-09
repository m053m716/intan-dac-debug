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

HPF_coefficient = fi(2*filterCoefficient,1,18,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',32); %the 2* is for one left shift? sounds smart :)
     
     % word length = 18, OverflowAction=saturate but input wire [15:0] HPF_coefficient
     % then it's used in multiplier18x18 adding 0 before and after. So in
     % this case it's role is the one called b in multiplier_18x18
     
%      module multiplier_18x18 (
%      input [17 : 0] a;
%      input [17 : 0] b;
%      output [35 : 0] p;

%% SPECIFY INPUT AND OUTPUT TYPES
DAC_register = zeros(size(DAC_input),'uint16');
DAC_input = fi(DAC_input,0,16,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',32);
HPF_state = fi(HPF_state,0,32,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',33); % I put 33 because otherwise we have a problem with the sum of 2 32 bit words.
     
%% where are these guys ?
% wire [15:0]    DAC_input_twos_comp, DAC_input_offset, DAC_register_pre, subtract_result, add_result;
% reg  [15:0]    DAC_input_suppressed, DAC_input_scaled;
% wire [15:0]		pre_ref_input_twos_comp, software_reference_twos_comp, input_minus_ref;
% wire [16:0]		input_minus_ref_before_limit;
% wire				negative_overflow_ref, positive_overflow_ref;

%% RUN FILTER
fprintf(1,'Filtering...000%%\n');
pct = 0;
N = length(DAC_input);
for i = 1:N
   HPF_input = preScaleForMultiply(DAC_input(i));
   multiplier_in_before_limit = twosCompSubtract(HPF_input,HPF_state); % must be 19 bits (wire [18:0] 	multiplier_in_before_limit;). Now it's 20!
   [negative_overflow,positive_overflow] = checkOverflow(HPF_input,HPF_state,multiplier_in_before_limit);
   if logical(positive_overflow)
      multiplier_in = fi(131071,1,18,0,...
         'MaxProductWordLength',36,...
         'MaxSumWordLength',32); % 2^17-1 = 20000
   else
      if logical(negative_overflow)
         multiplier_in = fi(131072,1,18,0,...
            'MaxProductWordLength',36,...
            'MaxSumWordLength',32); %% 2^17 = 1ffff
      else
         multiplier_in = fi(multiplier_in_before_limit,1,18,0,...
            'MaxProductWordLength',36,...
            'MaxSumWordLength',32);
      end
   end
   
   % Concatenate buffer zeros to make 18-bit word for multiplier
   multiplier_out = multiply18x18_36(multiplier_in,HPF_coefficient); %I kept the two numbers signed
   multiplier_out_34_3=fi(bitsliceget(multiplier_out,35,4),0,32,0,...
         'MaxProductWordLength',36,...
         'MaxSumWordLength',33); % I put 33 because otherwise we have a problem with the sum of 2 32-bit words.
   HPF_new_state = HPF_state + multiplier_out_34_3; %word length is 33 now
   HPF_output = bitsliceget(multiplier_in,18,3); % mult_in [17:2] %% back to 16 bits
   
   %% so far it's ok..
   DAC_register_pre = fi(bitconcat(bitcmp(getmsb(HPF_output)),bitsliceget(HPF_output,15,1)),0,16,0); % two's complement back to unsignedInt16
   DAC_register(i) = cast(DAC_register_pre,'uint16');
   HPF_state = bitsliceget(HPF_new_state,32,1); % ignore first bit (overflow) because of the 33 bit sum
   
%% 	// Next, scale the input by a factor of 2^gain by left shifting, but preserving the
%% 	// sign and saturating if the scaling exceeds the range of a 16-bit signed number.   


   % And update the status indicator in Command Window:
   fraction_done = floor(100 * (i / N));
   if fraction_done ~= pct
      fprintf(1,'\b\b\b\b\b%.3d%%\n',fraction_done);
      pct = fraction_done;
   end
end

%% SUB-FUNCTIONS TO STAY ORGANIZED
   function y = preScaleForMultiply(x)
      x = bitset(x,16,bitcmp(bitget(x,16))); % still formally unsigned but with binary values in two's complement
%       y = fi(x,1,18,0,'MaxProductWordLength',36,...
%           'MaxSumWordLength',32,...
%           'SumMode','KeepMSB'); % this adds two zeros on the left going from 16 bits to 18 and now it's signed
       % this is wrong because you want to add two zeros on the right!!! {~DAC_input[15], DAC_input[14:0], 2'b00};
       y = fi(bin2dec([x.bin '00']),0,18,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',32);
     % now shift to the left of two positions. I kept it formally unsigned
     % even though it's a two's complement
   end

    % ok
   function z = twosCompSubtract(x,y)
      xb = fi(x,0,18,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',20); % i don't know but I put as unsigned
      yb = fi(bitsliceget(y,32,15),0,18,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',20); % to me this must be unsigned otherwise when state=0, cmp(0)=1111 interpreted as -1 if yb was signed
      z = xb + bitcmp(yb) + 1; % multiplier_in_before_limit = HPF_input + ~HPF_state[31:14] + 1; // HPF_input - HPF_state
   end
    % ok 'cause it's working bit per bit
   function [neg_ov,pos_ov] = checkOverflow(in,state,prelimit)
%       neg_ov = getmsb(in) & bitcmp(getmsb(state)) & bitcmp(getmsb(prelimit)); %getmsb of prelimit is not correct for sure:
      % in verilog: ~multiplier_in_before_limit[17] but it's a 19 bit wire
      % so it's not the MSB!!
%       pos_ov = bitcmp(getmsb(in)) & getmsb(state) & getmsb(prelimit);
      
      %% get bit 18 and not MSB from prelimit
      neg_ov = getmsb(in) & bitcmp(getmsb(state)) & bitcmp(bitget(prelimit,18)); 
      pos_ov = bitcmp(getmsb(in)) & getmsb(state) & bitget(prelimit,18);
   end
    
   % not sure about this! we don't know what's going on in the multiplier_18x18 
   function out = multiply18x18_36(in,coeff)
      out =  in*coeff;
   end


    
end
