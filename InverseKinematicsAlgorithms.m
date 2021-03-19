function [qfinal] = InverseKinematics(point,learningrate,precision)
%Both inverse kinematic models are implemented here based on commented and uncommented lines.

    %Load Forward Kinematic Model
    load FeedforwardkNN.mat

        

    netff = net;
    
    %Load a GAN Network
    load GANGenerator.mat
    netgan = net;
    
    %Load Jacobian Neural Network
    netJ = cell(6,1);
    Jacobian = ones(3,6);
    for i = 1:6
        filename = ['JacobianData Matrix Column ' num2str(i) 'kNN.mat'];
        load(filename)
        netJ{i} = net;
    end   
    
    
    %initialise the error of the objective function
    msetag = [];
    msetagv = sum((point' - netff(q')).^2)*1000;
    msetag(2) = 500;
    
    %Search in Algorithm 2 for Inverse Kinematics (Comment if you want data
    %search)
    q = data_algorithm(point,0.008);
    for v = 1:6
        Jacobian(1:3,v) = netJ{1}(q');
    end
    steps = 0;
    figure(1)
    
    %Uncomment for Jacobian GAN
    %q = predict(netGAN, dlarray(point','CB');
   
        
       
        
    while msetagv > precision & steps < 500*4
        %calculate gradient
        gradient = -2*(point'-netff(q'))'*Jacobian;
        qupdate = q - learningrate*gradient;
        q = qupdate;
        msetagv = sum((point' - netff(q')).^2)*1000;
        steps = steps + 1;
        
        %In case stuff doesnt work retry with new point 
        if msetagv > precision && steps == 500*4
            q=data_algorithm(point,0.008);
            %Uncomment if using GAN utilisng updated point
            %q = predict(netGAN, dlarray(point','CB');
            steps=0;
        end
    end
   
    qfinal = q;
end
