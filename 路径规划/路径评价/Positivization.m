
function [position_x] = Positivization(x,type)
    if type == 1  %指标为极小型
        position_x = Min2Max(x);  %调用Min2Max函数来正向化       
    elseif type == 2  %指标为中间型
        best = input('请输入中间型最佳值： ');
        position_x = Mid2Max(x,best);%调用Mid2Max函数来正向化
    elseif type == 3  %指标为区间型       
        a1 = input('请输入区间的下界： ');
        b1 = input('请输入区间的上界： '); 
        position_x = Inter2Max(x,a1,b1);%调用Inter2Max函数来正向化       
    else
        disp('指标类型输入错误')
    end
end
