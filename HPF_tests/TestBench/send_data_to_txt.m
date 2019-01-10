%% send data to txt
clear
% load('C:\Users\BuccelliLab\Documents\GitHub\intan_project\debugging\sample_data\data_reduced_r17.mat')
load('C:\Users\BuccelliLab\Desktop\Prova_intan\HPF_tests\TestBench\data_amplif_uint16.mat')

data_bin=dec2bin(amplifier_u16,16);
bin_matrix=char(data_bin);

fileID = fopen('ampl_data_bin.txt', 'w');
for i=1:length(bin_matrix)
    %     fprintf(fileID, '%s \n', hex_matrix(i,:));
    fprintf(fileID, '%s \n', bin_matrix(i,:));
end
 fclose(fileID);