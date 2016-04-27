import numpy as np

def ValidDataExtraction(data):
    datalen = data.size
    data.reshape(1,-1)
    win_len_vec = np.arange(140,161,1)
    slide_win_len = 200
    win_num = (datalen-10)//slide_win_len - 1
    thresh = 0.85
    pd_detect = np.zeros(win_num)
    max_win_num = 0
    start_win_num = 0
    cur_win_num = 0
    cur_start_win = 0
    for kk in range(0, win_num):
        cur_pos = kk * slide_win_len
        pos = 0
        result = np.zeros(win_len_vec.size)
        for win_len in win_len_vec:
            vec1 = data[cur_pos:cur_pos+slide_win_len]
            vec2 = data[cur_pos+win_len:cur_pos+win_len+slide_win_len]

            result[pos] = np.dot(vec1 , vec2) / np.sqrt(np.dot(vec1 , vec1)) / np.sqrt(np.dot(vec2 , vec2))
            pos += 1

        if result.max() > thresh:
            pd_detect[kk] = 1
            if cur_win_num:
                cur_win_num += 1
            else:
                cur_win_num = 1
                cur_start_win = kk

        elif cur_win_num > max_win_num:
            max_win_num = cur_win_num
            start_win_num = cur_start_win
            cur_win_num = 0
        else:
            cur_win_num = 0

    if cur_win_num > max_win_num:
        max_win_num = cur_win_num
        start_win_num = cur_start_win

    if max_win_num:
        startPos = start_win_num * slide_win_len
        endPos = (start_win_num+max_win_num)*slide_win_len

        data_res = data[startPos:endPos]
        res_len = data_res.size
        fft_len = res_len
        data_freq = abs(np.fft.fft(data_res, fft_len)/fft_len)
        data_freq = data_freq[0:fft_len/2]

        temp_pos = 0
        harmonic_pos = []
        for kk in range(1, 6):
            I = data_freq[temp_pos:data_freq.size].argmax(0)
            harmonic_pos.append(temp_pos+I);
            temp_pos = temp_pos+I+30
            if temp_pos > res_len:
                break

        single_freq = 60
        basefreq_thresh = 0.6
        if len(harmonic_pos) > 3:
            if data_freq[harmonic_pos[1]] < basefreq_thresh or (abs(harmonic_pos[1]-single_freq) > 25 and abs(harmonic_pos[2]-single_freq) > 15 ):
                startPos = 1
                endPos = 1
                return [startPos, endPos]
            elif len((data_freq>data_freq[harmonic_pos[1]]).nonzero()) >= 12:
                startPos = 1
                endPos = 1
                return [startPos, endPos]

            pd_vec = set()
            for tt in range(2, len(harmonic_pos)):
                single_freq = harmonic_pos[1]
                cur_pd = round(harmonic_pos[tt]/single_freq)
                if abs(harmonic_pos[tt]-cur_pd*single_freq) <= 25:
                    pd_vec.add(cur_pd);

            if len(pd_vec) < 2:
                startPos = 1
                endPos = 1
                return [startPos, endPos]

            return [startPos, endPos]
        else:
            startPos = 1
            endPos = 1
            return [startPos, endPos]

    else:
        startPos = 1
        endPos = 1
        return [startPos, endPos]


def ValidDataReader(data):
    startPos = 0;
    endPos = 0;
    maxLength = 0;
    rs = 0;
    re = 0;
    index = 0;
    while index < data.size-1:
        for i in range(endPos+1,data.size):
            index = i;
            if data[i] != 0:
                startPos = i;
                break;
        if index >= data.size - 1:
            break;
        for i in range(startPos+1,data.size):
            index = i;
            if data[i] == 0:
                endPos = i;
                break;

        length = endPos - startPos;
        if maxLength < length:
            maxLength = length;
            rs = startPos;
            re = endPos;


    return [rs, re];