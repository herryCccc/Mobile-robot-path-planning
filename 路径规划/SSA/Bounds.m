
% Application of simple limits/bounds
function s = Bounds( s, Xmin, Xmax)

% 保证粒子位置在界内
index = find(s > Xmax);
s(index) = randi(Xmax);
index = find(s < Xmin);
s(index) = randi(Xmax);
s = round(s);