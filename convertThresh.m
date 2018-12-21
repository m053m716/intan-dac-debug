function thresh_out = convertThresh(thresh_in,varargin)
%% CONVERTTHRESH   Convert to threshold as seen by FPGA
%
%  thresh_out = CONVERTTHRESH(thresh_in);
%  thresh_out = CONVERTTHRESH(thresh_in,'NAME',value,...);
%
%  --------
%   INPUTS
%  --------
%  thresh_in      :     Input threshold (microvolts)
%
%  varargin       :     (Optional) 'NAME', value input argument pairs.
%                       -> 'SCALE' (def: 1e-6) | Conversion scale
%
%                       -> 'Q' (def: 32768) | Quantization offset
%
%                       -> 'D' (def: 0.195) | Factor for scaling dynamic
%                                               range to recover Voltage
%                                               values
%  --------
%   OUTPUT
%  --------
%  thresh_out     :     Approximated threshold as seen by DAC comparator
%                          (quantized bit values; uint16)
%
% By: Max Murphy  v1.0  12/17/2018  Original version (R2017a)

%% DEFAULTS
N = 0;         % Gain tick
SCALE = 1e-6;  % Scale to correct prefix
Q = 32768;     % Quantization offset
D = 0.195;     % uV per bit in ADC
K = 312.5;     % uV per bit in DAC

%% PARSE VARARGIN
for iV = 1:2:numel(varargin)
   eval([upper(varargin{iV}) '=varargin{iV+1};']);
end

% %% CHECK THRESHOLD POLARITY
% k = (K/D) * SCALE * 2^N;

%% RETURN THERSHOLD
thresh_out = uint16(round(thresh_in/D) + Q);
thresh_out = [thresh_out, thresh_out];

end