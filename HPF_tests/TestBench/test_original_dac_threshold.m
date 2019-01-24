%% check original DAC thresholds
clear
close all
clc
% read_Intan_RHS2000_file('C:\Users\BuccelliLab\Desktop\Prova_intan\Ordered_recordings\HPF_250Hz_200uV_A004_190108_151822.rhs')
% read_Intan_RHS2000_file('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\R19-00_2019-01-23\R19-00_2019-01-23_0_190123_094952.rhs')
% read_Intan_RHS2000_file('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\R19-00_2019-01-23\R19-00_2019-01-23_1_190123_095040.rhs')
read_Intan_RHS2000_file('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\R19-00_2019-01-23\R19-00_2019-01-23_2_190123_095121.rhs')

possible_gains=1.6.*2.^(0:7);
n_DAC_bits=16;
n_DAC_levels=2^n_DAC_bits;
V_per_bits=10.24*2/n_DAC_levels; % this is what you can see as scaling factor during the data retrieve from the .rhs file
%% Voltage Step Size of ADC (16 bits) is: 0.195uV 
uV_per_uV=V_per_bits/0.195;

board_DAC_V=board_dac_data(1,:);
board_DAC_uint16=32768+round(board_DAC_V./312.5e-6 ); %uint16
board_DAC__ADC = 0.195 * (board_DAC_uint16 - 32768);

th_1=-413; %uV
th_1_to_tb=round(th_1/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA
th_2=-818; %uV
th_2_to_tb=round(th_2/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA
th_3=-1184; %uV
th_3_to_tb=round(th_3/0.195)+ 32768; %uint16 This is as in Qt the threshold is sent to the FPGA

%% 
figure
h(1)=subplot(2,1,1);
plot(board_DAC__ADC)
hold on
plot(h(1).XLim,[th_1 th_1],'g')
plot(h(1).XLim,[th_2 th_2],'g')
plot(h(1).XLim,[th_3 th_3],'r')
title('board_dac_data and thresholds','interpreter','none')
ylabel('DAC values [uint16]')
h(2)=subplot(2,1,2);
plot(board_dig_in_data(:,:)')
title('Board Digital In')
linkaxes(h,'x')

%% 
figure
h(1)=subplot(2,1,1);
plot(board_DAC_uint16)
hold on
plot(h(1).XLim,[th_1_to_tb th_1_to_tb],'g')
plot(h(1).XLim,[th_2_to_tb th_2_to_tb],'g')
plot(h(1).XLim,[th_3_to_tb th_3_to_tb],'r')
title('board_dac_data and thresholds','interpreter','none')
ylabel('DAC values [uV]')
h(2)=subplot(2,1,2);
plot(board_dig_in_data(:,:)')
title('Board Digital In')
linkaxes(h,'x')