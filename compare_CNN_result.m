
cd 'C:\Users\victo\Desktop\git_home\individual_data'
files = dir('balanced*.mat');
n=1;

result_matrix_A = [];
result_matrix_C = [];

for j = 0.1:1
    summ=0;
    for m= 1: length(files)
        eval(['load ' files(m).name]);

        opts.alpha = j; %for CNN, sets learning rate, best so far = 0.1
        
        test_example_CNN;
        index_CNN = find(accuracy_plot == max(accuracy_plot), 1, 'last');
        eval(['B' files(m).name(9:end-4) '_CNN_index = ' num2str(index_CNN)]);
        eval(['B' files(m).name(9:end-4) '_CNN_accuracy = ' num2str(accuracy_plot(index_CNN))]);
        eval(['B' files(m).name(9:end-4) '_CNN_matrix = ' mat2str(cell2mat(ematrix(index_CNN)))]);
        clear accuracy_plot biases delta ematrix epochs eta  initial_method input_num lmbda ...
            mini_batch_size

        eval(['result_matrix_C{n}{m}{1} = B' files(m).name(9:end-4) '_CNN_index']);
        eval(['result_matrix_C{n}{m}{2} = B' files(m).name(9:end-4) '_CNN_accuracy']);
        eval(['result_matrix_C{n}{m}{3} = B' files(m).name(9:end-4) '_CNN_matrix']);

    end
    for y = 1:m
        eval('summ = summ+result_matrix_A{n}{y}{2}');
    end
    eval(['average_accuracy_A_' num2str(n) '= summ/m']);
    n=n+1;
end
