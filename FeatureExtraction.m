function [H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6]=FeatureExtraction(resource)
    waveLength = length(resource);
    %�������ʾ��ֵ
    t = 0:waveLength-1;
    Lmax = diff(sign(diff(resource)))== -2; % logic vector for the local max value
    Lmin = diff(sign(diff(resource)))== 2; % logic vector for the local min value
    % match the logic vector to the original vecor to have the same length

    Lmax=circshift(Lmax,[0,2]);
    Lmin=circshift(Lmin,[0,2]);
    tmax = t (Lmax); % locations of the local max elements
    tmin = t (Lmin); % locations of the local min elements
    vmax = resource (Lmax); % values of the local max elements
    vmin = resource (Lmin); % values of the local min elements

    %��ò��� ÿ�����ڵ���ʼ���ǲ���
    sMax=max(resource);
    sEnd=min(resource);
    sG=(sMax-sEnd)*0.3; %��ֵ��С������Χ����������θ߶ȵ�0.3��
    if min(resource(1:100))==min(resource(1:550))
        [PMIN(1),TMIN(1)]=min(resource(1:200));
        cnt2=1;
    elseif min(resource(1:100))~=min(resource(1:550))
        cnt2=0;
    end
    for i=51:waveLength-50 
        if resource(i)-sEnd < sG && resource(i)==min(resource(i-50:i+50))
             PMIN(cnt2+1)=resource(i);
             TMIN(cnt2+1)=i;  
             cnt2=cnt2+1;
        end
    end

    %��ò���
    if max(resource(1:100))==max(resource(1:550))
        [PMAX(1),TMAX(1)]=max(resource(1:200));
        cnt3=1;
    elseif max(resource(1:100))~=max(resource(1:550))
        cnt3=0;
    end
    for i=51:waveLength-50
        if resource(i)-sMax < sG && resource(i)==max(resource(i-50:i+50))
             PMAX(cnt3+1)=resource(i);
             TMAX(cnt3+1)=i;  
             cnt3=cnt3+1;
        end
    end
    
    %С����0���⣬�����ط�ֵ
    % TODO
    %coefs = cwt(resource,9,'mexh');%ī����С���ֽ�
    %figure(11);
    %subplot(212);
    %plot(coefs);
    %grid;
    %xlabel('ʱ�䣨ms��');ylabel('��ֵ');
    %title('ī�������ź�');
    %subplot(211);
    %plot(resource);
    %grid;
    %xlabel('ʱ�䣨ms��');ylabel('��ֵ');
    %title('ԭʼ���ź�');

    %���ݷ�ֵ��ֵ��ʣ�༫ֵ����
    H1=PMAX;
    H6=PMIN;
    T1=TMAX;
    T6=TMIN;
    minExtremumLength = min(length(T1),length(T6));
    t3maxIndex = 0;
    t5minIndex = minExtremumLength;
    %Ѱ�Ҿ������Գ������ز��������ڣ���Ϊ��λ
    j=1;
    for i=1:minExtremumLength
        while(T1(i) ~= tmax(j)) 
            j=j+1;
        end
        if j+3 < minExtremumLength && i+1 < minExtremumLength && tmax(j+3)==T1(i+1)
            t3maxIndex = max(t3maxIndex, tmax(j+1)-tmax(j));
            t5minIndex = min(t5minIndex, tmax(j+2)-tmax(j));
        end
    end
    %��ö�λ��ֵ
    thred = (t3maxIndex + t5minIndex) / 2
    
    %��ʼ�����м�ֵ���࣬���TֵΪ1˵��û�����Եĳ������ز�����ֵ
    j=1;
    for i=1:minExtremumLength-1
        while(T1(i) ~= tmax(j)) 
            j=j+1;
        end
        k=j;
        while(T1(i+1) ~= tmax(k)) 
            k=k+1;
        end
        T2(i) = 1;
        T3(i) = 1;
        T4(i) = 1;
        T5(i) = 1;
        if k-j == 1
            %������û������
        elseif k-j == 2
            %ֻ��⵽һ��
            if tmax(j+1) - tmax(j) < thred
               %����
               T2(i)=tmin(j+1);
               T3(i)=tmax(j+1);
            else
               %�ز���
               T4(i)=tmin(j+1);
               T5(i)=tmax(j+1);
            end
        elseif k-j == 3
            %��⵽����
            T2(i)=tmin(j+1);
            T3(i)=tmax(j+1);
            T4(i)=tmin(j+2);
            T5(i)=tmax(j+2);
        elseif k-j >3
            %��⵽�����ֻ��¼���ֵ�ÿ�ֵ�һ��
            for x=j+1:k-1
                if tmax(x) - tmax(j) < thred && T2(i) == 1
                    %����
                    T2(i)=tmin(x);
                    T3(i)=tmax(x);
                elseif tmax(x) - tmax(j) >= thred && T4(i) == 1
                    %�ز���
                    T4(i)=tmin(x);
                    T5(i)=tmax(x);
                end
            end
        end
    end
    %��ö�Ӧ��ֵ
    H2=resource(T2);
    H3=resource(T3);
    H4=resource(T4);
    H5=resource(T5);