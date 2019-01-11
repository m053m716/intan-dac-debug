
fileID = fopen('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\HPF_tests\Output_1.txt', 'r');
retrieved_bin_vector= fscanf(fileID, '%s');
retrieved_bin_matrix= reshape(retrieved_bin_vector,16,[])';
fclose(fileID);

%% check how to obtain the binary form of the raw data as FPGA sees it
retrieved_bin_matrix_dec=bin2dec(retrieved_bin_matrix(1:end,:)); % from 5 which is the clock rate, not the sample rate

%% plot comparison
figure
h(1)=subplot(3,1,1);
plot(retrieved_bin_matrix_dec)
title('testbench')
hold on
h(2)=subplot(3,1,2);
online_res=32768+(board_dac_data(1,:)./312.5e-6 );
plot(online_res)
title('online board dac output')
h(3)=subplot(3,1,3);
plot(retrieved_bin_matrix_dec-online_res)
linkaxes(h,'x')
