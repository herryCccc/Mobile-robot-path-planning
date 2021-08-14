clc
clear
close all
tic
%% 地图
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
for i=1:20/2
    for j=1:20
        m=G(i,j);
        n=G(21-i,j);
        G(i,j)=n;
        G(21-i,j)=m;
    end
end
%% 
S = [1 1];   
E = [20 20];  
G0 = G;
G = G0(S(1):E(1),S(2):E(2)); 
[Xmax,dimensions] = size(G);        
dimensions = dimensions - 2;             

%% 参数设置
max_gen = 200;    % 最大迭代次数
num_polution = 50;         % 种群数量
soft_value = 0.8;        %安全值
recover_Percent = 0.3;  %%发现者比例
scout_Percent = 0.2;  %%侦查者比例
recover_Num = round( num_polution * recover_Percent );    % %发现者
scout_Num = round(num_polution * scout_Percent);      %%侦查者数量
X_min = 1;  

%% 初始化
X = zeros(num_polution,dimensions);
for i = 1:num_polution
    for j = 1:dimensions
       column = G(:,j+1);      % 地图的一列
       id = find(column == 0); % 该列自由栅格的位置
       X(i,j) =  id(randi(length(id))); % 随机选择一个自由栅格
       id = [];
    end 
    fit( i ) = fitness(X( i, : ),G);%%%行向量
end
fit_person_best = fit;   % 个体最优适应度
person_best = X;      % 个体最优位置
[fit_global_best, best_person_Index] = min( fit );        % 全局最优适应度
global_best = X(best_person_Index, : );    % 全局最优位置
[fit_max,B]=max(fit);
worse_person= X(B,:);  
%%
for gene = 1:max_gen
    gene
    [ans1,sort_Index] = sort(fit);   %适应值度从小到大排序
    [fit_max,B] = max(fit);
    worse_person = X(B,:);           %找出适应度最差的个体
    [~,Index] = sort(fit_person_best);
    r2 = rand(1);
    if r2 < soft_value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        for i = 1:recover_Num                                                  
            r1 = rand(1);  
            X(Index(i),:) = person_best(Index(i),:)*exp(-(i)/(r1*max_gen));         %%%%%发现者广泛进行搜索操作
            X(Index(i),:) = Bounds(X(Index(i),:), X_min,Xmax);                      %%%%输出整数路径
            fit(Index(i)) = fitness(X(Index(i),:),G);
        end
    else
            X(Index(i),:) = person_best(Index(i),:) + randn(1)*ones(1,dimensions);  %%%%%%%飞往其他地方觅食
            X(Index(i),:) = Bounds(X(Index(i),:),X_min,Xmax);    
            fit(Index(i)) = fitness(X(Index(i),:),G);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%发现者%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [fit_MMin,best_best] = min(fit);      
    best_best_bt = X(best_best,:);     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = (recover_Num+1):num_polution                   
        A = floor(rand(1,dimensions)*2)*2-1;                %%%%%%%%-1到1的随机数
        if(i>(num_polution/2))
            X(Index(i),:) = randn(1)*exp((worse_person-person_best(Index(i),:))/(i)^2);%%%%%%%适应度较低的个体没有获得食物，将飞往其他地方随机范围
        else
            X(Index(i),:) = best_best_bt+(abs((person_best(Index(i),:)-best_best_bt)))*(A'*(A*A')^(-1))*ones(1,dimensions); %%%%%%%中等适应度值的个体更新位置
        end
        X(Index(i),:) = Bounds(X(Index(i),:),X_min,Xmax);
        fit(Index(i)) = fitness(X(Index(i),:),G);
    end
    p_1 = randperm(numel(sort_Index));
    p_2 = sort_Index(p_1(1:scout_Num));
    for j = 1:length(p_2)     
        if(fit_person_best(Index(p_2(j)))>(fit_global_best))
            X(Index(p_2(j)),:) = global_best+(randn(1,dimensions)).*(abs((person_best(Index( p_2(j)),:) -global_best)));%%%%%%%%意识到危险的麻雀向种群适应度最高的个体靠拢
        else
            X(Index(p_2(j)),:) = person_best(Index(p_2(j)),:)+(2*rand(1)-1)*(person_best(Index(p_2(j)),:)-worse_person)/( fit_person_best(Index(p_2(j)))-fit_max+1e-50);
        end
        X(Index(j),:) = Bounds(X(Index(j),:), X_min, Xmax);
        fit(Index(j)) = fitness(X(Index(j),:),G);
    end
     for i=1:num_polution
         X(i,:) = Bounds(X(i,:),X_min,Xmax);
     end
    % 更新个体最优值和全局最优值
    for i = 1:num_polution
        if (fit(i)<fit_person_best(i))
            fit_person_best(i) = fit(i);
            person_best(i,:) = X(i,:);
        end
        if(fit_person_best(i) < fit_global_best)
            fit_global_best = fit_person_best(i);
            global_best = person_best(i,:);
        end
    end
    global_best = LocalSearch(global_best,Xmax,G);%%%%%把全局最优解进行局部搜索，提高全局最优解适应度值
    fit_global_best = fitness(global_best,G);
    final_goal(gene,1)=fit_global_best;
end
toc
%% 结果分析
global_best = round(global_best);
fit_global_best
figure(1)
plot(final_goal,'b-');
route = [S(1) global_best E(1)];
path=generateContinuousRoute(route,G);
% path=shortenRoute(path);
path=GenerateSmoothPath(path,G);
path=GenerateSmoothPath(path,G);
figure(2)
for i=1:20/2
    for j=1:20
        m=G(i,j);
        n=G(21-i,j);
        G(i,j)=n;  
        G(21-i,j)=m;
    end
end  
n=20;
for i=1:20
    for j=1:20
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
xlabel('Environment 1')
drawPath(path,G)




% set(gca,'FontSize',12);
% xlabel('Environment  2','fontsize',14,'fontname','Time New Roman');
% % drawPath(path,G)




% G=[0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
%    0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
%    0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
%    0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
%    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; 
%    0 1 1 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0; 
%    0 1 1 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0;
%    0 1 1 1 0 0 1 1 1 0 1 1 1 1 0 0 0 0 0 0; 
%    0 1 1 1 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0; 
%    0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0; 
%    0 0 0 0 0 0 0 1 1 0 1 1 1 1 0 0 0 0 0 0; 
%    0 0 0 0 0 0 0 1 1 0 1 1 1 1 0 0 0 0 0 0; 
%    0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
%    0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
%    1 1 1 1 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 0; 
%    1 1 1 1 0 0 1 1 0 0 0 1 0 0 0 0 0 0 0 0; 
%    0 0 0 0 0 0 1 1 0 1 1 1 0 0 0 0 0 1 1 0; 
%    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0; 
%    0 0 1 1 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 0; 
%    0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0;];



