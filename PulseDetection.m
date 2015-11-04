close all;
%%原始信号的导入
input=load('C:\Users\carelifead\Documents\cscw.csv');
input=input';
fs=200;

% 去噪
Final = Denoising(input,fs);

%显示
figure(1);
subplot(211);
plot(input); 
grid;
xlabel('时间（ms）');ylabel('幅值');
title('原始信号');
subplot(212);
plot(Final);
grid;
xlabel('时间（ms）');ylabel('幅值');
title('去噪后的信号');

% 特征提取
[H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6] = FeatureExtraction(Final);

%显示
figure(7);
title('极值图');
xlabel('时间');ylabel('极值');
grid;
plot(Final);
hold on;
xlabel('时间');ylabel('极值');
plot(T1, H1, 'r*');
plot(T2, H2, 'g+');
plot(T3, H3, 'g*');
plot(T4, H4, 'b+');
plot(T5, H5, 'b*');
plot(T6, H6, 'r+');
grid;
hold off;

% 周期序列
T = PulseCycleExtraction(T1);

% 显示
disp ('脉搏信号的周期T=')
disp(T)
figure(8);
stem(T);
grid on;
xlabel('脉搏数');ylabel('周期值');
title('周期序列');

% Other...

% 峰值的特征显示
mp=mean(H1);
disp('峰值的均值mp=')
disp(mp)
vp=var(H1);
disp('峰值的方差vp=')
disp(vp)
sp=std(H1);
disp('峰值的标准差sp=')
disp(sp)
mT=mean(T);disp('周期均值mT=')
disp(mT)
vT=var(T);disp('周期的方差vT=')
disp(vT)
sT=std(T);disp('周期的标准差sT=')
disp(sT)

%信号的功率谱估计
figure(9);
w=hanning(128);
nfft=1024;
noverlap=64;
[p,f]=spectrum(input,nfft,noverlap,w,200);
plot(f,p);
xlabel('频率(Hz)');
ylabel('功率谱(dB)');
title('信号的功率谱图');
xlim([0 50]);
[z,f1]=max(p);
disp('功率谱最大值z=')
disp(z)
disp('最大值对应频率f1=')
disp(f(f1))