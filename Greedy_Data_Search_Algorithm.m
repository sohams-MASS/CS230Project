function [q]=data_algorithm(point,epsilon)
 %load dataset
 name = ['FormalTraining500k.csv'];
 datamatrix = readmatrix(name);
 datamatrix = datamatrix(randperm(size(datamatrix, 1)), :);
 inputs = datamatrix(:,4:9);
 targets = datamatrix(:,1:3);

 %Find point within a certain epsilon
 mask = abs(targets - point) < epsilon;
 for i = 1:length(mask)
     if mask(i,1) == 1 & mask(i,2) == 1 & mask(i,3) ==1
        q = inputs(i,:);
     end

end
