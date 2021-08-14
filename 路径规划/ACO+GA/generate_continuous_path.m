function [new_continuous_population]=generate_continuous_path(gene,G,r)
    i=1;
    new_continuous_population=gene;
    length_gene=size(new_continuous_population,2);
    max_interation=0;
    while i<length_gene
        [r_now,c_now]=position2rc(new_continuous_population(i));
        [r_next,c_next]=position2rc(new_continuous_population(i+1));

        while max(abs(r_now-r_next),abs(c_now-c_next))>1
            r_inset=floor((r_now+r_next)/2);
            c_inset=floor((c_now+c_next)/2);
            if G(r_inset,c_inset)==0
                number_inset=r_inset+(c_inset-1)*r;
                new_continuous_population=[new_continuous_population(1:i),number_inset,new_continuous_population(i+1:end)];
                max_interation=max_interation+1;
            else
                if (c_inset>1)&&(G(r_inset,c_inset-1)==0)&&((r_inset+(c_inset-2)*r)~=new_continuous_population(i))&&((r_inset+(c_inset-2)*r)~=new_continuous_population(i+1))
                    c_inset=c_inset-1;%%%向左走
                    number_inset=r_inset+(c_inset-1)*r;
                    new_continuous_population=[new_continuous_population(1:i),number_inset,new_continuous_population(i+1:end)];
                    max_interation=max_interation+1;
                elseif (c_inset<r)&&(G(r_inset,c_inset+1)==0)&&((r_inset+c_inset*r)~=new_continuous_population(i))&&((r_inset+c_inset*r)~=new_continuous_population(i+1))
                    c_inset=c_inset+1;%%%向右走
                    number_inset=r_inset+(c_inset-1)*r;
                    new_continuous_population=[new_continuous_population(1:i),number_inset,new_continuous_population(i+1:end)];
                    max_interation=max_interation+1;
                elseif (r_inset>1)&&(G(r_inset-1,c_inset)==0)&&((r_inset-1+(c_inset-1)*r)~=new_continuous_population(i))&&((r_inset-1+(c_inset-1)*r)~=new_continuous_population(i+1))
                    r_inset=r_inset-1;%%%向上走
                    number_inset=r_inset+(c_inset-1)*r;
                    new_continuous_population=[new_continuous_population(1:i),number_inset,new_continuous_population(i+1:end)];
                    max_interation=max_interation+1;
                elseif (r_inset<r)&&(G(r_inset+1,c_inset)==0)&&((r_inset+1+(c_inset-1)*r)~=new_continuous_population(i))&&((r_inset+1+(c_inset-1)*r)~=new_continuous_population(i+1))
                    r_inset=r_inset+1;%%%向下走
                    number_inset=r_inset+(c_inset-1)*r;
                    new_continuous_population=[new_continuous_population(1:i),number_inset,new_continuous_population(i+1:end)];
                    max_interation=max_interation+1;
                elseif (c_inset>2)&&(G(r_inset,c_inset-2)==0)&&((r_inset+(c_inset-3)*r)~=new_continuous_population(i))&&((r_inset+(c_inset-3)*r)~=new_continuous_population(i+1))
                    c_inset=c_inset-2;%%%向左走两步
                    number_inset=r_inset+(c_inset-1)*r;
                    new_continuous_population=[new_continuous_population(1:i),number_inset,new_continuous_population(i+1:end)];
                    max_interation=max_interation+1;
                elseif (c_inset<r-1)&&(G(r_inset,c_inset+2)==0)&&((r_inset+(c_inset+1)*r)~=new_continuous_population(i))&&((r_inset+(c_inset+1)*r)~=new_continuous_population(i+1))
                    c_inset=c_inset+2;%%%向右走两步
                    number_inset=r_inset+(c_inset-1)*r;
                    new_continuous_population=[new_continuous_population(1:i),number_inset,new_continuous_population(i+1:end)];
                    max_interation=max_interation+1;
                elseif (r_inset>2)&&(G(r_inset-2,c_inset)==0)&&((r_inset-2+(c_inset-1)*r)~=new_continuous_population(i))&&((r_inset-2+(c_inset-1)*r)~=new_continuous_population(i+1))
                    r_inset=r_inset-2;%%%向上走两步
                    number_inset=r_inset+(c_inset-1)*r;
                    max_interation=max_interation+1;
                    new_continuous_population=[new_continuous_population(1:i),number_inset,new_continuous_population(i+1:end)];
                elseif (r_inset<r-1)&&(G(r_inset+2,c_inset)==0)&&((r_inset+2+(c_inset-1)*r)~=new_continuous_population(i))&&((r_inset+2+(c_inset-1)*r)~=new_continuous_population(i+1))
                    r_inset=r_inset+2;%%%向下走两步
                    number_inset=r_inset+(c_inset-1)*r;
                    new_continuous_population=[new_continuous_population(1:i),number_inset,new_continuous_population(i+1:end)];
                    max_interation=max_interation+1;
                else
                    new_continuous_population=[];
                    break;
                end
            end
            r_next=r_inset;
            c_next=c_inset; 
            if max_interation>500
                new_continuous_population=[];
                break;
            end
        end
        if isempty(new_continuous_population)
            break;
        end
        length_gene=size(new_continuous_population,2);
        i=i+1;
    end
    if length(new_continuous_population)>100
        new_continuous_population=[];
    end
        

