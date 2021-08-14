function [new_population_1]=crossover(new_population,p_crossover)
n=size(new_population,2);
parity=mod(n,2);
new_population_1={};
for i=1:2:n-1
    single_now_population=new_population{i};
    single_next_population=new_population{i+1};
    single_now_population=cell2mat(single_now_population);
    single_next_population=cell2mat(single_next_population);
    [lia,lib]=ismember(single_now_population,single_next_population);
    same=find(lia==1);
    length_same=size(same,2);
    if (rand<p_crossover)&&(length_same>2)
        r=round(rand*(length_same-3))+2;
        crossover_index1=same(r);  
        crossover_index2=lib(crossover_index1);
        new_population_1{i}=[single_now_population(1:crossover_index1),single_next_population(crossover_index2+1:end)];
        new_population_1{i+1}=[single_next_population(1:crossover_index2),single_now_population(crossover_index1+1:end)];
    else
        new_population_1{i}=single_now_population;
        new_population_1{i+1}=single_next_population;
    end
end
if parity==1
    new_population_1{n}=cell2mat(new_population{n});
end