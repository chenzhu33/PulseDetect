function [PMIN,TMIN,PMAX,TMAX,lpmin,ltmin,lpmax,ltmax] = FindExtremumValue(resource)
    waveLength = length(resource);
    %�������ʾ��ֵ
    t = 0:waveLength-1;
    Lmax = diff(sign(diff(resource)))== -2; % logic vector for the local max value
    Lmin = diff(sign(diff(resource)))== 2; % logic vector for the local min value
    % match the logic vector to the original vecor to have the same length

    Lmax=circshift(Lmax,[0,2]);
    Lmin=circshift(Lmin,[0,2]);
    ltmax = t (Lmax); % locations of the local max elements
    ltmin = t (Lmin); % locations of the local min elements
    lpmax = resource (Lmax); % values of the local max elements
    lpmin = resource (Lmin); % values of the local min elements

    averageHalfT = 75 - 25;
    
    %��ò��� ÿ�����ڵ���ʼ���ǲ���
    sMax=max(resource);
    sEnd=min(resource);
    sG=(sMax-sEnd)*0.4; %��ֵ��С������Χ����������θ߶ȵ�0.4��
    if min(resource(2:averageHalfT))-sEnd < sG && min(resource(2:averageHalfT)) == min(resource(1:averageHalfT*2))
        [PMIN(1),TMIN(1)]=min(resource(2:averageHalfT));
        cnt2=1;
    else
        cnt2=0;
    end
    for i=averageHalfT+1:waveLength-averageHalfT 
        if resource(i)-sEnd < sG && resource(i)==min(resource(i-averageHalfT:i+averageHalfT))
             PMIN(cnt2+1)=resource(i);
             TMIN(cnt2+1)=i;  
             cnt2=cnt2+1;
        end
    end
    
    %��ò���
    if sMax - max(resource(2:averageHalfT)) < sG && max(resource(2:averageHalfT)) == max(resource(1:averageHalfT*2))
        [PMAX(1),TMAX(1)]=max(resource(2:averageHalfT));
        cnt3=1;
    else
        cnt3=0;
    end
    for i=averageHalfT+1:waveLength-averageHalfT
        if sMax - resource(i) < sG && resource(i)==max(resource(i-averageHalfT:i+averageHalfT))
             PMAX(cnt3+1)=resource(i);
             TMAX(cnt3+1)=i;  
             cnt3=cnt3+1;
        end
    end
