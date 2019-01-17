
fileID = fopen('C:\Users\BuccelliLab\Documents\GitHub\intan-dac-debug\HPF_tests\output_main_reduced_2.txt', 'r');
retrieved_bin_vector= fscanf(fileID, '%s');
retrieved_bin_matrix= reshape(retrieved_bin_vector,16,[])';
fclose(fileID);

%% check how to obtain the binary form of the raw data as FPGA sees it
retrieved_bin_matrix_dec=bin2dec(retrieved_bin_matrix(1:end,:)); % from 5 which is the clock rate, not the sample rate

%% plot comparison
start_sample=1;
stop_sample=length(retrieved_bin_matrix_dec);
figure
h(1)=subplot(3,1,1);
plot(retrieved_bin_matrix_dec)
title('testbench')
hold on
h(2)=subplot(3,1,2);
online_res=32768+(board_dac_data(1,start_sample:stop_sample)./312.5e-6 );
plot(online_res)
title('online board dac output')
h(3)=subplot(3,1,3);
plot(retrieved_bin_matrix_dec(1:stop_sample-start_sample)-online_res(2:stop_sample-start_sample+1)')
title('difference testbench - online dac output')
linkaxes(h,'x')
