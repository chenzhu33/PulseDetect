function re = Denoising(resource, waveFrequency)
    %%去除基线漂移
    [C,L] = wavedec(resource,8,'sym8');%8层小波分解
    A8=C(1:L(1)); 
    D8=C(L(1)+1:L(1)+L(2));%去掉注释后可以得到论文中图3-5
    D7=C(L(1)+L(2)+1:L(1)+L(2)+L(3));
    D6=C(L(1)+L(2)+L(3)+1:L(1)+L(2)+L(3)+L(4));
    D5=C(L(1)+L(2)+L(3)+L(4)+1:L(1)+L(2)+L(3)+L(4)+L(5));
    D4=C(L(1)+L(2)+L(3)+L(4)+L(5)+1:L(1)+L(2)+L(3)+L(4)+L(5)+L(6));
    D3=C(L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+1:L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7));
    D2=C(L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7)+1:L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7)+L(8));
    D1=C(L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7)+L(8)+1:L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7)+L(8)+L(9));
    CC=zeros(size(C));
    CC(1:L(1))=A8;

    baseline = waverec(CC,L,'sym8');%去除细节因子Dl一Dg后得到的基线漂移
    x1 = resource - baseline;%去除基线飘移后的信号

    %%butter带通滤波
    Wp=[0.9 50]/500;Ws=[0.3 140]/500;
    [n,Wn] = buttord(Wp,Ws,3,10);
    [b,a] = butter(n,Wn);
    freqz(b,a,512,waveFrequency);
    
    %%cheby去除50hz工频干扰
    Wp1=[30 65]/500;Ws1=[45 55]/500;
    rp=3;rs=60;
    [n1,Wn1] = cheb2ord(Wp1,Ws1,rp,rs);
    [b1,a1] = cheby2(n1,rs,Wn1,'stop');
    freqz(b1,a1,512,waveFrequency);
    x2=filtfilt(b,a,x1);
    A=filtfilt(b1,a1,x2);
    
    %三次样条插值-再次处理基线漂移
    %先求极小值
    PM=max(A);
    MM=min(A);
    G=(PM-MM)*0.3; %峰值大小波动范围不超过最大波形高度的0.3倍
    if min(A(1:100))==min(A(1:550))
        [P1(1),t1(1)]=min(A(1:200));
        cnt1=1;
    elseif min(A(1:100))~=min(A(1:550))
        cnt1=0;
    end
    for i=51:length(A)-50
        if A(i)-MM < G && A(i)==min(A(i-50:i+50))
             P1(cnt1+1)=A(i);
             t1(cnt1+1)=i;  
             cnt1=cnt1+1;
        end
    end

    %然后做插值
    xx = 1:1:length(A);
    B=interp1(t1,P1,xx,'spline');
    re = A-B;