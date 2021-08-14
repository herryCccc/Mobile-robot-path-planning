function [position_x] = Inter2Max(x,a,b)
    row_x = size(x,1);
    M = max([a-min(x),max(x)-b]);
    position_x = zeros(row_x,1);  
    for i = 1: row_x
        if x(i) < a
           position_x(i) = 1-(a-x(i))/M;
        elseif x(i) > b
           position_x(i) = 1-(x(i)-b)/M;
        else
           position_x(i) = 1;
        end
    end
end

