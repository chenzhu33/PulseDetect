function [H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6]=FeatureExtraction(resource, PMIN,TMIN,PMAX,TMAX,vmin,tmin,vmax,tmax)

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
        while(abs(T1(i) - tmax(j)) > 3 && j < length(tmax)+1) 
            j=j+1;
        end
        if j+3 < minExtremumLength && i+1 < minExtremumLength && tmax(j+3)==T1(i+1)
            t3maxIndex = max(t3maxIndex, tmax(j+1)-tmax(j));
            t5minIndex = min(t5minIndex, tmax(j+2)-tmax(j));
        end
    end
    %��ö�λ��ֵ
    thred = (t3maxIndex + t5minIndex) / 2;
    
    %��ʼ�����м�ֵ���࣬���TֵΪ1˵��û�����Եĳ������ز�����ֵ
    j=1;
    for i=1:minExtremumLength-1
        while(abs(T1(i) - tmax(j)) > 3 && j < length(tmax)+1) 
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