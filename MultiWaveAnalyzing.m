Pclose all;
%%ԭʼ�źŵĵ���
input=load('C:\Users\carelifead\Documents\czw.csv');
input=input';
fs=200;
sizeInput = size(input);
averageAmplitude = zeros(1,sizeInput(1));

for i=1:1:sizeInput(1)
    % ����ƽ�ƣ�����С��0��ֵ
    i = 13;
    inputdata = input(i,:);
    minH = min(inputdata);
    for j=1:1:length(inputdata)
        inputdata(j) = inputdata(j)-minH;
    end
    
    % ��Ч������ȡ
    [startPos, endPos] = ValidDataExtraction(inputdata);
    inputdata(1:startPos) = 0;
    inputdata(endPos:length(inputdata)) = 0;
    ValidData = inputdata(startPos+100:endPos-100);
    
    % ȥ��
    afterDenoising = Denoising(ValidData,fs);
    
    % ���źŷ��࣬���������ε��ź���������ϣ�������ȡ
    % û���������ε��ź�ֻ��ȡ��ֵ������
    % ���෽�����ҳ����м�ֵ�㣬���ƽ��һ�������ڼ�ֵ����Ŀ>3.5����Ϊ�źŲ�������
    class = QualityDetection(afterDenoising);
    if class == 1
        Final = BaselineFitting(afterDenoising);
        % ������ȡ
        %[H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6] = FeatureExtraction(Final);

        % ƽ����ֵ=(sum(H1))/H1.length ��һ����H6��Ϊ0
        %averageAmplitude(i) = mean(H1);

        % ��������
        %T = PulseCycleExtraction(T1);
    else
        
    end

end

%%Start extracting Pulse width and length using average Amplitude
for i=1:1:5 % 5������
    for j=1:1:6 % ÿ��6������
        
    end
end