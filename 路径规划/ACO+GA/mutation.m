function [new_population_1]=mutation(new_population,p_mutation,G,r)
n=size(new_population,2);
new_population_1={};
for i=1:n
    single_new_population=cell2mat(new_population(i));
    m=size(single_new_population,2);
    single_new_population_slice=[];
    if (rand<p_mutation)
        mpoint=sort(round(rand(1,2)*(m-3))+[2 2]);
        single_new_population_slice=[single_new_population(mpoint(1)),single_new_population(mpoint(2))];
        single_new_population_slice=generate_continuous_path(single_new_population_slice,G,r);
        new_population_1(i)={[single_new_population(1:mpoint(1)),single_new_population_slice(1:end),single_new_population(mpoint(1)+1:end)]};
    else
        new_population_1(i)=new_population(i);
    end
end
    
