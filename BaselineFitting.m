function re = BaselineFitting(resource)
    %三次样条插值-再次处理基线漂移
    %先求极小值
    PM=max(resource);
    MM=min(resource);
    G=(PM-MM)*0.3; %峰值大小波动范围不超过最大波形高度的0.3倍
    if min(resource(1:100))==min(resource(1:550))
        [P1(1),t1(1)]=min(resource(1:200));
        cnt1=1;
    elseif min(resource(1:100))~=min(resource(1:550))
        cnt1=0;
    end
    for i=51:length(resource)-50
        if resource(i)-MM < G && resource(i)==min(resource(i-50:i+50))
             P1(cnt1+1)=resource(i);
             t1(cnt1+1)=i;  
             cnt1=cnt1+1;
        end
    end
    %然后做插值
    xx = 1:1:length(resource);
    baseline=interp1(t1,P1,xx,'spline');
    re = resource-baseline;
end