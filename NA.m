function g = NA(f,s)
%NAFSM 用于处理椒盐噪声的二阶中值滤波器
%   f为输入的带噪声图像，s为窗口大小
[m,n] = size(f);%图像大小
N = zeros(m,n);%二值图像
for i = 1:m%确立二值图像N
    for j = 1:n
        if (f(i,j)==max(f(:))||f(i,j)==min(f(:)))
            N(i,j) = 0;
        else
            N(i,j) = 1;
        end
    end
end
G = zeros(m,n);%矩形窗
M = zeros(m,n);
for i = 1:1:m%计算矩形窗内各像素大小，并且求预恢复值M（i，j） 
    for j = 1:1:n
        W = zeros(s,s);%定义一个空的矩形窗
         for li=1:1:s
            for lj=1:1:s
                if (i+li-(s+1)/2)<=0||(j+lj-(s+1)/2)<=0||(i+li-(s+1)/2)>m||(j+lj-(s+1)/2)>n%判断是否超出原始图像范围
                    continue;
                end
                W(li,lj)=N(i+li-(s+1)/2,j+lj-(s+1)/2);%获取矩形窗内数据
            end
         end
         G(i,j)=sum(sum(W));
         z=s;
         for k=s:2:5
        if G(i,j)==0
            z=k+2;
            W1=zeros(z,z);%定义一个空的矩形窗
          for li=1:1:z
             for lj=1:1:z
                 if (i+li-(z+1)/2)<=0||(j+lj-(z+1)/2)<=0||(i+li-(z+1)/2)>m||(j+lj-(z+1)/2)>n%判断是否超出原始图像范围
                     continue;
                 end
                 W1(li,lj)=N(i+li-(z+1)/2,j+lj-(z+1)/2);%获取矩形窗内数据
             end
          end
          G(i,j)=sum(sum(W1));
          if G(i,j)==0
             continue;
          else
              break;
          end
        else
            break;
        end
        end
        if z==7&&i>1&&j>1&&i<m&&j<n
             M(i,j)=median([f(i-1,j-1) f(i,j-1) f(i+1,j-1) f(i-1,j)]);
           continue;
        end
        W2=zeros(1,G(i,j));
        nn=1;
        for i1=1:1:z
            for j1=1:1:z
                if (i+i1-(z+1)/2)<=0||(j+j1-(z+1)/2)<=0||(i+i1-(z+1)/2)>m||(j+j1-(z+1)/2)>n%判断是否超出原始图像范围
                    continue;      
                elseif N(i+i1-(z+1)/2,j+j1-(z+1)/2)==1
                    W2(nn)=f(i+i1-(z+1)/2,j+j1-(z+1)/2);
                    nn=nn+1;
                end
            end
        end
        M(i,j)=median(W2);
    end
end
D=zeros(m,n);
for i=1:1:m
    for j=1:1:n
        L=zeros(3,3);%定义一个m*n的矩形窗
        for li=1:1:3
            for lj=1:1:3
                if (i+li-(3+1)/2)<=0||(j+lj-(3+1)/2)<=0||(i+li-(3+1)/2)>m||(j+lj-(3+1)/2)>n%判断是否超出原始图像范围
                    continue;
                end
                L(li,lj)=f(i+li-(3+1)/2,j+lj-(3+1)/2);%获取矩形窗内数据
            end
        end
        d=zeros(1,9);
        ii=1;
        for i1=1:1:3
            for j1=1:1:3
                d(ii)=abs(L(i1,j1)-L(2,2));
                ii=ii+1;
            end
        end
        D(i,j)=max(d);
    end
end
F=zeros(m,n);
T1=20;%最低阈值
T2=60;%最高阈值
for i=1:1:m
    for j=1:1:n
        if D(i,j)<T1
            F(i,j)=0;
        elseif D(i,j)>=T1&&D(i,j)<T2
            F(i,j)=(D(i,j)-T1)/(T2-T1);
        else
            F(i,j)=1;
        end
    end
end
g=zeros(m,n);
for i=1:1:m
    for j=1:1:n
        g(i,j)=(1-F(i,j))*f(i,j)+F(i,j)*M(i,j);
    end
end
end

