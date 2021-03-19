function jacobiandata(delc,samplepoints)
%Jacobian Data Collection
    %loop through all 6 parameters for collection
    for g=1:6
        jacobaindata2(g,delc,samplepoints);
    end
end

function jacobaindata2(parameter,delc,samplepoints)
%List of parameters
listofpossibleparameters={['c1'], ['c2'], ['c3'], ['alpha1'], ['alpha2'], ['alpha3']};
%choose the parameters based on the function call
parameterstr = cell2mat(listofpossibleparameters(parameter));
%Create file id
name = ['JacobianData Matrix Column ' num2str(parameter) '.csv'];
fileID=fopen(name ,'w');
%Start printing
fprintf(fileID,'%12s %12s %12s %12s %12s %12s %12s %12s %12s\n','t1','t2','t3','r1', 'r2', 'r3', 'J1', 'J2', 'J3');

    for i = 1:samplepoints
        %Randomise the inputs to the robot configuration space subject to
        %constraints and inequalites
        c1=45*rand()*0.01;
        c2=30*rand()*0.01;
        c3=20*rand()*0.01;
        alpha1=-pi()+2*pi()*rand(); 
        alpha2=-pi()+2*pi()*rand(); 
        alpha3=-pi()+2*pi()*rand();
        while c2 > c1 || 30-c2 > 45-c1
            c2=30*rand();
        end
        while c3 > c2 || 20-c3 > 30-c2
            c3=20*rand();
        end
        
        %Perturb Parameter
        parpositive = eval(parameterstr) + delc;
        parnegative = eval(parameterstr) - delc;
        
        %Find q positive and q negative parameters
        q = [-c1 -c2 -c3 alpha1 alpha2 alpha3];
        qpositive=[-c1 -c2 -c3 alpha1 alpha2 alpha3];
        qnegative=[-c1 -c2 -c3 alpha1 alpha2 alpha3];
        
        %Make sure to convert to ngeative for the translations
        if parameter <=3
            qpositive(parameter) = -parpositive;
            qnegative(parameter) = -parnegative;
        else
            qpositive(parameter) = parpositive;
            qnegative(parameter) = parnegative;
        end
        
        %Use forward kinematic model to calculate accurately out the end
        %effector tip positions
        try
        [rpositive,~,~] = moving_CTR2(qpositive);
        [rnegative,~,~] = moving_CTR2(qnegative);
        end
        %Calculate the Jacobian
        Jacobian = (rpositive(end,1:3) - rnegative(end,1:3))/(2*delc);
        
        %Write Jacobian Data
        towrite = [q Jacobian];

        fprintf(fileID,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f \n',towrite);
        
    end

fclose(fileID)

end
