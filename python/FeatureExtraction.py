import  numpy as np

def FeatureExtraction(resource, PMIN,TMIN,PMAX,TMAX,vmin,tmin,vmax,tmax):

    H1=PMAX;
    H6=PMIN;
    T1=TMAX;
    T6=TMIN;
    minExtremumLength = min(len(T1),len(T6));
    t3maxIndex = 0;
    t5minIndex = minExtremumLength;
    j=0;
    for i in range(0,minExtremumLength):
        while abs(T1[i] - tmax[j]) > 3 and j < tmax.size :
            j=j+1;

        if j+3 < minExtremumLength and i+1 < minExtremumLength and tmax[j+3]==T1[i+1]:
            t3maxIndex = max(t3maxIndex, tmax[j+1]-tmax[j]);
            t5minIndex = min(t5minIndex, tmax[j+2]-tmax[j]);

    thred = (t3maxIndex + t5minIndex) / 2;

    T2 = [0 for i in range(minExtremumLength)]
    T3 = [0 for i in range(minExtremumLength)]
    T4 = [0 for i in range(minExtremumLength)]
    T5 = [0 for i in range(minExtremumLength)]

    j=0;
    for i in range(0,minExtremumLength-1):
        while T1[i] != tmax[j] and j < tmax.size:
            j=j+1;

        k=j;
        while T1[i+1] != tmax[k] and k < tmax.size:
            k=k+1;

        T2[i] = 0;
        T3[i] = 0;
        T4[i] = 0;
        T5[i] = 0;
        if k-j == 1:
            x = 1;
        elif k-j == 2:
            if tmax[j+1] - tmax[j] < thred:
               T2[i]=tmin[j+1];
               T3[i]=tmax[j+1];
            else:
               T4[i]=tmin[j+1];
               T5[i]=tmax[j+1];

        elif k-j == 3:
            T2[i]=tmin[j+1];
            T3[i]=tmax[j+1];
            T4[i]=tmin[j+2];
            T5[i]=tmax[j+2];
        elif k-j >3:
            for x in range(j,k-1):
                if tmax[x] - tmax[j] < thred and T2[i] == 1:
                    T2[i]=tmin[x];
                    T3[i]=tmax[x];
                elif tmax[x] - tmax[j] >= thred and T4[i] == 1:
                    T4[i]=tmin[x];
                    T5[i]=tmax[x];

    H2=resource[T2];
    H3=resource[T3];
    H4=resource[T4];
    H5=resource[T5];

    return [H1,H2,H3,H4,H5,H6,T1,T2,T3,T4,T5,T6];