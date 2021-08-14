function smooth_value=calculation_smooth_value(new_population)
n=size(new_population,2);
smooth_value=zeros(1,n);
for i=1:n
    single_population=new_population{i};
    m=size(single_population,2);
    for j=3:1:m
        c=distance(single_population(j-2),single_population(j-1));
        a=distance(single_population(j-1),single_population(j));
        b=distance(single_population(j),single_population(j-2));
        angle=acos((a*a+c*c-b*b)/(2*a*c));
        if angle<pi/2
            smooth_value(i)=smooth_value(i)+500;
        elseif angle==pi/2
            smooth_value(i)=smooth_value(i)+20;
        else 
            smooth_value(i)=smooth_value(i)+4;
        end
    end
end

