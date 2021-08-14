clc
clear
G=[0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0; 
   0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0; 
   0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 1 1 1 1 0; 
   0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 1 1 1 1 0; 
   0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0; 
   0 0 1 1 0 0 1 1 0 0 0 0 0 1 1 1 0 0 0 0; 
   0 0 1 1 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0;
   0 0 1 1 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0; 
   0 0 1 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0; 
   0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 0; 
   0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 1 0; 
   0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 1 0; 
   0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 1 1 1 0; 
   0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0; 
   0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 1 1 0; 
   0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0; 
   0 0 1 1 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 0; 
   0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0;];
r=20;
for i=1:r
    for j=1:r
        if G(i,j)==1 
            x1=j-1;y1=r-i; 
            x2=j;y2=r-i; 
            x3=j;y3=r-i+1; 
            x4=j-1;y4=r-i+1; 
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],'r'); 
            hold on 
        else 
            x1=j-1;y1=r-i; 
            x2=j;y2=r-i; 
            x3=j;y3=r-i+1; 
            x4=j-1;y4=r-i+1; 
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]); 
            hold on 
        end 
    end 
end 
hold on 

path=[1,1;2,1;3,1;4,1;5,1;6,1;7,1;8,2;9,3;9,4;9,5;8,6;7,7;7,8;7,9;7,10;7,11;6,12;5,13;5,14;6,15;7,15;8,15;9,16;10,17;11,18;12,18;13,18;14,18;15,18;16,19;17,20;18,20;19,20;20,20];
L=size(path,1);
Sx=path(1,1)-0.5;
Sy=path(1,2)-0.5;
plot(Sx,Sy,'ro','MarkerSize',4,'LineWidth',4);   % Æðµã


Ex=path(end,1)-0.5;
Ey=path(end,2)-0.5;

plot(Ey,Ex,'gs','MarkerSize',4,'LineWidth',4);   % ÖÕµã

title('Results of SSA algorithm path planning in environment 2')

pic_num = 1;
for i=1:L-1
    plot([path(i,2) path(i+1,2)]-0.5,[path(i,1) path(i+1,1)]-0.5,'b+-','LineWidth',1.5,'markersize',4)
    hold on
    pause(0.5);
    figure(1);
    drawnow;
    F=getframe(gcf);
    I=frame2im(F);
    [I,map]=rgb2ind(I,256);
    if pic_num == 1
        imwrite(I,map,'test.gif','gif', 'Loopcount',inf,'DelayTime',0.5);
    else
        imwrite(I,map,'test.gif','gif','WriteMode','append','DelayTime',0.5);
    end
    pic_num = pic_num + 1;
end