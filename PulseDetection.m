close all;
%%ԭʼ�źŵĵ���
input=load('C:\Users\carelifead\Documents\cscw.csv');
input=input';
fs=200;

% ȥ��
Final = Denoising(input,fs);

%��ʾ
figure(1);
subplot(211);
plot(input); 
grid;
xlabel('ʱ�䣨ms��');ylabel('��ֵ');
title('ԭʼ�ź�');
subplot(212);
plot(Final);
grid;
xlabel('ʱ�䣨ms��');ylabel('��ֵ');
title('ȥ�����ź�');

% ������ȡ
[H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6] = FeatureExtraction(Final);

%��ʾ
figure(7);
title('��ֵͼ');
xlabel('ʱ��');ylabel('��ֵ');
grid;
plot(Final);
hold on;
xlabel('ʱ��');ylabel('��ֵ');
plot(T1, H1, 'r*');
plot(T2, H2, 'g+');
plot(T3, H3, 'g*');
plot(T4, H4, 'b+');
plot(T5, H5, 'b*');
plot(T6, H6, 'r+');
grid;
hold off;

% ��������
T = PulseCycleExtraction(T1);

% ��ʾ
disp ('�����źŵ�����T=')
disp(T)
figure(8);
stem(T);
grid on;
xlabel('������');ylabel('����ֵ');
title('��������');

% Other...

% ��ֵ��������ʾ
mp=mean(H1);
disp('��ֵ�ľ�ֵmp=')
disp(mp)
vp=var(H1);
disp('��ֵ�ķ���vp=')
disp(vp)
sp=std(H1);
disp('��ֵ�ı�׼��sp=')
disp(sp)
mT=mean(T);disp('���ھ�ֵmT=')
disp(mT)
vT=var(T);disp('���ڵķ���vT=')
disp(vT)
sT=std(T);disp('���ڵı�׼��sT=')
disp(sT)

%�źŵĹ����׹���
figure(9);
w=hanning(128);
nfft=1024;
noverlap=64;
[p,f]=spectrum(input,nfft,noverlap,w,200);
plot(f,p);
xlabel('Ƶ��(Hz)');
ylabel('������(dB)');
title('�źŵĹ�����ͼ');
xlim([0 50]);
[z,f1]=max(p);
disp('���������ֵz=')
disp(z)
disp('���ֵ��ӦƵ��f1=')
disp(f(f1))