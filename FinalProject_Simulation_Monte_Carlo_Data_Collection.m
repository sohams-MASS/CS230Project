
clearvars
clc
v=500000; %number of sample points
t=0:1:v;

%Open a File to Write Data
fileID=fopen('FormalTraining500k.csv','w');
fprintf(fileID,'%12s %12s %12s %12s %12s %12s %12s %12s %12s\n','x','y','z','t1', 't2', 't3', 'r1', 'r2', 'r3');

for i=1:length(t)
    %Choose Rotation Parameters
    w1=-pi()+2*pi()*rand(); w2=-pi()+2*pi()*rand(); w3=-pi()+2*pi()*rand();
    % randomise length transformation
    c1=45*rand();
    c2=30*rand();
    c3=20*rand();
    
    %make sure tubes dont clash into each other
    while c2 > c1 || 30-c2 > 45-c1
        c2=30*rand();
    end
    while c3 > c2 || 20-c3 > 30-c2
        c3=20*rand();
    end


    B=[-c1 -c2 -c3]*0.01; 

    %angles
    alpha_1=w1;
    alpha_2=w2;
    alpha_3=w3;
    q=[B alpha_1 alpha_2 alpha_3];
    
    %Calculate forward kinematics
    try
    [r1,r2,r3] = moving_CTR2(q);
    end

    %Find Tip position
    tipposition=[r1(end,1),r1(end,2),r1(end,3)];
    
    %Write results
    inputs=q;
    A=[tipposition inputs];
    fprintf(fileID,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f \n',A);

end
fclose(fileID);

