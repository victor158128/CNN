function net = cnnff(net, opts, x)
    n = numel(net.layers);
    net.layers{1}.a{1} = x;
    inputmaps = 1;

    for l = 2 : n   %  for each layer
        if strcmp(net.layers{l}.type, 'c')
            %  !!below can probably be handled by insane matrix operations
            for j = 1 : net.layers{l}.outputmaps   %  for each output map
                %  create temp output map
                z = zeros(size(net.layers{l - 1}.a{1}) - [net.layers{l}.kernelsize - 1  0]);  % for ecg 
                %z = zeros(size(net.layers{l - 1}.a{1}) - [net.layers{l}.kernelsize - 1 net.layers{l}.kernelsize - 1 0]);  % for image
                for i = 1 : inputmaps   %  for each input map
                    %  convolve with corresponding kernel and add to temp output map
                    z = z + convn(net.layers{l - 1}.a{i}, net.layers{l}.k{i}{j}, 'valid');
                end
                %  add bias, pass through nonlinearity
                net.layers{l}.a{j} = roundn(sign(z + net.layers{l}.b{j}),-10); %best result,1st run
                %net.layers{l}.a{j} = roundn(sigmf(z + net.layers{l}.b{j}, [opts.a opts.c]), -10); %not good, 2nd run
                %net.layers{l}.a{j} = roundn(exp(-(z + net.layers{l}.b{j}).^2), -10); %not good
            end
            %  set number of input maps to this layers number of outputmaps
            inputmaps = net.layers{l}.outputmaps;
        elseif strcmp(net.layers{l}.type, 's')
            %  downsample / subsampling (taking every other value, not max or mean)
            for j = 1 : inputmaps
                z = net.layers{l - 1}.a{j};  %for ecg
                %z = convn(net.layers{l - 1}.a{j}, ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2), 'valid');  %for n by n image   %  !! replace with variable
                temp_a = [];
                for k = 1: 2 : size(z,1)
                    twoRows = [z(k,:); z(k+1,:)];
                    temp_a = [temp_a; mean(twoRows,1)]; %for sum pooling, use sum(twoRows,1). for max pooling, use max(twoRows,1). for mean pooling, use mean(twoRows,1)
                end
                net.layers{l}.a{j} = temp_a;  %for ecg, adjusted for various pooling methods
                %net.layers{l}.a{j} = z(1 : net.layers{l}.scale : end, : );  % for ecg
                %net.layers{l}.a{j} = z(1 : net.layers{l}.scale : end, 1 : net.layers{l}.scale : end, :);  % for n by n image
            end
        end
    end
    
    %  concatenate all end layer feature maps into vector
    net.fv = [];
    for j = 1 : numel(net.layers{n}.a)
        sa = size(net.layers{n}.a{j});
        net.fv = [net.fv; net.layers{n}.a{j}];  %for ecg
        %net.fv = [net.fv; reshape(net.layers{n}.a{j}, sa(1), sa(2))]; %for ecg, redundant  
        %net.fv = [net.fv; reshape(net.layers{n}.a{j}, sa(1) * sa(2), sa(3))]; %for n by n image
    end
    %  feedforward into output perceptrons
    %net.o = roundn(sign(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2))),-10); %sign activation
    net.o = roundn(exp(-(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2))).^2), -10); %Gaussian activation, best result, 1st run
    %net.o = roundn(sigmf(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2)), [opts.a opts.c]),-10); %sigmoid activation, 2nd run

end

function z=sigmoidy(a)
z=1./(1+exp(-a));
end