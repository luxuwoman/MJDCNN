% joint making desicion

clc;
clear;
close all;

dataset_names = {'NWPU', 'OPTIMAL', 'UCMerced', 'RSSCN'};
num_iters = [5,10,20];

for h=1:length(dataset_names)   %dataset
    dataset_name = dataset_names{1,h};
    for k=1:3   %num_iters
        num_iter = num_iters(k)
        savedir = ['./lianhe/', dataset_name, '/', dataset_name, '_', num2str(num_iter, '%d'),...
            '_lianhe/'];
        mkdir(savedir);
        
alexnet_accuracy = [];
inv3_accuracy = [];
res18_accuracy = [];

accuracy_lianhe = [];

for i=1:10
    i
    
load(['./data_split/', dataset_name, '/traincvtest_', num2str(i, '%d'), '.mat']);

A = load(['./alexnet_data/',dataset_name, '_', '/', dataset_name, '_', num2str(num_iter, '%d'), '/',...
    'accuracy_soft_fc', num2str(i, '%d'),'.mat']);
B = load(['./inceptionv3_data/', dataset_name, '_', '/', dataset_name, '_', num2str(num_iter, '%d'), '/',...
    'accuracy_soft_fc', num2str(i, '%d'),'.mat']);
C = load(['./resnet18_data/', dataset_name, '_', '/', dataset_name, '_', num2str(num_iter, '%d'), '/',...
    'accuracy_soft_fc', num2str(i, '%d'), '.mat']);

alexnet_testpred = A.testpred;
inv3_testpred = B.testpred;
res18_testpred = C.testpred;
test_actual = A.testactual;

% 10 CNN accuracy
alexnet_accuracy = [alexnet_accuracy; A.accuracy_fc]; 
inv3_accuracy = [inv3_accuracy; B.accuracy_fc];
res18_accuracy = [res18_accuracy; C.accuracy_fc];

test_pred = [];

for a=1:length(dataTest.Files)
    if  A.testpred(a,1) ~= B.testpred(a,1) && A.testpred(a,1) ~= C.testpred(a,1) && B.testpred(a,1) ~= C.testpred(a,1)
        test_pred = [test_pred; C.testpred(a,1)];   
    elseif A.testpred(a,1) == B.testpred(a,1) && A.testpred(a,1) ~= C.testpred(a,1)
        test_pred = [test_pred; A.testpred(a,1)];
    elseif A.testpred(a,1) == C.testpred(a,1) && A.testpred(a,1) ~= B.testpred(a,1)
        test_pred = [test_pred; A.testpred(a,1)];
    elseif B.testpred(a,1) == C.testpred(a,1) && A.testpred(a,1) ~= B.testpred(a,1)
        test_pred = [test_pred; B.testpred(a,1)];
    else
        test_pred = [test_pred; C.testpred(a,1)];
    end
end

accuracy_fc = mean(test_pred == A.testactual);
accuracy_lianhe = [accuracy_lianhe; accuracy_fc];       %10 accuracy_lianhe

save(strcat(savedir,'accuracy_lianhe_', num2str(i, '%d'),'.mat'), 'test_pred', 'alexnet_testpred',...
    'inv3_testpred', 'res18_testpred', 'test_actual', '-v7.3');

end

accuracy_compare = [accuracy_lianhe*100, alexnet_accuracy*100, inv3_accuracy*100, res18_accuracy*100];

mean_accuracy = [mean(accuracy_lianhe*100), mean(alexnet_accuracy*100), mean(inv3_accuracy*100), mean(res18_accuracy*100)];
std_accuracy = [std(accuracy_lianhe*100), std(alexnet_accuracy*100), std(inv3_accuracy*100), std(res18_accuracy*100)];

save(strcat(savedir,'accuracy_lianhe.mat'), 'accuracy_lianhe', 'alexnet_accuracy', 'inv3_accuracy',...
    'accuracy_compare', 'mean_accuracy', 'std_accuracy', 'res18_accuracy', '-v7.3');


    end
end