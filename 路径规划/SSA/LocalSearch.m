function x = LocalSearch(x,Xmax,G)
dim = length(x);
fx = fitness(x,G);
for i = 1:dim
    newx = x;
    newx(i) = randi(Xmax);
    newfx = fitness(newx,G);
    if newfx < fx
        x = newx;
        fx = newfx;
    end
end