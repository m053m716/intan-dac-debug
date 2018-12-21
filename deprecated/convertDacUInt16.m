function [data_out,data_uV] = convertDacUInt16(data_in,varargin)
%% CONVERTDACUINT16   Convert to bit values as seen on the FPGA comparator
%
%  data_out = CONVERTDACUINT16(data_in);
%  data_out = CONVERTDACUINT16(data_in,'NAME',value,...);
%  [data_out,data_uV] = CONVERTDACUINT16(data_in,'NAME',value,...);
%
%  --------
%   INPUTS
%  --------
%   data_in       :     Input values (quantized bit values; uint16)
%
%  varargin       :     (Optional) 'NAME', value input argument pairs.
%                       -> 'SCALE' (def: 1e-6) | Conversion scale
%
%                       -> 'Q' (def: 32768) | Quantization offset
%
%  --------
%   OUTPUT
%  --------
%   data_out      :     Approximated signal as seen by DAC comparator.
%
%   data_uV       :     data_in converted to microVolts as it would have
%                          been scaled by gain and quantization scaling
%                          differences between the ADC and DAC.
%
% By: Max Murphy  v1.0  12/17/2018  Original version (R2017a)

%% DEFAULTS
N = 0;         % Gain tick
SCALE = 1e-2;  % Scale to correct prefix
Q = 32768;     % Quantization offset
D = 0.195;     % uV per bit in ADC
K = 312.5;     % uV per bit in DAC

%% PARSE VARARGIN
for iV = 1:2:numel(varargin)
   eval([upper(varargin{iV}) '=varargin{iV+1};']);
end

%% GET SCALE FACTOR
% k = (D/K) * 2^-N / SCALE;
k = (D/K) * 2^-N / D / SCALE;

%% DO CONVERSION
data_uV = (data_in-Q) / K; % DAC 
data_out = data_uV;

% data_uV = data_in * 1e3; % mV -> uV
% data_out = uint16(round(data_uV*D) + Q);


end