function re = BaselineFitting(resource, PMIN, TMIN)
    %三次样条插值-再次处理基线漂移
    xx = 1:1:length(resource);
    baseline=interp1(TMIN,PMIN,xx,'spline');
    re = resource-baseline;
end