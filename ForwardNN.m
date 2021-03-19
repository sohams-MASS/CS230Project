
%Training Forward and Inverse Kinematic NN (For Inverse simply switch)

name = ['FormalTraining3.csv'];
        datamatrix = readmatrix(name);
        %For inverse simply switch
        targets = datamatrix(:,4:9);
        inputs = datamatrix(:,1:3);

        numFeatures = size(targets',1);

        numHiddenUnits = 500;
        
        %Label Hidden Units
        minibatchsize = 128;

        
%Layer Setup for Forward Kineamtic NN    
layers = [ ...
    featureInputLayer(numFeatures, 'Name', 'Input')
    fullyConnectedLayer(numHiddenUnits, 'Name', 'Connected')
    reluLayer('Name', 'relu1')
    fullyConnectedLayer(250 , 'Name', 'Connected2')
    reluLayer( 'Name', 'relu2')
    fullyConnectedLayer(100, 'Name', 'Break2')
    reluLayer('Name', 'relu3')
    fullyConnectedLayer(numResponses, 'Name', 'Break')
    regressionLayer('Name', 'regression')];

%Further Training options

maxEpochs = 200;
miniBatchSize = 128;
lgraphDiscriminator = layerGraph(layers);

%Adam Training Options
options = trainingOptions('adam', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',0.01, ...
    'GradientThreshold',1, ...
    'Shuffle','never', ...
    'Plots','training-progress',...
    'Verbose',0);
net = trainNetwork(targets,inputs,layers,options);