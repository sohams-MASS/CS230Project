%load training data
clear
clc
%Figure out sizes of data
name = ['FormalTraining500k.csv'];
datamatrix = readmatrix(name);
targets = datamatrix(:,4:9);
inputs = datamatrix(:,1:3);
[len, row] = size(inputs);   
t = inputs';
x = targets';
xtry=x';
ttry=t';

%delcare number of hidden units and batch sizes
numHiddenUnits = 500;
minibatchsize = 2000;
numFeatures = size(x,1);
numResponses = size(x,1);

%declare Generator Structures 1 to 3

%Generator structure 1
layersG1 = [
    featureInputLayer(12, 'Name', 'InputLayer')
    fullyConnectedLayer(numHiddenUnits, 'Name', 'DenseLayer')
    reluLayer('Name', 'tnah1')
    fullyConnectedLayer(200, 'Name', 'Denselayer2')
    reluLayer('Name', 'tanh2')
    fullyConnectedLayer(numResponses, 'Name', 'FinalLayer')
    ];


lgraphG1 = layerGraph(layersG1);
dlnetGenerator1 = dlnetwork(lgraphG1);

%Generator structure 2
layersG2 = [
    featureInputLayer(12, 'Name', 'InputLayer')
    fullyConnectedLayer(numHiddenUnits, 'Name', 'DenseLayer')
    reluLayer('Name', 'tnah1')
    fullyConnectedLayer(200, 'Name', 'Denselayer2')
    reluLayer('Name', 'tanh2')
    fullyConnectedLayer(numResponses, 'Name', 'FinalLayer')
    ];


lgraphG2 = layerGraph(layersG2);
dlnetGenerator2 = dlnetwork(lgraphG2);

%Generator structure 3
layersG3 = [
    featureInputLayer(12, 'Name', 'InputLayer')
    fullyConnectedLayer(numHiddenUnits, 'Name', 'DenseLayer')
    reluLayer('Name', 'tnah1')
    fullyConnectedLayer(200, 'Name', 'Denselayer2')
    reluLayer('Name', 'tanh2')
    fullyConnectedLayer(numResponses, 'Name', 'FinalLayer')
    ];


lgraphG3 = layerGraph(layersG3);
dlnetGenerator3 = dlnetwork(lgraphG3);


layersDiscriminator = [...
    featureInputLayer(6, 'Name', 'InputLayerD')
    fullyConnectedLayer(100, 'Name', 'DenseLayerD')
    dropoutLayer(0.5, 'Name', 'dropout2')
    reluLayer('Name', 'relu1')
    fullyConnectedLayer(100, 'Name','DenseD')
    reluLayer('Name', 'relu2')
    dropoutLayer(0.5, 'Name', 'dropout')
    fullyConnectedLayer(1, 'Name', 'FinalLayerD')
    ];

lgraphDiscriminator = layerGraph(layersDiscriminator);
dlnetDiscriminator = dlnetwork(lgraphDiscriminator);


%Table Number of epochs, and learning parameter options
numEpochs = 3000;
learnRateDiscriminator = 0.004;
learnRateGenerator = 0.001;
gradientDecayFactor = 0.5;
squaredGradientDecayFactor = 0.999;

%initialise vectors for learning
trailingAvgGenerator1 = [];
trailingAvgSqGenerator1 = [];
trailingAvgDiscriminator1 = [];
trailingAvgSqDiscriminator1 = [];

trailingAvgGenerator2 = [];
trailingAvgSqGenerator2 = [];
trailingAvgDiscriminator2 = [];
trailingAvgSqDiscriminator2 = [];

trailingAvgGenerator3 = [];
trailingAvgSqGenerator3 = [];
trailingAvgDiscriminator3 = [];
trailingAvgSqDiscriminator3 = [];

%initialise figure for visualisng training
f = figure;
f.Position(3) = 2*f.Position(3);
validationAxes = subplot(1,2,1);
scoreAxes = subplot(1,2,2);
lineScoreGenerator = animatedline(scoreAxes,'Color',[0 0.447 0.741]);
lineScoreDiscriminator = animatedline(scoreAxes, 'Color', [0.85 0.325 0.098]);
lineScoreValidator = animatedline(validationAxes, 'Color', [0.85 0.325 0.098]);
legend('Generator','Discriminator');
ylim([0 1])
xlabel("Iteration")
ylabel("Score")
grid on

