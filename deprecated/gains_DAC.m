%% note that there's a quantization error (or a different sample that passed through the DAC) 
%% these values are +-V_per_bits
get_files_of_interest

%% possible gains 1.6 mV/µV to 204.8 mV/µV
%% It is important to remember that the analog outputs limit at ±10.24V
possible_gains=1.6.*2.^(0:7);
n_DAC_bits=16;
n_DAC_levels=2^n_DAC_bits;
V_per_bits=10.24*2/n_DAC_levels; % this is what you can see as scaling factor during the data retrieve from the .rhs file
%% Voltage Step Size of ADC (16 bits) is: 0.195uV 
mV_per_uV=1e3*V_per_bits/0.195;
% What is missing when you retrieve data is the gain that you set during
% the experiment. 

%% quantization error ?
figure
h(1)=subplot(3,1,1);
plot(t,(board_dac_data(1,:)-board_dac_data(2,:)))
title('board_dac_data 1 - 2','interpreter','none')
h(2)=subplot(3,1,2);
plot(t,board_dac_data(1,:)-board_dac_data(3,:))
title('board_dac_data 1 - 3','interpreter','none')
h(3)=subplot(3,1,3);
plot(t,board_dac_data(2,:)-board_dac_data(3,:))
title('board_dac_data 2 - 3','interpreter','none')
xlabel('Time [s]')
linkaxes(h,'x')

format long
unique(board_dac_data(1,:)-board_dac_data(2,:))