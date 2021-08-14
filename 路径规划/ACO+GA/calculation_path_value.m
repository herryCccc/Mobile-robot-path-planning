function [path_value]=calculation_path_value(new_population)
n=size(new_population,2);
path_value=zeros(1,n);
for i=1:n
     single_population=new_population{i};
     m=size(single_population,2);
     for j=1:m-1
         dis=distance(single_population(j),single_population(j+1));
         path_value(i)=path_value(i)+dis;
     end
end



