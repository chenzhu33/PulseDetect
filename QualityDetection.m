function re = QualityDetection(resource)
    waveLength = length(resource);
    %差分求显示极值
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

    %求得波谷 每个周期的起始点是波谷
    sMax=max(resource);
    sEnd=min(resource);
    sG=(sMax-sEnd)*0.3; %峰值大小波动范围不超过最大波形高度的0.3倍
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

    %求得波峰
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
    
    figure(5);
    plot(PMAX, TMAX);
    
    %(极大值点/波峰数目 + 极小值点/波谷数目)/2=平均每个周期的极值点
    percent = (length(vmax)/length(PMAX) + length(vmin)/length(PMIN))/2;
    if percent > 3.5
        re = 0;
    else
        re = 1;
    end
end