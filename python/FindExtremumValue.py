import numpy as np


def FindExtremumValue(resource):
    waveLength = resource.size;
    t = np.arange(0,waveLength,1);

    Lmax = np.diff(np.sign(np.diff(resource))) == -2;
    Lmin = np.diff(np.sign(np.diff(resource)))== 2;
    Lmax = np.roll(Lmax, 1, 0);
    Lmin = np.roll(Lmin, 1, 0);
    Lmax[0] = False;
    Lmin[0] = False;
    ltmax = t[Lmax];
    ltmin = t[Lmin];
    lpmax = resource[Lmax];
    lpmin = resource[Lmin];
    if ltmin[0] > ltmax[0]:
        tmp = np.array([0]);
        ltmin = np.concatenate((tmp,ltmin));
        lpmin = np.concatenate((tmp,lpmin));

    averageHalfT = 75 - 25;

    sMax = resource.max();
    sEnd = resource.min();
    sG = (sMax-sEnd)*0.8;

    PMIN = [];
    TMIN = [];
    PMAX = [];
    TMAX = [];

    if resource[1:averageHalfT].min()-sEnd < sG and resource[1:averageHalfT].min() == resource[0:averageHalfT*2].min():
        PMIN.append(resource[0:averageHalfT].min());
        TMIN.append(resource[0:averageHalfT].argmin());

    for i in range(averageHalfT, waveLength-averageHalfT):
        if resource[i]-sEnd < sG and resource[i] == resource[i-averageHalfT:i+averageHalfT].min():
             PMIN.append(resource[i]);
             TMIN.append(i);

    if sMax - resource[1:averageHalfT].max() < sG and resource[1:averageHalfT].max() == resource[0:averageHalfT*2].max():
        PMAX.append(resource[0:averageHalfT].max());
        TMAX.append(resource[0:averageHalfT].argmax());

    for i in range(averageHalfT,waveLength-averageHalfT):
        if sMax - resource[i] < sG and resource[i] == resource[i-averageHalfT:i+averageHalfT].max():
            PMAX.append(resource[i]);
            TMAX.append(i);

    PMIN = np.array(PMIN);
    PMAX = np.array(PMAX);
    return [PMIN,TMIN,PMAX,TMAX,lpmin,ltmin,lpmax,ltmax];