function quality  = QualityDetection(PMIN, PMAX, lpmin, lpmax)
    %(极大值点/波峰数目 + 极小值点/波谷数目)/2=平均每个周期的极值点
    percent = (length(lpmax)/length(PMAX) + length(lpmin)/length(PMIN))/2;
    if percent > 3.5
        quality = 0;
    else
        quality = 1;
    end
