function getResultFile (dataFile, Fs, Seconds, outPutFile)
    data = csvread(dataFile,5,1);
    array=zeros(4, 4);
    len = 1;
    for i=1:30
        [x, count] = getEffectData(i, data, Fs, Seconds);
        if count==0
            continue;
        else
            for j=1:count
                for k=1:4
                    array(len,k)=x(j,k);
                end
                len = len+1;
            end
        end
    end
    csvwrite(outPutFile, array);
end
