function path1=GenerateSmoothPath(path,G)  
  path1=path;
  long=size(path,1);
  i=1;
  while i~=long-2
      a1=path1(i,1);
      b1=path1(i,2);

      a3=path1(i+2,1);
      b3=path1(i+2,2);
      if a1<a3
          if all(G(a1:a3,b1:b3)==0)% && all(G(a1:a3,b3)==0) && all(G(a1:a3,ceil((b1+b3)/2))==0)
              path1(i+1,:)=[];
              i=i-1;
          end
      else
          if all(G(a3:a1,b1:b3)==0)% && all(G(a3:a1,b3)==0) && all(G(a3:a1,ceil((b1+b3)/2))==0)
              path1(i+1,:)=[];
              i=i-1;
          end
      end
      i=i+1;
      long=size(path1,1);
  end
    
