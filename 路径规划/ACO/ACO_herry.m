% 自己编程最优路径规划
% clear;clc
% close all;
tic
G=[0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
   0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
   0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
   0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
   0 1 1 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
   0 1 1 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0;
   0 1 1 1 0 0 1 1 1 0 1 1 1 1 0 0 0 0 0 0; 
   0 1 1 1 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 1 1 0 1 1 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 1 1 0 1 1 1 1 0 0 0 0 0 0; 
   0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
   0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
   1 1 1 1 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
   1 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0 0 0 0 0; 
   0 0 0 0 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0; 
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0; 
   0 0 1 1 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 0; 
   0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0;];

%地图矩阵
n=size(G,1);%n表示地图大小
m=50;    %% m 蚂蚁个数
Alpha=2;  %% Alpha 表征信息素重要程度的参数
Beta=6;  %% Beta 表征启发式因子重要程度的参数
Rho=0.1; %% Rho 信息素蒸发系数
NC_max=200; %%最大迭代次数
Q=1;         %%信息素增加强度系数
Tau=ones(n,n);     %Tau为信息素矩阵
NC=1;               %迭代计数器，记录迭代次数
r_e=1;  c_e=20;%地图终点在矩阵中的位置%可以通过position2rc函数产生
s=n;%路径起始点在矩阵中的位置
position_e=n*(n-1)+1;%路径终点在矩阵中的位置
min_PL_NC_ant=inf;%%蚂蚁最短的行进距离
min_ant=0;%%最短行进距离的蚂蚁坐标
min_NC=0;%%最短行进距离的迭代次数
% 计算邻接矩阵及启发因子%%邻接矩阵作用是计算启发因子
z=1;
for i=1:n
    for j=1:n
        if G(i,j)==0 
            D(i,j)=((i-r_e)^2+(j-c_e)^2)^0.5;
        else
            D(i,j)=inf;      %i=j时不计算，应该为0，但后面的启发因子要取倒数，用eps（浮点相对精度）表示
        end
    end
end
D(r_e,c_e)=0.05;
Eta=1./D;          %Eta为启发因子，这里设为到终点距离的倒数
Tau=10.*Eta;%%%%%创新点%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%计算移动矩阵
 D_move=zeros(n*n,8);%%D_move每一行代表与行标对应元素，可以前往的下一个节点的位置
 for point=1:n*n
     if G(point)==0
         [r,c]=position2rc(point);
         move=1;
         for k=1:n
             for m1=1:n
                 im=abs(r-k);
                 jn=abs(c-m1); 
                 if im+jn==1||(im==1&&jn==1) 
                     if G(k,m1)==0
                         D_move(point,move)=(m1-1)*n+k;
                         move=move+1;
                     end
                 end
             end
         end
     end 
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%移动矩阵和邻接矩阵计算完成，检查无误%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%开始迭代
routes=cell(NC_max,m);%%%%存储每次迭代每个蚂蚁的路径
PL=zeros(NC_max,m); %%%%%存储每次迭代每个蚂蚁的路径长度
while NC<=NC_max
    NC
    for ant=1:m
        current_position=s;%%%当前位置为起始点
        path=s;%%路径初始化
        PL_NC_ant=0;%%长度初始化
        Tabu=ones(1,n*n);   %%%%禁忌表，排除已经走过的位置
        Tabu(s)=0;%%排除已经走过的初始点
        D_D=D_move;%%%%D_D是D_move的中间矩阵，作用是为了不让D_move参与计算，也可不用D_D矩阵，直接用D_move
        D_work=D_D(current_position,:);%%%把当前点可以前往的写一个节点的信息传送给D_work
        nonzeros_D_work=find(D_work);%%%找到不为0的元素的位置
        for i1=1:length(nonzeros_D_work)
            if Tabu(D_work(i1))==0
                D_work(nonzeros_D_work(i1))=[];%%将禁忌表中已走过的元素删除，防止走已经走过的位置
                D_work=[D_work,zeros(1,8-length(D_work))];%%%保证D_work向量长度为8（每个点最多能往周围的8个点走），为后面for循环做准备
            end
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%排除走过的第一点（排除起点）%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        len_D_work=length(find(D_work));
        while current_position~=position_e&&len_D_work>=1%%当前点是否为终点或者走进死胡同
            p=zeros(1,len_D_work);
            for j1=1:len_D_work
                [r1,c1]=position2rc(D_work(j1));%%利用自己编的函数把可以前进的点计算为行列表示
                p(j1)=(Tau(r1,c1)^Alpha)*(Eta(r1,c1)^Beta);%%%%计算每个可以前往的节点的概率
            end
            p=p/sum(p);%%%归一化
            pcum=cumsum(p);%%%概率累加
            select=find(pcum>=rand);%%%%轮盘赌法选择下个节点
            to_visit=D_work(select(1));%%%前往下一个节点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%到达下一个节点%%%%%%%%%%%%%%%%%%%%%%%%
            path=[path,to_visit];%%%路径累加
            dis=distance(current_position,to_visit);%%%计算到下个节点的距离
            PL_NC_ant=PL_NC_ant+dis;%%距离累加
            current_position=to_visit;%%%当前点设为前往点
            D_work=D_D(current_position,:);%%%%把当前节点可以前往的下一个节点的信息传给D_work
            Tabu(current_position)=0;%%%禁忌表中排除已经到的点
            for kk=1:400
                if Tabu(kk)==0
                    for i3=1:8
                        if D_work(i3)==kk
                           D_work(i3)=[];%%%%排除禁忌表中已经走过的节点
                           D_work=[D_work,zeros(1,8-length(D_work))];%%保证长度为8
                        end
                    end
                end
            end
            len_D_work=length(find(D_work));%%%计算当前点可以前往的下一个节点的数量
        end
        %%%%%%%%%%%%%%%%%%%%%%%%迭代一次所有蚂蚁走完%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        routes{NC,ant}=path;%%%把蚂蚁走过的路径记录下来
        if path(end)==position_e
            z=z+1
            PL(NC,ant)=PL_NC_ant;%%记录到达终点的蚂蚁的行进距离
            if PL_NC_ant<min_PL_NC_ant
                min_NC=NC;min_ant=ant;min_PL_NC_ant=PL_NC_ant;%%记录路径最短的蚂蚁的迭代次数和属于那一只
            end
        else
            PL(NC,ant)=0;
        end
    end
    delta_Tau=zeros(n,n);%%%信息素变量初始化
    for j3=1:m
        if PL(NC,ant)
            rout=routes{NC,ant};
            tiaoshu=length(rout)-1;%%%找出到达终点蚂蚁前进的次数
            value_PL=PL(NC,ant);%%%%%%到达终点蚂蚁的行进距离
            for u=1:tiaoshu
                [r3,c3]=position2rc(rout(u+1));
                delta_Tau(r3,c3)=delta_Tau(r3,c3)+Q/value_PL;%%%%计算信息素变量的值
            end
        end
    end
    Tau=(1-Rho).*Tau+delta_Tau;%%%%信息素更新
    NC=NC+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%绘制收敛曲线%%%%%%%%%%%%%%%%%%%%%%%%%%%
