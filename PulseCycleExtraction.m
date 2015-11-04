function T=PulseCycleExtraction(extremumList)
    j=1;
    for m = 2:length(extremumList)
        T(j) = extremumList(m) - extremumList(m-1);
        j=j+1;
    end