clc
clear

n=input('the number of unit cell:\n');%选择元胞数量
M=input('unit cell\n');
D=input('间断点\n');
w=1;
E=zeros(D+1,2*M*n-(n-1));%构建初始值为0的数组
states=zeros(D+1,2*M*n-(n-1),2*M*n-(n-1));%三维矩阵

%研究范围是0<v/w<3
for j=1:1:D+1%从1到301
    v=(j-1)*0.01;%
    %构造哈密顿量
    H=zeros(2*M*n-(n-1),2*M*n-(n-1));
    %H(1,2)=v;%给矩阵中的元素赋值
    %H(2,1)=v;
    %H(2*n,2*n-1)=v^(1/2);%给矩阵中的元素赋值
    for c=1:1:n
        for i=1+(2*M-1)*(c-1):1:M+(2*M-1)*(c-1)
            H(i,i+1)=w;
            H(i+1,i)=w;
        end
        for i=(M+1)+(2*M-1)*(c-1):1:(2*M-1)+(2*M-1)*(c-1)
            H(i,i+1)=v^(1/M);
            H(i+1,i)=v^(1/M);
        end
    end
    for d=1:1:40
        H(1+(2*M-1)*(d-1),2*M+(2*M-1)*(d-1))=v^(1/M);
         H(2*M+(2*M-1)*(d-1),1+(2*M-1)*(d-1))=v^(1/M);
    end
    [states(j,:,:),V]=eigs(H,2*M*n-(n-1));%states(j,:,:)为第j行的所有元素和垂直于地面的三位平面上的所有元素，求解本征值和本征矢，函数具体用法可以看文档
    E(j,:)=diag(V);%将V的对角线元素输入进矩阵E
end

Eorder=sort(E,2);%对矩阵E的每一行元素额外排序，方便画图

v=0:0.01:D/100;
figure

subplot(2,3,[1,4]);%美化界面，画出本征值分布即能量随v/w的变化
hold on
for j=1:1:521
    plot(v,-Eorder(:,j));
end
hold off
xlabel('v/w');
ylabel('energy E');
title(['The spectrum of finite SSH model(n=',num2str(40),')']);


%画出v/w=0.5时两个能量最接近0的本征态分布
subplot(2,3,2);
bar(states(51,:,M*n-1));
title(['E=',num2str(E(51,M*n-1)),',v/w=0.5']);

subplot(2,3,3);
bar(states(51,:,M*n));
title(['E=',num2str(E(51,M*n)),',v/w=0.5']);

subplot(2,3,6);
bar(states(51,:,M*n-6));
title(['E=',num2str(E(51,M*n-6)),',v/w=0.5']);