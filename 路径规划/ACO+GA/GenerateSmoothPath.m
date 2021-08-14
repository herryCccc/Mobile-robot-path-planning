function new_population_1=GenerateSmoothPath(path,G)  
  loong=size(path,2);
  for i=1:loong
      path1=path{i};
      long=size(path1,2);
      j=1;
      while j~=long-2
          [a1,b1]=position2rc(path1(j));
          [a3,b3]=position2rc(path1(j+2));
          if a1<a3
              if all(G(a1:a3,b1:b3)==0)% && all(G(a1:a3,b3)==0) && all(G(a1:a3,ceil((b1+b3)/2))==0)
                  path1(j+1)=[];
                  j=j-1;
              end
          else
              if all(G(a3:a1,b1:b3)==0)% && all(G(a3:a1,b3)==0) && all(G(a3:a1,ceil((b1+b3)/2))==0)
                  path1(j+1)=[];
                  j=j-1;
              end
          end
          j=j+1;
          long=size(path1,2);
      end
      new_population_1{i}=path1;
  end    
