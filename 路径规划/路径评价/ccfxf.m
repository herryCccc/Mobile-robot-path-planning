clc;clear
disp('请输入判断矩阵A=')
A=input('A=');
[n,n]=size(A);
% 算术平均值法
C=sum(A,1);
disp('算术平均值法求出的权重为:')
one=sum(A./(repmat(C,n,1)),2)./n;
disp(one)
% 几何平均值法
D=prod(A,2);
stand_D=D.^(1/n);
disp('几何平均值法求出的权重为：')
two=stand_D./sum(stand_D);
disp(two)
% 特征值法
[x,z]=eig(A);
max_eig=max(max(z));
[r,c]=find(z==max_eig,1);
disp('特征值法求出的权重为：')
three=x(:,c)./(sum(x(:,c)));
disp(three)
% 三种方法得均值
disp('三种方法均值为：')
disp((one+two+three)/3)
% 一致性检验
ci=(max_eig-n)/(n-1);
ri=[0 0.0001 0.52 0.89 1.12 1.26 1.36 1.41];
cr=ci/ri(n)
if cr<0.1
    disp('通过一致性检验')
else
    disp('ci>=0.1,不通过一致性检验')
end

