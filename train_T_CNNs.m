% train T-CNN

clc;
clear;
close all;

% dataset_name = 'RSSCN_';
% nums = 7;

% dataset_name = 'NWPU_';
% nums = 45;

% dataset_name = 'OPTIMAL_';
% nums = 31;

dataset_name = 'UCMerced_';
nums = 21;

iter_nums = [5,10,20];
filenames = {'resnet18_data/', 'alexnet_data/', 'inceptionv3_data/'};

for l=1:3
    
    filename = filenames{1,l}
    
for k=1:3
    k
    iter_num = iter_nums(k)

if strcmp(filename, 'resnet18_data/')
    size = 224;
elseif strcmp(filename, 'alexnet_data/')
    size = 227;
elseif strcmp(filename, 'inceptionv3_data/')
    size = 299;
else
    disp('wrong')
end


savedir = strcat('./', filename, dataset_name, '/', dataset_name, num2str(iter_num), '/');
mkdir(savedir);

for i=1:10
    i
%% import train dataset, cross validation dataset and test dataset

imagedir_train = strcat('./data_pre/', dataset_name, 'CLASS_', num2str(size),'/',...
    num2str(i, '%d'), '/', dataset_name, num2str(size), '_train');
imagedir_cv = strcat('./data_pre/', dataset_name, 'CLASS_', num2str(size),'/',...
    num2str(i, '%d'), '/', dataset_name, num2str(size), '_CV');
imagedir_test = strcat('./data_pre/', dataset_name, 'CLASS_', num2str(size),'/',...
    num2str(i, '%d'), '/', dataset_name, num2str(size), '_test');

dataTrain = imageDatastore(imagedir_train, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
categorynames = categories(dataTrain.Labels);
numClasses = numel(categorynames);

dataCV = imageDatastore(imagedir_cv, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
dataTest = imageDatastore(imagedir_test, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%% 设置参数
load(strcat('./', filename, 'fc_lgraph_', num2str(nums, '%d'), '.mat'));

tic

options = trainingOptions('sgdm', 'MiniBatchSize', 32,...
                          'MaxEpochs', iter_num, 'InitialLearnRate', 0.001,...
                          'Verbose',true, 'ValidationData', dataCV,...
                          'ValidationFrequency', 10);
[new_net, info] = trainNetwork(dataTrain, lgraph_1, options);
time_train = toc
save(strcat(savedir,'new_net', num2str(i, '%d'),'.mat'), 'new_net', 'info', '-v7.3')
save(strcat(savedir,'time_train_', num2str(i, '%d'), '.mat'), 'time_train', '-v7.3');

%%  softmax
tic
[testpred,probs] = classify(new_net, dataTest);
testactual = dataTest.Labels;
accuracy_fc = mean(testpred == testactual)
save(strcat(savedir,'accuracy_soft_fc', num2str(i, '%d'),'.mat'), 'accuracy_fc', 'testpred', 'testactual', 'probs', '-v7.3');
time_soft = toc
save(strcat(savedir,'time_soft_', num2str(i, '%d'), '.mat'), 'time_soft', '-v7.3');

end

end

end