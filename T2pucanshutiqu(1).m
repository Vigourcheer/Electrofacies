clc
clear
num=xlsread('QHD-I24s1_nmr.xlsx');
[r1,c1]=size(num);
r=r1-1;
c=c1-1;
%T2D为T2布点，T2 distribution
T2D=num(1,2:c1);
%T2SP为T2谱，T2 spectrum
T2SP=num(2:r1,2:c1);
%T2min最小弛豫时间
T2LEIJIAMIN=cumsum(T2SP,2);
for i=1:r
    for j=1:c-1
        if T2LEIJIAMIN(i,1)~=0
            T2minp(i,1)=T2D(1,1);
        else
            T2minp(i,1)=T2D(1,2);
        end
        if T2LEIJIAMIN(i,j+1)==0
            T2minp(i,j+1)=T2D(1,j+2);
        else
            T2minp(i,j+1)=0;
        end
    end
end
T2min=max(T2minp,[],2);
%将T2谱倒换，同最小弛豫时间，求最大弛豫时间
for i=1:r
    for j=1:c
        T2SPD(i,j)=T2SP(i,c-j+1);
        T2DD(1,j)=T2D(1,c-j+1);
    end
end
%T2max最大弛豫时间
T2LEIJIAMAX=cumsum(T2SPD,2);
for i=1:r
    for j=1:c-1
        if T2LEIJIAMAX(i,1)~=0
            T2maxp(i,1)=T2DD(1,1);
        else
            T2maxp(i,1)=T2DD(1,2);
        end
        if T2LEIJIAMAX(i,j+1)==0
            T2maxp(i,j+1)=T2DD(1,j+2);
        else
            T2maxp(i,j+1)=100000;
        end
    end
end
T2max=min(T2maxp,[],2);
%porT2为核磁孔隙度
porT2=T2LEIJIAMIN(:,c);
%T2half半弛豫时间
T2chazhi50=zeros(r,c);
for i=1:r
    for j=1:c
    T2chazhi50(i,j)=T2LEIJIAMIN(i,j)-0.5*porT2(i,1);
    end
end
T2cha=abs(T2chazhi50);
chazhimin=min(T2cha,[],2);
for i=1:r
    for j=1:c
        if T2cha(i,j)==chazhimin(i,1)
            T2halfp(i,j)=T2D(1,j);
        else
            T2halfp(i,j)=0;
        end
    end
end
T2half=max(T2halfp,[],2);
%T2R35、R65
T2chazhi35=zeros(r,c);
T2chazhi65=zeros(r,c);
for i=1:r
    for j=1:c
    T2chazhi35(i,j)=T2LEIJIAMIN(i,j)-0.35*porT2(i,1);
    T2chazhi65(i,j)=T2LEIJIAMIN(i,j)-0.65*porT2(i,1);
    end
end
T2cha35=abs(T2chazhi35);
chazhimin35=min(T2cha35,[],2);
T2cha65=abs(T2chazhi65);
chazhimin65=min(T2cha65,[],2);
for i=1:r
    for j=1:c
        if T2cha35(i,j)==chazhimin35(i,1)
            T2R35p(i,j)=T2D(1,j);
        else
            T2R35p(i,j)=0;
        end
    end
end
for i=1:r
    for j=1:c
        if T2cha65(i,j)==chazhimin65(i,1)
            T2R65p(i,j)=T2D(1,j);
        else
            T2R65p(i,j)=0;
        end
    end
end
T2R35=max(T2R35p,[],2);
T2R65=max(T2R65p,[],2);
%T2pormax谱峰弛豫时间
T2pormaxp=max(T2SP,[],2);
for i=1:r
    for j=1:c
        if T2SP(i,j)==T2pormaxp(i,1)
            T2pormaxpp(i,j)=T2D(1,j);
        else
            T2pormaxpp(i,j)=0;
        end
    end
