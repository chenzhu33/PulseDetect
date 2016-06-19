% fileVisual is the valid data segement file from Visual test by human
% being; fileResult is valid data segement file from program. These two
% files should be .csv file, and contain 4 columns, each row contains
% element number, amount of segaments, startpoint and endpoint of the
% segament.
function plotVerify(fileVisual, fileResult)
    
    MatrixVisual = int32(csvread(fileVisual));
    MatrixResult = int32(csvread(fileResult));
    
    [rowVisual , colVisual]=size(MatrixVisual);
    [rowResult, colResult]=size(MatrixResult);
    
%     indexMatrix=[0 1 12 13;
%     2 3 14 15;
%     4 5 16 17;
%     6 7 18 19;
%     8 9 20 21;
%     10 11 22 23];

    indexMatrix=[1 7 2 8 3 9 4 10 5 11 6 12 13 19 14 20 15 21 16 22 17 23 18 24];
    
    %plot lines for data from visual
    figure;
    hold on;
    for rowCount = 1:rowVisual
        data = MatrixVisual(rowCount,:);
        y = indexMatrix(data(1))*10;
        plot([data(3) data(4)],[y y],'-r','LineWidth',4);
    end
    ylim([0 250]);
    if nargin > 1
    %plot lines for data from program
     for rowCount = 1:rowResult
         data = MatrixResult(rowCount,:);
         y = indexMatrix(data(1))*10 + 2;
         plot([data(3) data(4)],[y y],'-b','LineWidth',4);
     end
    end
    xlim([0,10000]);
    set(gca, 'GridLineStyle', '-');
    grid(gca,'minor');
    
    title('2015-08-05');
%     rowCountV = 1;
%     rowCountR = 1;
%     
%     if (MatrixVisual(rowCountV,1) == MatrixResult(rowCountR,1))
%         for i = 1:MatrixVisual(rowCountV,2)
%             dataV = MatrixVisual(rowCountV+i-1,:);
%             dataR = MatrixResult(rowCountR,:);
%             if (compare(dataV, dataR) == 1)
%                 y = dataR(1)*0.5+1;
%                 plot([dataR(3) y],[dataR(4) y],'-b','LineWidth',5);
%             end
%         end
%         rowCountR = rowCountR+1;
%     else if (MatrixVisual(rowCountV,1) < MatrixResult(rowCountR,1))
%             rowCountV = rowCountV+1;
%         else rowCountR = rowCountR+1;
%         end
%     end
    
end