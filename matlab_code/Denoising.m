function re = Denoising(resource, waveFrequency)
    %%ȥ������Ư��
    [C,L] = wavedec(resource,8,'sym8');%8��С���ֽ�
    A8=C(1:L(1)); 
    D8=C(L(1)+1:L(1)+L(2));%ȥ��ע�ͺ���Եõ�������ͼ3-5
    D7=C(L(1)+L(2)+1:L(1)+L(2)+L(3));
    D6=C(L(1)+L(2)+L(3)+1:L(1)+L(2)+L(3)+L(4));
    D5=C(L(1)+L(2)+L(3)+L(4)+1:L(1)+L(2)+L(3)+L(4)+L(5));
    D4=C(L(1)+L(2)+L(3)+L(4)+L(5)+1:L(1)+L(2)+L(3)+L(4)+L(5)+L(6));
    D3=C(L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+1:L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7));
    D2=C(L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7)+1:L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7)+L(8));
    D1=C(L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7)+L(8)+1:L(1)+L(2)+L(3)+L(4)+L(5)+L(6)+L(7)+L(8)+L(9));
    CC=zeros(size(C));
    CC(1:L(1))=A8;

    baseline = waverec(CC,L,'sym8');%ȥ��ϸ������DlһDg��õ��Ļ���Ư��
    x1 = resource - baseline;%ȥ������Ʈ�ƺ���ź�

    %%butter��ͨ�˲�
    Wp=[0.9 50]/500;Ws=[0.3 140]/500;
    [n,Wn] = buttord(Wp,Ws,3,10);
    [b,a] = butter(n,Wn);
    %freqz(b,a,512,waveFrequency);
    
    %%chebyȥ��50hz��Ƶ����
    Wp1=[30 65]/500;Ws1=[45 55]/500;
    rp=3;rs=60;
    [n1,Wn1] = cheb2ord(Wp1,Ws1,rp,rs);
    [b1,a1] = cheby2(n1,rs,Wn1,'stop');
    %freqz(b1,a1,512,waveFrequency);
    x2=filtfilt(b,a,x1);
    re=filtfilt(b1,a1,x2);
