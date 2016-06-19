% fileVisual is the valid data segement file from Visual test by human
% being; fileResult is valid data segement file from program. These two
% files should be .csv file, and contain 4 columns, each row contains
% element number, amount of segaments, startpoint and endpoint of the
% segament.
function plotResult()
    fileResult = 'C:\Users\carelifead\Desktop\pulse\result\a\left_18600028729_2016-1-14 15-7.csv';
    input=load('C:\Users\carelifead\Desktop\pulse\a\left_18600028729_2016-1-14 15-7.csv');
    input =input';
   
    MatrixResult = int32(csvread(fileResult));
    
    [rowResult, colResult]=size(MatrixResult);

    indexMatrix=linspace(1,30,30);

    for ele = 1:30
        inputdata = input(ele+1,:);
        figure(1);
        plot(inputdata);
        hold on;
        ylim([0 350]);
        color = jet(5);
        for rowCount = 1:rowResult

             data = MatrixResult(rowCount,:);
             element=data(1);
             if element ~= ele
                 continue;
             end
             index = 1;
             if(element > 6)
                 index = 2;
                  if(element > 12)
                      index = 3;
                      if(element > 18)
                          index = 4;
                          if(element > 24)
                              index = 5;
                          end
                      end
                  end
             end
             y = indexMatrix(element)*10 + 2;
             plot([data(3) data(4)],[y y],'Color',color(index,:),'LineWidth',4);
        end
        hold off;
    end
   

    xlim([0,60000]);
    set(gca, 'GridLineStyle', '-');
    grid(gca,'minor');
    
    title(['Date: ',date,' ',fileResult]);
    
end