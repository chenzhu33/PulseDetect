function [ x, count ] = getEffectData( element, data, Fs, Seconds)
             
        
        y=data(:,element);
        y_length = length(y);

        i=1;
        add = Fs*Seconds;

        adj_left = 0.755;
        adj_right = 2.333;
        %adj_left = 0.5;
        %adj_right = 3.333;
        
        j=0;
        while i+add< y_length
            y_temp = y(i:i+add);
            L =length(y_temp);
             y_temp= y_temp - mean(y_temp);

            NFFT = 2^nextpow2(L); 
            Y2 = fft(y_temp,NFFT)/L;
            f= Fs/2*linspace(0,1,NFFT/2+1);

            temp2=abs(Y2(1:NFFT/2+1));
            m2=max(temp2);
            index2=find(temp2(:,1)==m2);

            f_max2 = f(1,index2);
            

            if f_max2 >= adj_left && f_max2 <= adj_right 
                temp2 = unique(temp2);
                value = temp2(end)*2 - temp2(end-1)*2;
                if value > 0.995
                    if j == 0
                        j=j+1;
                        result(j).begin = i;
                        result(j).end = i+add;
                    else
                        if i <= result(j).end
                            result(j).end = i+add;
                        else
                            j=j+1;
                            result(j).begin=i;
                            result(j).end = i+add;
                        end
                    end
                end
            end    
            crement = Fs;
            i = i+crement;
        end

        
        if j>0
            array = zeros(j,4);
             for i=1:j
                left = result(i).begin;
                right = result(i).end;

                array(i,1) = element;
                array(i,2) = j;
                array(i,3) = left;
                array(i,4) = right; 
             end   
             x  = array;
             count = j;
        else
            x = 0;
        	count = 0;
        end
end

