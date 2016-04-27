def QualityDetection(PMIN, PMAX, lpmin, lpmax):
    percent = len(lpmax)/len(PMAX);
    if percent > 4 or percent < 2:
        quality = 0;
    else:
        quality = 1;

    return quality;
