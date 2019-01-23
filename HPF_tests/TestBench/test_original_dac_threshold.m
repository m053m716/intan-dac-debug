%% check original DAC thresholds
clear
clc
read_Intan_RHS2000_file('C:\Users\BuccelliLab\Desktop\Prova_intan\Ordered_recordings\HPF_250Hz_200uV_A004_190108_151822.rhs')
possible_gains=1.6.*2.^(0:7);
n_DAC_bits=16;
n_DAC_levels=2^n_DAC_bits;
V_per_bits=10.24*2/n_DAC_levels; % this is what you can see as scaling factor during the data retrieve from the .rhs file
%% Voltage Step Size of ADC (16 bits) is: 0.195uV 
uV_per_uV=V_per_bits/0.195;

board_DAC_V=board_dac_data(1,:);
board_DAC_uint16=32768+round(board_DAC_V./312.5e-6 ); %uint16

th_1=200; %uV
th_1_to_tb=round(th_1/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA


%% 
figure
h(1)=subplot(2,1,1);
plot(board_DAC_uint16)
hold on
plot(h(1).XLim,[th_1_to_tb th_1_to_tb],'g')
h(2)=subplot(2,1,2);
plot(board_dig_out_data(1,:))
linkaxes(h,'x')