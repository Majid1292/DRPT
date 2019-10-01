% Programmed by Majid Afshar on 15/08/19
% Ph.D. Candidate
% Department of Computer Science
% Memorial University of Newfoundland
% mman23 [AT] mun [DOT] ca 

% Programmed by Hamid Usefi
% Associate Professor of Mathematics
% Department of Mathematics and Statistics
% Memorial University of Newfoundland
% usefi [AT] mun [DOT] ca | www.math.mun.ca/~usefi/

% Input: A dataset
% Output: Selected features and the resulting classification accuracy and also standard deviation of # of selected features and accuracies


warning off;
clear all;
global data;
%%================================Data Path=====================================
userName = char(java.lang.System.getProperty('user.name'));
OS = computer;

switch(OS)
    case 'GLNXA64'
        dir = 'home';
        
    case 'MACI64'
        dir = 'Users';
        
    case 'PCWIN64'
        dir = 'Users';
end

path = ['/', dir,'/', userName, '/Documents/datasets/'];
%=========================Classifiers and Datasets==============================
classifier{1} = 'svm';
classifier{2} = 'rf';
classifier{3} = 'dt';
classifier{4} = 'knn';

dataset{1} = 'GDS1615_full_NoFeature.csv'; 
dataset{2} = 'GDS3268_full_NoFeature.csv';   
dataset{3} = 'GDS968_full_NoFeature.csv';    
dataset{4} = 'GDS531_full_NoFeature.csv';
dataset{5} = 'GDS2545_full_NoFeature.csv';
dataset{6} = 'GDS1962_full_NoFeature.csv';
dataset{7} = 'GDS3929_full_NoFeature.csv';
dataset{8} = 'GDS2546_full_NoFeature.csv';     
dataset{9} = 'GDS2547_full_NoFeature.csv'; 

%%=============================Parameters==================================

