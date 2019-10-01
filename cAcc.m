% Programmed by Majid Afshar on 15/08/19
% Ph.D. Candidate
% Department of Computer Science
% Memorial University of Newfoundland
% mman23 [AT] mun [DOT] ca 

% Input: Selected features and Classifier name
% Output: Classification accuracy using one of Support Vector Machine(SVM),
% Random Forest (RF),k-Nearest Neighbors (kNN) and Decision Tree (DT) classifiers
function clsOut = cAcc(selF,classifier)

%%================================Data spliting=====================================
global data;
data = data(randperm(size(data, 1)), :);
[r, ~] = size(data);
trainIndex=[];
labels=unique(data(:, end));
for i=1:length(labels)
    indexLabels = find(data(:, end) == labels(i));
    trainSize = floor(.7 * length(indexLabels));
    indexLabels=indexLabels(randperm(length(indexLabels)));
    trainIndex=vertcat(indexLabels(1:trainSize, :),trainIndex);
end
trainIndex=trainIndex(randperm(length(trainIndex)));
testIndex = setxor([1:r], trainIndex);
train = data(trainIndex', selF);
test = data(testIndex', selF);
nClass = length(unique(data(:, end)));

%%==============================Classifiers================================
switch(classifier)
    case 'dt' 
        Model = fitctree(train(:, 1:end-1), train(:, end));
        predicted = predict(Model, test(:, 1:end-1));
    case 'svm'    
        Model = fitcecoc(train(:, 1:end-1), train(:, end));
        predicted = predict(Model, test(:, 1:end-1));
    case 'knn'
        Model = fitcknn(train(:, 1:end-1), train(:, end));
        predicted = predict(Model, test(:, 1:end-1));
    case 'rf'
          Model= TreeBagger(30,train(:, 1:end-1), train(:, end),'Surrogate','on');
          predictedModel = predict(Model, test(:, 1:end-1));
          for i=1: length(predictedModel)
              charDigit=predictedModel{i};
              predicted(i,1)=str2num(charDigit);
          end
    otherwise
        Model = fitcecoc(train(:, 1:end-1), train(:, end));
        predicted = predict(Model, test(:, 1:end-1));
end

%%========================Classification Accuracy==========================
C = confusionmat(test(:, end), predicted);
term = diag(C) ./ sum(C, 2);
clsOut = 1/nClass * nansum(term) * 100;

return
