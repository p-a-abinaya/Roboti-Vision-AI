%test  cnn
%img =readimage(imds,1);
%size(img)
numTrainFiles =762;
numTestFiles =254;
trainpath =fullfile('D:\Master files\ME5411\dataset\train');
testpath =fullfile('D:\Master files\ME5411\dataset\train');
imdsTrain =imageDatastore(trainpath,'IncludeSubfolders',true,'LabelSource','foldernames');
imdsTest =imageDatastore(testpath,'IncludeSubfolders',true,'LabelSource','foldernames');
%[imdsTrain,imdsValidation]=splitEachLabel(imds,numTrainFiles,'randomize');

taskpath =fullfile('D:\Master files\ME5411\dataset\task');
imdsTask =imageDatastore(taskpath,'IncludeSubfolders',true,'LabelSource','foldernames');

trainSetDetial =countEachLabel(imdsTrain);
testsetDetial =countEachLabel(imdsTest);

img =readimage(imdsTrain,1);
size(img)

layers =[
    imageInputLayer([128 128 1])

    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,64,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,128,'Padding','same')
    batchNormalizationLayer
    reluLayer

    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,256,'Padding','same')
    batchNormalizationLayer
    reluLayer

    dropoutLayer

    fullyConnectedLayer(7)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam',...
    'InitialLearnRate',0.001,...
    'MaxEpochs',9,... % 9 was best
    'Shuffle','every-epoch',...
    'ValidationData',imdsTest,...
    'ValidationFrequency',20,...
    'MiniBatchsize',64,... % 64 was best
    'Verbose',false,...
    'ExecutionEnvironment','auto',...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);

YPred = classify(net,imdsTest);
YTest = imdsTest.Labels;

accuracy = sum(YPred == YTest)/numel(YTest)

confMat = confusionmat(YTest,YPred);
MhelperDisplayConfusionMatrix(confMat)
plotconfusion(YTest,YPred);

% Task Predict
taskpath = fullfile('D:\ME5411\dataset dataset task');
imdsTask = imageDatastore(taskpath,'IncludeSubfolders',true,'LabelSource','foldernames');
YTaskpredict = classify(net,imdsTask);
YTrue = imdsTask.Labels;
% accuracy = sum(YTaskpredict == YTrue)/numel(YTrue)
