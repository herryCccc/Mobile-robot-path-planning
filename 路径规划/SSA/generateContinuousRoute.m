function path=generateContinuousRoute(route,G)

Xmax = size(G,1);
dim = length(route);

path = [route(1) 1];
j=1;
f=1;
while j ~=dim&&f<200
    xa = route(j);
    xb = route(j+1);
    h = abs(xa - xb); % 两相邻栅格高度差
    if h == 0         % 两栅格位于同一行
        path = [path ; route(j+1) j+1];
    elseif h == 1     % 两栅格位于相邻行
        path = [path ; route(j+1) j+1];
    else
        k=0;
        while k==0
            if xa <= xb              % xa栅格位于xb栅格的下方
                if all(G(xa:xb,j) == 0)    % 第j行xa到xb全为自由栅格
                    path = [path; (xa+1:xb-1)' j*ones(h-1,1);route(j+1) j+1];
                    
                else     % 第j行xa到xb不全为自由栅格
                    w = xa;    % 第w个为xa到xb之间的第一个障碍栅格
                    for k = xa:xb
                        if G(k,j) == 1
                            w = k;
                            break
                        end
                    end
                    if  all(G(w:xb,j+1)==0)    % 第j+1列w到wb全为自由栅格
                         path = [path; (xa+1:w-1)' j*ones(w-xa-1,1);(w:xb)' (j+1)*ones(xb-w+1,1)];
                    else
                        mm=h;
                        while 1
                            
                            xb=xa+mm-1;
                            
                            if G(xb,j+1)==0
                                route(j+1)=xb;
                                break;
                            end
                            mm=mm-1;
                        end 
                        j=j-1;
                        continue;
                    end
                end
             
            else
                if all(G(xa:-1:xb,j) == 0)    % 第j行xa到xb全为自由栅格
                    
                        path = [path; (xa-1:-1:xb+1)' j*ones(h-1,1);route(j+1) j+1];
                
                else     % 第j行xa到xb不全为自由栅格
                    w = xa;    % 第w个为xa到xb之间的第一个障碍栅格
                    for k = xa:-1:xb
                        if G(k,j) == 1
                            w = k;
                            break
                        end
                    end
                    if  all(G(w:-1:xb,j+1)==0)    % 第j+1列w到wb全为自由栅格
                         path = [path; (xa-1:-1:w+1)' j*ones(xa-w-1,1);(w:-1:xb)' (j+1)*ones(w-xb+1,1)];
                    else
                        mm=h;
                       while 1
                           
                            xb=xa-mm+1;
                            if G(xb,j+1)==0
                                route(j+1)=xb;
                                break;
                            end
                            mm=mm-1;
                       end 
                       j=j-1;
                       continue;
                    end
                end
            end
            k=1;
        end
    end
    j=j+1;
    f=f+1;
end
if f>=200
    path=[];
end
    
    
    
    
    
    