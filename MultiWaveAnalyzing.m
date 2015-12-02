close all;
%%原始信号的导入
input=load('C:\Users\carelifead\Desktop\pulse\ym.csv');
input=input';
fs=200;
averageHalfT = 75;
sizeInput = size(input);
averageAmplitude = zeros(1,sizeInput(1));

for i=1:1:sizeInput(1)
    % 数据平移，避免小于0的值
    inputdata = input(i,:);
    minH = min(inputdata);
    for j=1:1:length(inputdata)
        inputdata(j) = inputdata(j)-minH;
    end
    figure(1)
    plot(inputdata);
    % 有效数据提取
    [startPos, endPos] = ValidDataExtraction(inputdata);
    ValidData = inputdata(startPos+300:endPos-300);
    
    % 去噪
    
    figure(1);
    subplot(211);
    plot(inputdata);
    subplot(212);
    inputdata2 = zeros(1,length(inputdata));
    for xx=startPos+300:endPos-300
        inputdata2(xx)=inputdata(xx);
    end
    plot(inputdata2);
    continue;
    afterDenoising = Denoising(ValidData,fs);
    figure(2);
    plot(afterDenoising);

    % 对信号分类，有清晰波形的信号做基线拟合，特征提取
    % 没有清晰波形的信号只提取幅值和周期
    % 分类方法：找出所有极值点，如果平均一个周期内极值点数目>3.5，认为信号不清晰。
    [PMIN,TMIN,PMAX,TMAX,lpmin,ltmin,lpmax,ltmax] = FindExtremumValue(afterDenoising);
    isQualified = QualityDetection(PMIN, PMAX, lpmin, lpmax);
    %disp(isQualified);

    if isQualified == 1
        Final = BaselineFitting(afterDenoising, PMIN, TMIN);
    figure(1)
    subplot(211);
    plot(inputdata);
    subplot(212);
    plot(Final);
        % 特征提取
        [PMIN,TMIN,PMAX,TMAX,lpmin,ltmin,lpmax,ltmax] = FindExtremumValue(Final);
        [H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6] = FeatureExtraction(Final, PMIN,TMIN,PMAX,TMAX,lpmin,ltmin,lpmax,ltmax);

        % 平均幅值=(sum(H1))/H1.length 归一化后H6均为0
        averageAmplitude(i) = mean(H1) - mean(H6);

        % 周期序列
        T = PulseCycleExtraction(T1);
    else
        averageAmplitude(i) = mean(PMAX) - mean(PMIN);
    end
    disp(averageAmplitude(i));
end

t = 1:30;
figure(3);
plot(averageAmplitude);
hold on; 
plot(t, averageAmplitude, 'r*');
hold off;
%%Start extracting Pulse width and length using average Amplitude
for i=1:1:5 % 5行数据
    x = 1:1:6;
    y = averageAmplitude((i-1)*6+1:1:(i-1)*6+6);
    p= polyfit(x,y,2);
    zeroRoot = roots(p);
    disp(zeroRoot);
    width(i) = real(zeroRoot(1)-zeroRoot(2));
    
    xi=linspace(-1,8,100);
    z=polyval(p,xi);     %多项式求值函数
    figure(4);
    plot(x,y,'o',xi,z,'k:',x,y,'b');

end

figure(5);
plot(width);