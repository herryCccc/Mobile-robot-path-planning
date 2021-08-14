function  [r,c]=position2rc(position)
         n=20;
         if mod(position,n)==0
             r=n;
         else
             r=mod(position,n);
         end
         c=ceil(position/n);




