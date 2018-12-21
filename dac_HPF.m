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
FS = 20000; % Default sample rate is 20 kSamples/sec
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
         'MaxSumWordLength',32,...
         'SumMode','KeepMSB');

%% SPECIFY INPUT AND OUTPUT TYPES
DAC_register = zeros(size(DAC_input),'uint16');
DAC_input = fi(DAC_input,0,16,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',32,...
         'SumMode','KeepMSB');
HPF_state = fi(HPF_state,1,32,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',32,...
         'SumMode','KeepMSB');

%% RUN FILTER
fprintf(1,'Filtering...000%%\n');
pct = 0;
N = length(DAC_input);
for i = 1:N
   HPF_input = preScaleForMultiply(DAC_input(i));
   multiplier_in_before_limit = twosCompSubtract(HPF_input,HPF_state);
   [negative_overflow,positive_overflow] = checkOverflow(HPF_input,HPF_state,multiplier_in_before_limit);
   if logical(positive_overflow)
      multiplier_in = fi(131071,1,18,0,...
         'MaxProductWordLength',36,...
         'MaxSumWordLength',32,...
         'SumMode','KeepMSB'); % 2^17-1
   else
      if logical(negative_overflow)
         multiplier_in = fi(131072,1,18,0,...
            'MaxProductWordLength',36,...
            'MaxSumWordLength',32,...
            'SumMode','KeepMSB');
      else
         multiplier_in = fi(multiplier_in_before_limit,1,18,0,...
            'MaxProductWordLength',36,...
            'MaxSumWordLength',32,...
            'SumMode','KeepMSB');
      end
   end
   
   % Concatenate buffer zeros to make 18-bit word for multiplier
   multiplier_out = multiply18x18_36(multiplier_in,HPF_coefficient);
   
   HPF_new_state = HPF_state + ...
      fi(bitsliceget(multiplier_out,35,4),1,32,0,...
         'MaxProductWordLength',36,...
         'MaxSumWordLength',32,...
         'SumMode','KeepMSB');
   HPF_output = bitsliceget(multiplier_in,18,3); % mult_in [17:2]
   DAC_register_pre = fi(bitconcat(bitcmp(getmsb(HPF_output)),...
      bitsliceget(HPF_output,15,1)),0,16,0);
   DAC_register(i) = cast(DAC_register_pre,'uint16');
   HPF_state = HPF_new_state;
   
   % And update the status indicator in Command Window:
   fraction_done = floor(100 * (i / N));
   if fraction_done ~= pct
      fprintf(1,'\b\b\b\b\b%.3d%%\n',fraction_done);
      pct = fraction_done;
   end
end

%% SUB-FUNCTIONS TO STAY ORGANIZED
   function y = preScaleForMultiply(x)
      x = bitset(x,16,bitcmp(bitget(x,16)));
      y = fi(x,1,18,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',32,...
         'SumMode','KeepMSB');
   end

   function z = twosCompSubtract(x,y)
      xb = fi(x,1,18,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',32,...
         'SumMode','KeepMSB');
      yb = fi(bitsliceget(y,32,15),1,18,0,'MaxProductWordLength',36,...
         'MaxSumWordLength',32,...
         'SumMode','KeepMSB');
      z = xb + bitcmp(yb) + 1;
   end

   function [neg_ov,pos_ov] = checkOverflow(in,state,prelimit)
      neg_ov = getmsb(in) & bitcmp(getmsb(state)) & bitcmp(getmsb(prelimit));
      pos_ov = bitcmp(getmsb(in)) & getmsb(state) & getmsb(prelimit);
   end

   function out = multiply18x18_36(in,coeff)
      out =  in*coeff;
   end


end