clusters=50; %size of k
runIter = 10; %number of independent runs
t = 50;
classifier=classifier{1}; % select SVM as classifier
for n=2
    %==========================Reading Dataset=============================

    disp(['Loading ', dataset{n}, ' ...']);
    data = readLargeCSV(strcat(path, dataset{n}));
    data = data(randperm(size(data, 1)), :);
    orgData = data;

    %==========================Initialization=============================
    
    featuresPicked=zeros(clusters, runIter);
    eliteCluster = zeros(runIter, 4);
    max_acc=zeros(runIter, 2);
    F=cell(runIter);
   %==========================Data Prepration=============================
   tic
   for counter = 1:runIter
        data = data(randperm(size(data, 1)), :);
        trainIndex=[];
        labels=unique(data(:, end));
        for i=1:length(labels)
            indexLabels = find(data(:, end) == labels(i));
            trainSize = floor(.7 * length(indexLabels));
            indexLabels=indexLabels(randperm(length(indexLabels)));
            trainIndex=vertcat(indexLabels(1:trainSize, :),trainIndex);
        end
        trainIndex=trainIndex(randperm(length(trainIndex)));
        [r, ~] = size(data);
        data=data(trainIndex',:);
        fprintf("Run: %d,", counter);
        [r, c] = size(data);
        allF = c - 1;

        %==============================Variables===========================
        A = data(:,1:end-1);
        C=A;
        B = data(:,end);

        %============================Normalization=========================
        A = normc(A);

        %=========================Irrelevant removal=======================
        iA = pinv(A);
        X = iA * B;
        outliersLen=allF;
        listX=zeros(5, length(X));
        cleanedF=zeros(5, length(X));
        listX(1,:)=X;
        ii=1;
        while outliersLen>(allF*.021)
            outliers = isoutlier(abs(listX(ii,1:outliersLen)),'mean');
            tmp=find(outliers==1);
            outliersLen=length(tmp);
            cleanedF(ii,1:outliersLen)=tmp;
            ii=ii+1;
            listX(ii,1:outliersLen)=listX(ii-1,tmp);
        end
        if outliersLen<10
            TF = isoutlier(abs(X),'mean');
            outliersLen=sum(TF);
        end
        uniqueX=sort(unique(abs(X)),'descend');
        threshold=mean(uniqueX(1:outliersLen*10));
        cleanedF=1:allF;      
        while length(cleanedF)>(outliersLen*(2/(ii-1)))
            %cutoff = max(abs(X)) - (ii/100)* max(abs(X));
            irrF = find(abs(X) < threshold);
            irrF = [irrF, X(irrF)];
            irrF = sortrows(irrF, 2, 'descend');
            irrF = irrF(:, 1);
            %ii=ii-1;
            threshold=threshold*1.03;
            cleanedF = setxor([1:allF], irrF);
        end
        A=A(:,cleanedF');
        C=C(:,cleanedF');
        allF = length(cleanedF);
        
        %========================Perturbantion matrix======================
        svdA = svd(A);
        smallestAan = min(svdA);
        iA = pinv(A);
        X = iA * B;
        minPer = min(A) .* 10^-3 .* smallestAan;
        maxPer = max(A) .* 10^-2 .* smallestAan;
        s=3;
        mError =10^(-s)* smallestAan;
        perVal=zeros(r, allF);
        px=zeros(r, allF);
        parfor z=1:t
            perVal=mError.*rand(r, allF,1);
            nr=norm(perVal);
            pA = A + perVal;
            piA = pinv(pA);
            AB=iA-piA;
            N=AB'*AB;
            [Ve,Ei] = eig(N);
            B=Ve(:, end);
            B=B/norm(B);
            X = iA * B;
            Xtilda=piA * B;
            DX = abs(Xtilda - X);
            px(z, :)=DX;
        end
        
        pX = mean(px)';
        ent=real(-nansum(C'.*log(C'),2));
   %====================Sorting PX and Finding top ranked features====================
        pX=smooth(pX,'sgolay');
        uniquePX=length(unique(pX));
        roundMetric=20;
        roundedPX=pX;
        while uniquePX> 50
            roundedPX=round(pX,roundMetric);
            roundMetric=roundMetric-1;
            uniquePX=length(unique(roundedPX));
        end
        out=[];
        uniquekeys=unique(roundedPX);
        indexOut=1;
        for key=1:uniquePX
           selectedPX=find(roundedPX==uniquekeys(key)); 
           filteredEnt=ent(selectedPX);
           uniqueEnt=length(unique(filteredEnt));
           roundMetric=5;
           roundedEnt=filteredEnt;
           while uniqueEnt> 20
               roundedEnt=round(filteredEnt,roundMetric);
               roundMetric=roundMetric-1;
               uniqueEnt=length(unique(roundedEnt));
           end
           lenEnt=length(unique(roundedEnt));
           uniqueEnt=unique(roundedEnt);
           for index=1:lenEnt
              selectedEnt=find(roundedEnt==uniqueEnt(index));
              filteredX=X(selectedPX(selectedEnt));
              rankFilteredX=[selectedPX(selectedEnt),filteredX];
              sortedFilteredX=sortrows( rankFilteredX, 2, 'descend');
              out(indexOut)=sortedFilteredX(1,1);
              indexOut=indexOut+1;
           end
        end
        outEnt=ent(out');
        rankOutEnt=[out',outEnt];
        sortedRankOutEnt=sortrows( rankOutEnt, 2, 'ascend');
        sortedRankOutEnt=[(1:length(sortedRankOutEnt(:,1)))' sortedRankOutEnt];
        outX=X(out');
        rankOutX=[out',outX];
        sortedRankOutX=sortrows( rankOutX, 2, 'descend');
        sortedRankOutX=[(1:length(sortedRankOutX(:,1)))' sortedRankOutX];
        for i=1:length(sortedRankOutX(:,1))
            indexX=find(sortedRankOutEnt(i,2)==sortedRankOutX(:,2));
             sortedRankOutEnt(i,4)=indexX+sortedRankOutEnt(i,1);  
        end
        sortedRankOutEnt=sortrows( sortedRankOutEnt, 4, 'ascend');
        out=cleanedF(sortedRankOutEnt(:,2));
        upperBand = min(clusters, length(out));
       %===========================Classifiying============================
        best_result=zeros(3, 2); 
        data = orgData;
        [r, c] = size(data);
        m_acc=0;
        o_f=0;
        for k=2:upperBand
            centres = out(1:k);
            acc = cAcc([centres', c],classifier);
            if acc > m_acc 
                m_acc=acc;
                o_f=k;
                featuresPicked(1:k,counter)= out(1:k);
            end
            if m_acc==100 
                break; 
            end
        end
        max_acc(counter,1)=m_acc;
        max_acc(counter,2)= o_f;
        disp(['  SF = ', num2str(o_f), ', CA = ', num2str(m_acc),'%' ]);
        m_acc=0;
        fmt = 'Run %d : SF =  %2.2f ,  CA = %2.2f   \r\n';
   end
   fprintf("\n");
   toc
   fprintf("\n\n");
   o_acc = cAcc(1:c,classifier);
   ave_acc=mean(max_acc(:, 1));
   ave_f=mean(max_acc(:, 2));
   fprintf("\b\n");
   disp(['  |SF| = ', num2str(ave_f), ', CA = ', num2str(ave_acc),  ', CA(original) = ', num2str(o_acc), '%']);
   disp(['  SD of SF = ', num2str(std(max_acc(:, 2))), ', SD of CA = ', num2str(std(max_acc(:, 1))) ]);
end
