function [new_population_1]=selection(new_population,fit_value)
n=size(new_population,2);
total_fit_value=sum(fit_value);
normal_fit_value=fit_value/total_fit_value;
cum_normal_fit_value=cumsum(normal_fit_value);
ms=sort(rand(1,n));
fitin=1;
newin=1;
while newin<=n
    if (ms(newin))<cum_normal_fit_value(fitin)
        new_population_1{newin}=new_population(fitin);
        newin=newin+1;
    else
        fitin=fitin+1;
    end
end



