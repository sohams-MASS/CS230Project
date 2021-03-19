
function JacobianNNcol
 %Training Function for Jacobian Columns
    for i = 1:6
        %Extract Data
        name = ['JacobianData Matrix Column ' num2str(i) '.csv'];
        datamatrix = readmatrix(name);
        inputs = datamatrix(:,1:6);
        targets = datamatrix(:,7:9);
        
        %Lable Targets and Inputs
        x = inputs';
        t = targets';
        trainFcn = 'trainlm';
        hiddenLayerSize = 50;
        net = fitnet(hiddenLayerSize,trainFcn);
        net.divideParam.trainRatio = 98/100;
        net.divideParam.valRatio = 1/100;
        net.divideParam.testRatio = 1/100;
        [net,tr] = train(net,x,t);

        % Test the Network
        y = net(x);
        e = gsubtract(t,y);
        performance = perform(net,t,y)

        % View the Network
        view(net)
        filename = ['JacobianData Matrix Column ' num2str(i) 'kNN'];
        save(filename, 'net');

    end


end
