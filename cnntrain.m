function [net, ematrix, result_verification] = cnntrain(net, x, y, opts, test_x, test_y)
    
    m = size(x, 2);  %(x,2) for ecg signal
    numbatches = floor(m / opts.batchsize);
    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end
    net.rL = [];
    accuracy_all = [];
    sensitivity_all = [];
    predictivity_all = [];
    f_p_all = [];
    ematrix = [];
    for i = 1 : opts.numepochs
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
        tic;  %Elapsed time starts
        kk = randperm(numbatches*opts.batchsize);
        for l = 1 : numbatches
            
            batch_x = x(:, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));  %x(:, kk((l - 1) for ecg
            %batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));  %x(:, :, kk((l - 1) for image
            batch_y = y(:, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));

            net = cnnff(net, opts, batch_x);
            net = cnnbp(net, batch_y);
            net = cnnapplygrads(net, opts);
            if isempty(net.rL)
                net.rL(1) = net.L;
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
        end
        
        [accuracy_avg, sensitivity_avg, predictivity_avg, f_p_avg, fusionmatrix] = cnntest(net, test_x, test_y, opts);
        
        error_statement = sprintf('Epoch %d: Error is %.3f%%', i, (1-accuracy_avg)*100);
        disp(error_statement);
        result_verification(1,i)=accuracy_avg;
        result_verification(2,i)=sensitivity_avg;
        result_verification(3,i)=predictivity_avg;
        result_verification(4,i)=f_p_avg;  
        ematrix{i} = fusionmatrix;
        
        toc;  %Elapsed time ends
    end
    
end
