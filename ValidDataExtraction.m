function [startPos, endPos] = ValidDataExtraction(data)
    data4 = data';

    win_len_vec=110;%开窗长度，可以调节试试什么大小最合适
    pos=0;
    for win_len=win_len_vec
        pos=pos+1;
        vec1=data4(1:win_len).';
        vec2=data4(win_len+1:2*win_len).';
        result(pos,1)=sum(vec1.*vec2);
        for kk=win_len+1:length(data4)-win_len
            vec1=[vec1(2:end) data4(kk)];
            vec2=[vec2(2:end) data4(kk+win_len)];
            result(pos,kk-win_len+1)=sum(vec1.*vec2);
        end
    end

    %%根据相关结果求截取信号的位置
    mean_val=mean(result);%根据相关结果的平均值作为阈值
    start_temp=1;
    end_temp=1;
    isfind=0;
    start_pos=1;
    max_len=1;
    for ii=1:length(result)
        if result(ii)>=mean_val && isfind
            end_temp=ii;
        elseif result(ii)>=mean_val
            isfind=1;
            start_temp=ii;
            end_temp=ii;
        elseif isfind
            isfind=0;
            if(end_temp-start_temp>max_len)
                max_len=end_temp-start_temp;
                start_pos=start_temp;
            end
        end
    end
    startPos =start_pos+win_len_vec;
    endPos = start_pos+max_len;