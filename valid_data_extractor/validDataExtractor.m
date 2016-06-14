pulse_index = '20160114B\';
file=dir(['C:\Users\carelifead\Desktop\pulse\',pulse_index,'*.csv']);
for n=1:length(file)
    disp(file(n).name);
    if strcmp(file(n).name, 'right_18610260108_2016-1-14 15-21.csv') == 0
        %continue;
    end
    input = ['C:\Users\carelifead\Desktop\pulse\',pulse_index,file(n).name];
    output = ['C:\Users\carelifead\Desktop\pulse\result\',pulse_index,file(n).name];
    getResultFile(input,100,5,output);
    disp('end');
end