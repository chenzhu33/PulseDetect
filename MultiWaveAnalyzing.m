close all;
%%原始信号的导入
input=load('C:\Users\carelifead\Documents\cscw.csv');
input=input';
fs=200;
averageAmplitude = zeros(1,input.length());
for i=1:1:input.length()
    % 去噪
    Final = Denoising(input(i),fs);

    % 特征提取
    [H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6] = FeatureExtraction(Final);

    % 平均幅值=(sum(H1))/H1.length 归一化后H6均为0
    averageAmplitude(i) = mean(H1);

    % 周期序列
    % T = PulseCycleExtraction(T1);
end

%%Start extracting Pulse width and length using average Amplitude
for i=1:1:5 % 5行数据
    for j=1:1:6 % 每行6个点阵
        
    end
end