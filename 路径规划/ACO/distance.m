function dis=distance(w,to_visit)
    n=20;
    if mod(w,n)==0
        r1=n;
    else
        r1=mod(w,n);
    end
    c1=ceil(w/n);
    if mod(to_visit,n)==0
        r2=n;
    else
       r2=mod(to_visit,n);
    end
    c2=ceil(to_visit/n);
    dis=((r1-r2)^2+(c1-c2)^2)^(1/2);
