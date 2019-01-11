%% send data to txt
clear
% load('C:\Users\BuccelliLab\Documents\GitHub\intan_project\debugging\sample_data\data_reduced_r17.mat')
read_Intan_RHS2000_file('C:\Users\BuccelliLab\Desktop\Prova_intan\Ordered_recordings\HPF_250Hz_200uV_A004_190108_151822.rhs')
start_sample=3.52*1e4;
stop_sample=3.6*1e4;

amplifier_u16=32768+amplifier_data(5,start_sample:stop_sample)/0.195;
 
data_bin=dec2bin(amplifier_u16,16);
bin_matrix=char(data_bin);

fileID = fopen('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\HPF_tests\ampl_data_bin.txt', 'w');
for i=1:length(bin_matrix)
    %     fprintf(fileID, '%s \n', hex_matrix(i,:));
    fprintf(fileID, '%s \n', bin_matrix(i,:));
end
 fclose(fileID);