min_PL=ones(NC_max,1);
for i=1:NC_max
    PL_1=PL(i,:);
    nonzero_PL_1=find(PL_1);%%%找到非零行进距离位置
    if isempty(nonzero_PL_1)
        min_PL(i)=min_PL(i-1);
    else
        min_PL(i)=min(PL_1(nonzero_PL_1));%%%找到第i次迭代中到达终点蚂蚁行进最短距离
    end
end
figure(1);
min(min_PL)
plot(min_PL);%%%%绘制收敛变化曲线
axis([0,200,0,100]) ;
hold on 
grid on 
title('收敛曲线变化趋势'); 
xlabel('迭代次数'); 
ylabel('最小路径长度');
%%%%%%%%%%%%%%%%%%% 绘制像素图%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
for i=1:n
    for j=1:n 
        if G(i,j)==1 
            x1=j-1;y1=n-i; 
            x2=j;y2=n-i; 
            x3=j;y3=n-i+1; 
            x4=j-1;y4=n-i+1; 
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],'r'); 
            hold on 
        else 
            x1=j-1;y1=n-i; 
            x2=j;y2=n-i; 
            x3=j;y3=n-i+1; 
            x4=j-1;y4=n-i+1; 
            fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]); 
            hold on 
        end 
    end 
end 
hold on 
grid on 
% title('机器人运动轨迹'); 
% xlabel('坐标x'); 
% ylabel('坐标y');
%%%%%%%%%%%%%%%%%%%%%%%%绘制最短路径路线图%%%%%%%%%%%%%%%%%%%%%%%%%%%
ROUTES=routes{min_NC,min_ant}; 
LENGTH_ROUTES=length(ROUTES);
RX=ROUTES;
RY=ROUTES;
for i=1:LENGTH_ROUTES
    RX(i)=ceil(ROUTES(i)/n)-0.5;
    RY(i)=n-mod(ROUTES(i),n)+0.5;
    if RY(i)==n+0.5
        RY(i)=0.5;
    end
end
plot(RX,RY,'gx-','LineWidth',1.5,'markersize',6);
plot(0.5,0.5,'ro','MarkerSize',4,'LineWidth',4);   % 起点
plot(19.5,19.5,'gs','MarkerSize',5,'LineWidth',5);   % 终点
toc
    
    

    
    
    
    
    
