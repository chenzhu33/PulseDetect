close all;
%%ԭʼ�źŵĵ���
input=load('C:\Users\carelifead\Desktop\pulse\ym.csv');
input=input';
fs=200;
averageHalfT = 75;
sizeInput = size(input);
averageAmplitude = zeros(1,sizeInput(1));

for i=1:1:sizeInput(1)
    % ����ƽ�ƣ�����С��0��ֵ
    inputdata = input(i,:);
    minH = min(inputdata);
    for j=1:1:length(inputdata)
        inputdata(j) = inputdata(j)-minH;
    end
    figure(1)
    plot(inputdata);
    % ��Ч������ȡ
    [startPos, endPos] = ValidDataExtraction(inputdata);
    ValidData = inputdata(startPos+300:endPos-300);
    
    % ȥ��
    
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

    % ���źŷ��࣬���������ε��ź���������ϣ�������ȡ
    % û���������ε��ź�ֻ��ȡ��ֵ������
    % ���෽�����ҳ����м�ֵ�㣬���ƽ��һ�������ڼ�ֵ����Ŀ>3.5����Ϊ�źŲ�������
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
        % ������ȡ
        [PMIN,TMIN,PMAX,TMAX,lpmin,ltmin,lpmax,ltmax] = FindExtremumValue(Final);
        [H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6] = FeatureExtraction(Final, PMIN,TMIN,PMAX,TMAX,lpmin,ltmin,lpmax,ltmax);

        % ƽ����ֵ=(sum(H1))/H1.length ��һ����H6��Ϊ0
        averageAmplitude(i) = mean(H1) - mean(H6);

        % ��������
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
for i=1:1:5 % 5������
    x = 1:1:6;
    y = averageAmplitude((i-1)*6+1:1:(i-1)*6+6);
    p= polyfit(x,y,2);
    zeroRoot = roots(p);
    disp(zeroRoot);
    width(i) = real(zeroRoot(1)-zeroRoot(2));
    
    xi=linspace(-1,8,100);
    z=polyval(p,xi);     %����ʽ��ֵ����
    figure(4);
    plot(x,y,'o',xi,z,'k:',x,y,'b');

end

figure(5);
plot(width);