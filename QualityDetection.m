function quality  = QualityDetection(PMIN, PMAX, lpmin, lpmax)
    %(����ֵ��/������Ŀ + ��Сֵ��/������Ŀ)/2=ƽ��ÿ�����ڵļ�ֵ��
    percent = (length(lpmax)/length(PMAX) + length(lpmin)/length(PMIN))/2;
    if percent > 3.5
        quality = 0;
    else
        quality = 1;
    end
