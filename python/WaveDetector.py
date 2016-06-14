import numpy as np

from FindExtremumValue import FindExtremumValue
from FeatureExtraction import FeatureExtraction
from Denoising import denoising
from BaselineFitting import BaselineFitting
from QulityDetection import QualityDetection
from PulseCycleExtraction import PulseCycleExtraction
from ValidDataExtraction import ValidDataExtraction
from ValidDataExtraction import ValidDataReader
import os.path
from matplotlib.pyplot import plot
import matplotlib.pyplot as plt

PRE_FILTER = 3
NOISE_LEVEL = 2
WAVELET_LEVEL = 8


def get_average(width_list):
    average_width = 0
    width_length = 0
    for i in range(0, len(width_list)):
        if width_list[i] > 0:
            average_width += width_list[i]
            width_length += 1
    if width_length > 0:
        average_width /= width_length

    return average_width


def generate_data(filename):
    inputdata = np.loadtxt("../finalres/" + filename, delimiter=",")
    print("Now start:" + filename)

    h1List = []
    h2List = []
    h3List = []
    h4List = []
    h5List = []
    h6List = []

    t1List = []
    t2List = []
    t3List = []
    t4List = []
    t5List = []
    t6List = []

    averageAmplitude = np.zeros(inputdata.shape[1])

    T = np.zeros(inputdata.shape[1])
    for i in range(0, inputdata.shape[1]):
        wave = inputdata[:, i]
        minH = wave.min()
        for j in range(0, wave.size):
            wave[j] = wave[j] - minH
        if PRE_FILTER == 1:
            startPos, endPos = ValidDataExtraction(wave)
        elif PRE_FILTER == 2:
            startPos, endPos = ValidDataReader(wave)
        else:
            startPos = 0
            endPos = wave.size
        validData = wave[startPos:endPos]

        # plt.close('all');
        # plt.subplot(211);
        # plot(validData);

        # if len(validData) < 3000:
        #     print("Wave %d too short"%(i));
        #     level = -1;
        #     continue;

        afterDenoising = denoising(validData, NOISE_LEVEL, WAVELET_LEVEL);
        [PMIN, TMIN, PMAX, TMAX, lpmin, ltmin, lpmax, ltmax] = FindExtremumValue(afterDenoising);
        # plt.subplot(212);
        # plot(afterDenoising);
        isQualified = QualityDetection(PMIN, PMAX, lpmin, lpmax);
        if isQualified == 1:
            afterFitting = BaselineFitting(afterDenoising, PMIN, TMIN);
            afterFitting = afterFitting[TMIN[0]:TMIN[len(TMIN) - 1]];

            [PMIN, TMIN, PMAX, TMAX, lpmin, ltmin, lpmax, ltmax] = FindExtremumValue(afterFitting);

            # plt.subplot(212);
            # plot(afterFitting);
            # plot(ltmin,lpmin,'*');
            # plot(ltmax,lpmax,'.');

            [H1, H2, H3, H4, H5, H6, T1, T2, T3, T4, T5, T6] = FeatureExtraction(afterFitting, PMIN, TMIN, PMAX, TMAX,
                                                                                 lpmin, ltmin, lpmax, ltmax);

            h1List.append(H1)
            h2List.append(H2)
            h3List.append(H3)
            h4List.append(H4)
            h5List.append(H5)
            h6List.append(H6)

            t1List.append(T1)
            t2List.append(T2)
            t3List.append(T3)
            t4List.append(T4)
            t5List.append(T5)
            t6List.append(T6)

            # plot(T1,H1,'x');
            # plot(T2,H2,'+');
            # plot(T3,H3,'+');
            # plot(T4,H4,'*');
            # plot(T5,H5,'*');
            # plot(T6,H6,'x');

            averageAmplitude[i] = H1.mean() - H6.mean();
            T[i] = PulseCycleExtraction(T1).mean();
            print("Wave %d Cycle is: %f" % (i, T[i]));
            level = 1;
        else:
            averageAmplitude[i] = PMAX.mean() - PMIN.mean();
            T[i] = PulseCycleExtraction(PMAX).mean();
            level = 0;

    cycle = 0;
    num = 0;
    for t in range(0, inputdata.shape[1]):
        if T[t] > 1:
            cycle += T[t];
            num += 1;
    if num != 0:
        cycle = (cycle / num) / 200;
    else:
        cycle = 0;
    print("Average Wave Cycle %f" % cycle);

    fw = file("../results/" + filename, 'w')
    if len(h1List) == 0:
        print('Poor')
        fw.write('Poor data condition\n')
        return

    #####################Detail Width###############
    widthList = []
    minLength = h1List[0].size
    for i in range(0, len(h1List)):
        if minLength > h1List[i].size:
            minLength = h1List[i].size

    for j in range(0, minLength):
        try:
            x = np.arange(0, len(h1List), 1)
            y = []
            width = 0
            for i in range(0, len(h1List)):
                y.append(h1List[i][j])
            p = np.polyfit(x, y, 2)
            zeroRoot = np.roots(p)
            if zeroRoot.size >= 2:
                width = np.real(zeroRoot[0] - zeroRoot[1])
                if width < 0:
                    width = 0

                    # plt.close('all')
                    # plot(x,y,'x')
                    #
                    # xi = np.linspace(zeroRoot[1]-0.1,zeroRoot[0]+0.1,100)
                    # z = np.polyval(p,xi)
                    # plot(xi,z)

        except:
            width = 0

        widthList.append(width)

    ###############Output to file###################
    fw.write('Cycle,' + str(cycle) + '\n')


    #####################Average Width########################
    # averageWidth = 0
    # x = np.arange(0,len(h1List),1);
    # y = averageAmplitude[0:len(h1List)];
    # try:
    #     p= np.polyfit(x,y,2);
    #     zeroRoot = np.roots(p);
    #     if zeroRoot.size >= 2:
    #         averageWidth = np.real(zeroRoot[0]-zeroRoot[1]);
    #         if averageWidth < 0:
    #             averageWidth = 0;
    # except:
    #     averageWidth = 0
    # print("Average Width:"+str(averageWidth));
    # fw.write('Average Width,'+str(averageWidth)+'\n')


    #####################Average Width with filter########################
    averageWidth = get_average(widthList)
    for i in range(0, len(widthList)):
        if widthList[i] > averageWidth * 2:
            widthList[i] = 0
    averageWidth = get_average(widthList)
    print("Average Width:" + str(averageWidth))
    fw.write('Average Width,' + str(averageWidth) + '\n')

    #####################Average Width End################################

    fw.write('Width,')
    for i in range(0, len(widthList)):
        fw.write(',' + str(widthList[i]))
    fw.write('\n')

    #x = np.arange(0, minLength, 1)
    #y = np.arange(0, len(h1List), 1)
    #plt.close('all')
    #plot(x, widthList, 'x')
    #plot(x, widthList)

    for i in range(0, len(h1List)):
        H1 = h1List[i]
        H2 = h2List[i]
        H3 = h3List[i]
        H4 = h4List[i]
        H5 = h5List[i]
        H6 = h6List[i]
        T1 = t1List[i]
        T2 = t2List[i]
        T3 = t3List[i]
        T4 = t4List[i]
        T5 = t5List[i]
        T6 = t6List[i]

        fw.write('Point' + str(i) + ",H1,")
        for j in range(0, H1.size):
            if T1[j] != 0:
                fw.write('(' + str(H1[j]) + ' ' + str(T1[j]) + '),')
            else:
                fw.write(',')
        fw.write('\n')

        fw.write('Point' + str(i) + ",H2,")
        for j in range(0, H2.size):
            if T2[j] != 0:
                fw.write('(' + str(H2[j]) + ' ' + str(T2[j]) + '),')
            else:
                fw.write(',')
        fw.write('\n')

        fw.write('Point' + str(i) + ",H3,")
        for j in range(0, H3.size):
            if T3[j] != 0:
                fw.write('(' + str(H3[j]) + ' ' + str(T3[j]) + '),')
            else:
                fw.write(',')
        fw.write('\n')

        fw.write('Point' + str(i) + ",H4,")
        for j in range(0, H4.size):
            if T4[j] != 0:
                fw.write('(' + str(H4[j]) + ' ' + str(T4[j]) + '),')
            else:
                fw.write(',')
        fw.write('\n')

        fw.write('Point' + str(i) + ",H5,")
        for j in range(0, H5.size):
            if T5[j] != 0:
                fw.write('(' + str(H5[j]) + ' ' + str(T5[j]) + '),')
            else:
                fw.write(',')
        fw.write('\n')

        fw.write('Point' + str(i) + ",H6,")
        for j in range(0, H6.size):
            if T6[j] != 0:
                fw.write('(' + str(H6[j]) + ' ' + str(T6[j]) + '),')
            else:
                fw.write(',')
        fw.write('\n')

    fw.close()

    return averageWidth


if __name__ == "__main__":
    fw2 = file("../totalAnalysis.csv", 'w')
    fw2.write('FileName,AverageWidth\n')

    for parent, dirnames, filenames in os.walk("../finalres"):
        for filename in filenames:
            if not filename.endswith('csv'):
                continue
            #if not filename.startswith('right_18600429358_2016-1-14 13-20_3_2'):
            #    continue
            # if not filename.startswith('left_13141265458_2016-1-14 12-1_3_1'):
            #     continue;
            averageWidth = generate_data(filename)
            fw2.write(filename+','+str(averageWidth)+'\n')

    fw2.close()