end
T2pormax=max(T2pormaxpp,[],2);
%S1、S2、S3不同尺寸孔隙组分在的孔隙量
S1=zeros(r,1);
S2=zeros(r,1);
S3=zeros(r,1);
%ss1、ss2为计算区间孔隙分量划分的布点位置，需要自行查找和更改
% ss1=83;
% ss2=117;
ss1=7;
ss2=14;
% %6=3ms，13=33ms
%%%——————————————————需修改位置
% ss1=6;
% ss2=13;
%%%———————————————————————
for i=1:r
    for j=1:ss1
        S1(i,1)=S1(i,1)+T2SP(i,j);
    end
end
for i=1:r
    for j=ss1+1:ss2
        S2(i,1)=S2(i,1)+T2SP(i,j);
    end
end
for i=1:r
    for j=ss2+1:c
        S3(i,1)=S3(i,1)+T2SP(i,j);
    end
end
%S1PER S1 percentage 表示不同孔隙量占总孔隙的百分含量。
S1PER=S1./porT2;
S2PER=S2./porT2;
S3PER=S3./porT2;
%porT2max 最大孔隙分量
porT2max=max(T2SP,[],2);
%T2AVER T2 average T2均值
T2AVERP=zeros(r,1);
for i=1:r
    for j=1:c
        T2AVERP(i,1)=T2AVERP(i,1)+T2D(1,j).*T2SP(i,j);
    end
end
T2AVER=T2AVERP./porT2;
%T2GM T2gm T2几何均值
T2GMP=ones(r,1);
for i=1:r
    for j=1:c
        T2GMP(i,1)=T2GMP(i,1).*(T2D(1,j)^T2SP(i,j));
    end
end
T2GM=T2GMP.^(1./porT2);
%T2SD T2 Standard Deviation T2标准差
T2SDP=zeros(r,1);
for i=1:r
    for j=1:c
        T2SDP(i,1)=T2SDP(i,1)+T2SP(i,j)*power((T2D(1,j)-T2AVER(i,1)),2);
    end
end
T2SD=power((T2SDP./porT2),1/2);
%T2CV 变异系数  Coefficient of Variation
T2CV=T2SD./T2AVER;
%T2KG 峰度
T2KGP=zeros(r,1);
for i=1:r
    for j=1:c
        T2KGP(i,1)=T2KGP(i,1)+T2SP(i,j)*power((T2D(1,j)-T2AVER(i,1)),4);
    end
end
T2KG=T2KGP./(porT2.*power(T2SD,4));
%T2M T2 median T2孔隙中值
T2M=median(T2SP,2);
data1=cell(r+1,21);
title={'深度','核磁孔隙度','最小弛豫时间','最大弛豫时间','半弛豫时间','谱峰弛豫时间','S1','S2','S3','S1,%','S2,%','S3,%','最大孔隙分量','T2均值','T2几何均值','标准差','变异系数','峰度','T2中值','T2R35','T2R65'};
data2=zeros(r,21);
for i=1:r
    data2(i,1)=num(i+1,1);
    data2(i,2)=porT2(i,1);
    data2(i,3)=T2min(i,1);
    data2(i,4)=T2max(i,1);
    data2(i,5)=T2half(i,1);
    data2(i,6)=T2pormax(i,1);
    data2(i,7)=S1(i,1);
    data2(i,8)=S2(i,1);
    data2(i,9)=S3(i,1);
    data2(i,10)=S1PER(i,1);
    data2(i,11)=S2PER(i,1);
    data2(i,12)=S3PER(i,1);
    data2(i,13)=porT2max(i,1);
    data2(i,14)=T2AVER(i,1);
    data2(i,15)=T2GM(i,1);
    data2(i,16)=T2SD(i,1);
    data2(i,17)=T2CV(i,1);
    data2(i,18)=T2KG(i,1);
    data2(i,19)=T2M(i,1);
    data2(i,20)=T2R35(i,1);
    data2(i,21)=T2R65(i,1);
end
data2=num2cell(data2);
data1(1,:)=title;
data1(2:end,:)=data2;
xlswrite('QHD-I24s1_nmr（tizhi）.xlsx',data1);