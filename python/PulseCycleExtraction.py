import numpy as np
def PulseCycleExtraction(extremumList):
    j=1;
    T = np.zeros(len(extremumList)-1);
    for m in range(2,len(extremumList)):
        T[j] = extremumList[m] - extremumList[m-1];
        j=j+1;

    return T;