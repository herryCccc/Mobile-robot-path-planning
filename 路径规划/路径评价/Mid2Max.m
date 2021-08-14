function [position_x] = Mid2Max(x,best)
    M = max(abs(x-best));
    position_x = 1 - abs(x-best) / M;
end

