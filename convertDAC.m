function data_out = convertDAC(data_in,varargin)
%% CONVERTDAC  Convert to bit values as seen on the FPGA comparator
%
%  data_out = CONVERTDAC(data_in);
%  data_out = CONVERTDAC(data_in,'NAME',value,...);
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
%   data_out      :     Quantized bit values as seen by DAC comparator
%                          (uint16)
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

%% DAC VALUE STARTS FROM "wire [15:0] DAC_register"
% DAC_register is fixed(data_in,unsigned,16 total bits,no fractional bits)
DAC_register = fi(data_in,0,16,0);

% Scaled input is a signed integer
HPF_output = sfi(DAC_register);

% 


end