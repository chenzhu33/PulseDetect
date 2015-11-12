Pclose all;
%%原始信号的导入
input=load('C:\Users\carelifead\Documents\czw.csv');
input=input';
fs=200;
sizeInput = size(input);
averageAmplitude = zeros(1,sizeInput(1));

for i=1:1:sizeInput(1)
    % 数据平移，避免小于0的值
    i = 13;
    inputdata = input(i,:);
    minH = min(inputdata);
    for j=1:1:length(inputdata)
        inputdata(j) = inputdata(j)-minH;
    end
    
    % 有效数据提取
    [startPos, endPos] = ValidDataExtraction(inputdata);
    inputdata(1:startPos) = 0;
    inputdata(endPos:length(inputdata)) = 0;
    ValidData = inputdata(startPos+100:endPos-100);
    
    % 去噪
    afterDenoising = Denoising(ValidData,fs);
    
    % 对信号分类，有清晰波形的信号做基线拟合，特征提取
    % 没有清晰波形的信号只提取幅值和周期
    % 分类方法：找出所有极值点，如果平均一个周期内极值点数目>3.5，认为信号不清晰。
    class = QualityDetection(afterDenoising);
    if class == 1
        Final = BaselineFitting(afterDenoising);
        % 特征提取
        %[H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6] = FeatureExtraction(Final);

        % 平均幅值=(sum(H1))/H1.length 归一化后H6均为0
        %averageAmplitude(i) = mean(H1);

        % 周期序列
        %T = PulseCycleExtraction(T1);
    else
        
    end

end

%%Start extracting Pulse width and length using average Amplitude
for i=1:1:5 % 5行数据
    for j=1:1:6 % 每行6个点阵
        
    end
end