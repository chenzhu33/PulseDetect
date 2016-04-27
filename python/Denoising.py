import pywt
import numpy as np
import scipy.signal as sci
import matplotlib.pyplot as plt

def denoising(resource, NOISE_LEVEL, WAVELET_LEVEL):
    try:
        C = pywt.wavedec(resource, 'sym8',level=WAVELET_LEVEL);

        # If the noise is not very large, then comment the following two lines
        if NOISE_LEVEL == 2:
            C[5] = np.zeros(C[5].size);
            C[6] = np.zeros(C[6].size);
            C[7] = np.zeros(C[7].size);
            C[8] = np.zeros(C[8].size);
        elif NOISE_LEVEL == 1:
            C[7] = np.zeros(C[7].size);
            C[8] = np.zeros(C[8].size);

        denoiseWave = pywt.waverec(C,'sym8');
        C2 = pywt.wavedec(denoiseWave, 'sym8',level=WAVELET_LEVEL);
        C2[1] = np.zeros(C2[1].size);
        C2[2] = np.zeros(C2[2].size);
        C2[3] = np.zeros(C2[3].size);
        C2[4] = np.zeros(C2[4].size);
        C2[5] = np.zeros(C2[5].size);
        C2[6] = np.zeros(C2[6].size);
        C2[7] = np.zeros(C2[7].size);
        C2[8] = np.zeros(C2[8].size);
        baseline = pywt.waverec(C2,'sym8');
        x1 = denoiseWave - baseline;

    except ValueError:
        C = pywt.wavedec(resource, 'sym8',level=WAVELET_LEVEL-1);
        # If the noise is not very large, then comment the following two lines
        if NOISE_LEVEL == 2:
            C[4] = np.zeros(C[4].size);
            C[5] = np.zeros(C[5].size);
            C[6] = np.zeros(C[6].size);
            C[7] = np.zeros(C[7].size);
        elif NOISE_LEVEL == 1:
            C[6] = np.zeros(C[6].size);
            C[7] = np.zeros(C[7].size);

        denoiseWave = pywt.waverec(C,'sym8');
        C2 = pywt.wavedec(denoiseWave, 'sym8',level=WAVELET_LEVEL-1);
        C2[1] = np.zeros(C2[1].size);
        C2[2] = np.zeros(C2[2].size);
        C2[3] = np.zeros(C2[3].size);
        C2[4] = np.zeros(C2[4].size);
        C2[5] = np.zeros(C2[5].size);
        C2[6] = np.zeros(C2[6].size);
        C2[7] = np.zeros(C2[7].size);
        baseline = pywt.waverec(C2,'sym8');
        x1 = denoiseWave - baseline;
        # plt.close('all')
        # plt.plot(x1)
        # plt.plot(resource)

    Wp=[0.9/500,50.0/500];
    Ws=[0.3/500,140.0/500];
    n, Wn = sci.buttord(Wp,Ws, 3, 10);
    b, a = sci.butter(n, Wn, 'bandpass');
    x2 = sci.filtfilt(b, a, x1);

    Wp1=[30.0/500,65.0/500];
    Ws1=[45.0/500,55.0/500];
    rp=3;
    rs=60;
    n1,Wn1 = sci.cheb2ord(Wp1,Ws1,rp,rs);
    b1,a1 = sci.cheby2(n1,rs,Wn1,'bandstop');
    re = sci.filtfilt(b1,a1,x2);

    return re;
