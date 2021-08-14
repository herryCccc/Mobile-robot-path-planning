clc;clear
% load date_file;
A=cell2mat(struct2cell(load('en2.mat')));
[r,c]=size(A);
disp(['共用' num2str(r) '个评价对象，' num2str(c) '个评价指标'])
judge=input(['这' num2str(c) '个指标是否需要正向化处理，需要请输入1，不需要请输入0：']);
judge1=input('指标是否需要加权，需要请输入1，不需要请输入0.');
if judge1==1
    w=input('请输入各指标权重，用行向量输入：');
else
    w=ones(1,c)./c;
end
% 正向化
if judge==1
    position=input('请输入需要处理的指标所在列，例如需要处理1，2，3列则输入[1,2,3]:');
    disp('请输入需要处理指标所在列的类型，其中 1：为极小型 2：为中间型 3：为区间型')
    type=input('例如：第1列是中间型，第2列是区间型，第3列是极小型时输入[2,3,1]');
    for i=1:1:size(position,2)
        A(:,position(i))=Positivization(A(:,position(i)),type(i));
    end
    disp('正向化后的矩阵为A=')
    disp(A)
end
% 标准化
Z=A./repmat(sum(A.*A).^(1/2),r,1);
disp('正向矩阵标准化后矩阵Z= ')
disp(Z)
% 计算得分并归一化
D_PPP=sum(((repmat(max(Z),r,1)-Z).^2).*repmat(w,r,1),2).^1/2;
D_ddd=sum(((repmat(min(Z),r,1)-Z).^2).*repmat(w,r,1),2).^1/2;
S=D_ddd./(D_PPP+D_ddd);
disp('归一化得分为：')
S_norm=S/sum(S)
[sort_S,index]=sort(S_norm,'descend')


    
    