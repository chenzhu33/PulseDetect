close all;
%%ԭʼ�źŵĵ���
input=load('C:\Users\carelifead\Documents\cscw.csv');
input=input';
fs=200;
averageAmplitude = zeros(1,input.length());
for i=1:1:input.length()
    % ȥ��
    Final = Denoising(input(i),fs);

    % ������ȡ
    [H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6] = FeatureExtraction(Final);

    % ƽ����ֵ=(sum(H1))/H1.length ��һ����H6��Ϊ0
    averageAmplitude(i) = mean(H1);

    % ��������
    % T = PulseCycleExtraction(T1);
end

%%Start extracting Pulse width and length using average Amplitude
for i=1:1:5 % 5������
    for j=1:1:6 % ÿ��6������
        
    end
end