inputx=table2array(trainingset9(:,1));
inputy=table2array(trainingset9(:,2));
inputz=table2array(trainingset9(:,3));

outputt1=table2array(trainingset9(:,4));
outputt2=table2array(trainingset9(:,5));
outputt3=table2array(trainingset9(:,6));
outputr1=table2array(trainingset9(:,7));
outputr2=table2array(trainingset9(:,8));
outputr3=table2array(trainingset9(:,9));

targets=[outputt1, outputt2, outputt3, outputr1, outputr2, outputr3];
inputs=[inputx, inputy, inputz];
grid on
h=plot3(inputx*100, inputy*100, inputz, 'bo')
h.LineWidth=0.0001
h.Color=[0 0 0.01]
h.MarkerSize=1
%plot(inputx*1000, inputy*1000,'b.')
xlabel('X [mm]'); ylabel('Y [mm]'); zlabel('Z [mm]')
%axis equal
grid on
%ttds = tabularTextDatastore('trainingset9.txt', 'Delimiter', ',')
writematrix(targets, 'Targets.csv')
writematrix(inputs, 'Inputs.csv')