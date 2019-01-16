%% send data to txt
clear
% load('C:\Users\BuccelliLab\Documents\GitHub\intan_project\debugging\sample_data\data_reduced_r17.mat')
% read_Intan_RHS2000_file('C:\Users\BuccelliLab\Desktop\Prova_intan\Ordered_recordings\HPF_250Hz_200uV_A004_190108_151822.rhs')
read_Intan_RHS2000_file('C:\Users\BuccelliLab\Desktop\Prova_intan\Ordered_recordings\HPF_3000Hz_50uV_A004_190114_103812.rhs')

%% don't forget to modify the filter in Verilog with this number:
fs=30e3;
fc=250;
b = 1.0 - exp(-2.0 * 3.1415926535897 * fc / fs); 
filterCoefficient = floor(65536.0 * b + 0.5);

%% plot to look at the data

t=(1:1:size(amplifier_data,2))./fs;
amplif=amplifier_data(5,:);
dac=board_dac_data(1,:);
figure
h(1)=subplot(2,1,1);
plot(t,amplif)
h(2)=subplot(2,1,2);
plot(t,dac)
linkaxes(h,'x')
%% start and stop sample to send binary

start_sample=1;
stop_sample=6e3;

amplifier_u16=32768+amplifier_data(5,start_sample:stop_sample)/0.195;
 
data_bin=dec2bin(amplifier_u16,16);
bin_matrix=char(data_bin);

fileID = fopen('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\HPF_tests\ampl_data_bin.txt', 'w');
for i=1:length(bin_matrix)
    %     fprintf(fileID, '%s \n', hex_matrix(i,:));
    fprintf(fileID, '%s \n', bin_matrix(i,:));
end
 fclose(fileID);