%Start Iteration Counter
iteration = 0;
start = tic;
executionEnvironment = "auto";
validationfrequency = 100;


%Train on Generators
% Loop over epochs.
for epoch = 1:numEpochs
    
    
        iteration = iteration + 1;
        
        % Read mini-batch of data.
       
        dlX = dlarray(xtry','CB');
        
        % Generate latent inputs for the generator network. 
        Z = rand(len,9);
        Z = [Z inputs];
        dlZ = dlarray(Z','CB'); 
       
        
        if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
            dlZ = gpuArray(dlZ);
        end
        
        % Evaluate the model gradients and the generator state using
        % dlfeval and the modelGradients function listed at the end of the
        % example.
        [gradientsGenerator1, gradientsDiscriminator1, stateGenerator1, scoreGenerator1, scoreDiscriminator1] = ...
            dlfeval(@modelGradients, dlnetGenerator1, dlnetDiscriminator, dlX, dlZ);
        dlnetGenerator1.State = stateGenerator1;
        
        [gradientsGenerator2, gradientsDiscriminator2, stateGenerator2, scoreGenerator2, scoreDiscriminator2] = ...
            dlfeval(@modelGradients, dlnetGenerator2, dlnetDiscriminator, dlX, dlZ);
        dlnetGenerator2.State = stateGenerator2;
        
        [gradientsGenerator3, gradientsDiscriminator3, stateGenerator3, scoreGenerator3, scoreDiscriminator3] = ...
            dlfeval(@modelGradients, dlnetGenerator1, dlnetDiscriminator, dlX, dlZ);
        dlnetGenerator3.State = stateGenerator3;
        
        % Update the discriminator network parameters.
        [dlnetDiscriminator,trailingAvgDiscriminator,trailingAvgSqDiscriminator] = ...
            adamupdate(dlnetDiscriminator, gradientsDiscriminator, ...
            trailingAvgDiscriminator, trailingAvgSqDiscriminator, iteration, ...
            learnRateDiscriminator, gradientDecayFactor, squaredGradientDecayFactor);
        
     
        
        % Update the generator network parameters.
        [dlnetGenerator1,trailingAvgGenerator1,trailingAvgSqGenerator1] = ...
            adamupdate(dlnetGenerator1, gradientsGenerator1, ...
            trailingAvgGenerator1, trailingAvgSqGenerator1, iteration, ...
            learnRateGenerator, gradientDecayFactor, squaredGradientDecayFactor);
        
        [dlnetGenerator2,trailingAvgGenerator2,trailingAvgSqGenerator2] = ...
            adamupdate(dlnetGenerator1, gradientsGenerator2, ...
            trailingAvgGenerator2, trailingAvgSqGenerator2, iteration, ...
            learnRateGenerator, gradientDecayFactor, squaredGradientDecayFactor);
        
        [dlnetGenerator3,trailingAvgGenerator3,trailingAvgSqGenerator3] = ...
            adamupdate(dlnetGenerator1, gradientsGenerator3, ...
            trailingAvgGenerator3, trailingAvgSqGenerator3, iteration, ...
            learnRateGenerator, gradientDecayFactor, squaredGradientDecayFactor);
        
        % Every validationFrequency iterations, display Generator Loss
        if mod(iteration,1) == 0 || iteration == 1
            
            % Grab Sets from Validation Round
              Zvalidation = rand(20,9);
              v = randi(len-20);
              Zvalidation = [Zvalidation inputs(v:v+19, :)];
              dlZValidation = dlarray(Zvalidation', 'CB');
              dlXGeneratedValidation = predict(dlnetGenerator1,dlZValidation);
              %Calculate Validation Loss
              lossGeneratorvalid=generatorLoss(dlZValidation, dlXGeneratedValidation);
              subplot(1,2,1);
              addpoints(lineScoreValidator, iteration,...
                 double(lossGeneratorvalid)

            
            title("Generated Data Point Loss");
            drawnow
        end
        
        % Update the scores plot
        subplot(1,2,2)
        addpoints(lineScoreGenerator,iteration,...
            double(gather(extractdata(scoreGenerator))));
        
        addpoints(lineScoreDiscriminator,iteration,...
            double(gather(extractdata(scoreDiscriminator))));
        
        % Update the title with training progress information.
        D = duration(0,0,toc(start),'Format','hh:mm:ss');
        title(...
            "Epoch: " + epoch + ", " + ...
            "Iteration: " + iteration + ", " + ...
            "Elapsed: " + string(D))
        
        drawnow
    %end
end



function [gradientsGenerator, gradientsDiscriminator, stateGenerator, scoreGenerator, scoreDiscriminator] = ...
    modelGradients(dlnetGenerator, dlnetDiscriminator, dlX, dlZ)

% Calculate the predictions for real data with the discriminator network.
dlYPred = forward(dlnetDiscriminator, dlX);

% Calculate the predictions for generated data with the discriminator network.
[dlXGenerated,stateGenerator] = forward(dlnetGenerator,dlZ);
dlYPredGenerated = forward(dlnetDiscriminator, dlXGenerated);

% Convert the discriminator outputs to probabilities.
probGenerated = sigmoid(dlYPredGenerated);
probReal = sigmoid(dlYPred);

% Calculate the score of the discriminator.
scoreDiscriminator = ((mean(probReal)+mean(1-probGenerated))/2);

% Calculate the score of the generator.
scoreGenerator = mean(probGenerated);

% Calculate the GAN loss.
[lossGenerator, lossDiscriminator] = ganLoss(probReal,probGenerated);

%Calculate the Generator Loss on top
[lossGenerator2] = generatorLoss(dlZ,dlXGenerated);

lossGenerator = lossGenerator + lossGenerator2;
% For each network, calculate the gradients with respect to the loss.
gradientsGenerator = dlgradient(lossGenerator, dlnetGenerator.Learnables,'RetainData',true);
gradientsDiscriminator = dlgradient(lossDiscriminator, dlnetDiscriminator.Learnables);

end

function [lossGenerator, lossDiscriminator] = ganLoss(probReal,probGenerated)

% Calculate the loss for the discriminator network.
lossDiscriminator =  -mean(log(probReal)) -mean(log(1-probGenerated));

% Calculate the loss for the generator network.
lossGenerator = -mean(log(probGenerated));

end

function [lossGenerator2]=generatorLoss(dlZ, dlXgenerated)
%Label Target Points
targetpoints = extractdata(dlZ(10:12,:));
qpoints = extractdata(dlXgenerated);
lossGenerator2 = 0;

%load forward kinematics model
load GanForwardknn.mat

netgan = net;


for i = 1:length(qpoints)
    %extract relevant robot parameters
    c1 = qpoints(1,i);
    c2 = qpoints(2,i);
    c3 = qpoints(3,i);
    a1 = qpoints(4,i);
    a2 = qpoints(5,i);
    a3 = qpoints(6,i);
    qpoint = [c1 c2 c3 a1 a2 a3];
    
    %calculate the extra loss functions quadratic barrier
    
    lossGenerator2 = lossGenerator2 + 0.5*(min(c2+L,0)^2+max(c2,0))^2 + 0.5*(min(c1+L,0)^2+max(c1,0))^2 + 0.5*(min(c3+L,0)^2+max(c3,0))^2 +  0.5*(min(a2+L,0)^2+max(a2,0))^2 + 0.5*(min(a1+L,0)^2+max(a1,0))^2 + 0.5*(min(a3+L,0)^2+max(c3,0))^2;;
    if abs(c2) > abs(c1) | 30-abs(c2*100) > 45-abs(c1*100) | abs(c3) > abs(c2) | 20-abs(c3*100) > 30-abs(c2*100)
        lossGenerator2 = lossGenerator2 + 0.5*(min(c2+20,c1)^2+max(c2-c3,0))^2 + 0.5*(min(c1+45,0)^2+max(c1-c2,0))^2 + 0.5*(min(c3+20,0)^2+max(c3-c2,0))^2;
    else
        dlqpoint = dlarray(qpoint);
        points = predict(netgan, dlqpoint);
        lossGenerator2 = sum((targetpoints(1:3,i)-points').^2)+lossGenerator2;
    end
    i
end
%calculate mean loss
lossGenerator2 = lossGenerator2/length(qpoints);
end
