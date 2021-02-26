
clearvars
clc
v=1000; %number of sample points
t=0:1:v;

fileID=fopen('trainingset23.txt','w');
fprintf(fileID,'%12s %12s %12s %12s %12s %12s %12s %12s %12s\n','x','y','z','t1', 't2', 't3', 'r1', 'r2', 'r3');

for i=1:length(t)
w1=-pi()+2*pi()*rand(); w2=-pi()+2*pi()*rand(); w3=-pi()+2*pi()*rand();
% randomise length transformation
c1=240*rand();
c2=200*rand();
c3=120*rand();
%make sure tubes dont clash into each other
while c2 > c1 || 200-c2 > 240-c1
    c2=200*rand();
end
while c3 > c2 || 120-c3 > 200-c2
    c3=120*rand();
end
       
        
B=[-c1 -c2 -c3]*0.001; 

%angles
alpha_1=w1;
alpha_2=w2;
alpha_3=w3;
q=[B alpha_1 alpha_2 alpha_3];

tic
[r1,r2,r3] = moving_CTR(q);

toc
figure(1)
%clf(figure(1))
%plot3(r1(:,1),r1(:,2),r1(:,3),'b','LineWidth',2)
plot3(r1(end,1), r1(end,2), r1(end,3),'b.')
hold on
%plot3(r2(:,1),r2(:,2),r2(:,3),'r','LineWidth',4)
%plot3(r3(:,1),r3(:,2),r3(:,3),'g','LineWidth',6)

xlabel('X [mm]'); ylabel('Y [mm]'); zlabel('Z [mm]')
grid on
axis equal
tipposition=[r1(end,1),r1(end,2),r1(end,3)];

inputs=q;
A=[tipposition inputs];
fprintf(fileID,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f \n',A);



end
fclose(fileID);

