function net = cnnbp(net, y)
    n = numel(net.layers);

    %   error = output - label
    net.e = net.o - y;
    %  squre loss function
    net.L = 1/2* sum(net.e(:) .^ 2) / size(net.e, 2);

    %%  backprop deltas
    %htf did they get this delta weight. net.od=learning_rate*error*input
    
    net.od = net.e .* (net.o .* (1 - net.o));   %  output delta, delta weight
    net.fvd = (net.ffW' * net.od);              %  feature vector delta
    if strcmp(net.layers{n}.type, 'c')         %  only conv layers has sigm function
        net.fvd = net.fvd .* (net.fv .* (1 - net.fv));
    end

    %  reshape feature vector deltas into output map style
    sa = size(net.layers{n}.a{1});
    fvnum = sa(1);  %for ecg
    %fvnum = sa(1) * sa(2);  %for n by n image
    for j = 1 : numel(net.layers{n}.a)
        net.layers{n}.d{j} = net.fvd(((j - 1) * fvnum + 1) : j * fvnum, :);
        %net.layers{n}.d{j} = reshape(net.fvd(((j - 1) * fvnum + 1) : j * fvnum, :), sa(1), sa(2));  %for ecg, redundant
        %net.layers{n}.d{j} = reshape(net.fvd(((j - 1) * fvnum + 1) : j * fvnum, :), sa(1), sa(2), sa(3));  %for n by n image
    end

    for l = (n - 1) : -1 : 1
        if strcmp(net.layers{l}.type, 'c')
            for j = 1 : numel(net.layers{l}.a)
                net.layers{l}.d{j} = net.layers{l}.a{j} .* (1 - net.layers{l}.a{j}) .* (expand_cnn(net.layers{l + 1}.d{j}, [net.layers{l + 1}.scale 1]) / net.layers{l + 1}.scale);  %for ecg
                %net.layers{l}.d{j} = net.layers{l}.a{j} .* (1 - net.layers{l}.a{j}) .* (expand_cnn(net.layers{l + 1}.d{j}, [net.layers{l + 1}.scale net.layers{l + 1}.scale 1]) / net.layers{l + 1}.scale ^ 2); %for n by n image
            end
        elseif strcmp(net.layers{l}.type, 's')
            for i = 1 : numel(net.layers{l}.a)
                z = zeros(size(net.layers{l}.a{1}));
                for j = 1 : numel(net.layers{l + 1}.a)
                    z = z + convn(net.layers{l + 1}.d{j}, flip(net.layers{l + 1}.k{i}{j}, 1), 'full');  %for ecg
                    %z = z + convn(net.layers{l + 1}.d{j}, rot180(net.layers{l + 1}.k{i}{j}), 'full');  %for n by n image
                end
                net.layers{l}.d{i} = z;
            end
        end
    end

    %%  calc gradients
    for l = 2 : n
        if strcmp(net.layers{l}.type, 'c')
            for j = 1 : numel(net.layers{l}.a)
                for i = 1 : numel(net.layers{l - 1}.a)    
                    net.layers{l}.dk{i}{j} = convn(flipall(net.layers{l - 1}.a{i}), net.layers{l}.d{j}, 'valid') / size(net.layers{l}.d{j}, 2);  %for ecg
                    %net.layers{l}.dk{i}{j} = convn(flipall(net.layers{l - 1}.a{i}), net.layers{l}.d{j}, 'valid') / size(net.layers{l}.d{j}, 3);  %for n by n image
                end
                net.layers{l}.db{j} = sum(net.layers{l}.d{j}(:)) / size(net.layers{l}.d{j}, 2);  %for ecg
                %net.layers{l}.db{j} = sum(net.layers{l}.d{j}(:)) / size(net.layers{l}.d{j}, 3);  % for n by n image
            end
        end
    end
    net.dffW = net.od * (net.fv)' / size(net.od, 2);  %for ecg
    net.dffb = mean(net.od, 2);  %for ecg

    %net.dffW = net.od * (net.fv)' / size(net.od, 2);  % for n by n image
    %net.dffb = mean(net.od, 2);   % for n by n image

    function X = rot180(X)
        X = flipdim(flipdim(X, 1), 2);
    end
end
