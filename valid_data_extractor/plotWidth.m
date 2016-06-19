function plotWidth(datafile, startpoint, seconds, interval, Fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    rawData = csvread(datafile,5,1);
    for i=0:4
        data1 = rawData(:,6*i+1);
        data2 = rawData(:,6*i+2);
        data3 = rawData(:,6*i+3);
        data4 = rawData(:,6*i+4);
        data5 = rawData(:,6*i+5);
        data6 = rawData(:,6*i+6);
    
        data=[data1 data2 data3 data4 data5 data6]';
        x = 1:6;
        figure;
        hold on;
        for second = 1:seconds
            for lineNumber = 1:Fs
                plot(x,data(:,startpoint +(second-1)*Fs + (lineNumber-1)) + (lineNumber-1)*interval)
            end
            x=x+6;
        end
        title(['Column:',num2str(i+1)]);
    end
end

