function data_out = convertAMP(data_in,varargin)
%% CONVERTAMP   Convert amplifier bits to uV values based on ADC quanta
%
%  data_out = CONVERTAMP(data_in);
%  data_out = CONVERTAMP(data_in,'NAME',value,...);
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
%   data_out      :     Microvolt level values based on scaling that
%                       corresponds to the number of microvolts per bit for
%                       each quantization level in the Intan amplifier ADC.
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
data_uV = (data_in-Q) * D; % DAC 
data_out = data_uV;


end