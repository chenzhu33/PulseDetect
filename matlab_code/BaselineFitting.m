function re = BaselineFitting(resource, PMIN, TMIN)
    %����������ֵ-�ٴδ������Ư��
    xx = 1:1:length(resource);
    baseline=interp1(TMIN,PMIN,xx,'spline');
    re = resource-baseline;
end