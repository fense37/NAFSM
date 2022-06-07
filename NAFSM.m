clc,clear,close all
%NAFSM滤波器和中值滤波器的比较
%建造于2022、6、2by王卓越
indir = 'pic\';
f = imread([indir '1.tif']);
%给图像添加不同程度的椒盐噪声
s = 1;m = 2*s+1;
I1 = imnoise(f,'salt & pepper',0.2);
I2 = imnoise(f,'salt & pepper',0.4);
I3 = imnoise(f,'salt & pepper',0.6);
I4 = imnoise(f,'salt & pepper',0.9);
%普通中值滤波处理
g1 = medfilt2(I1,[m m],'zeros');
g2 = medfilt2(I2,[m m],'zeros');
g3 = medfilt2(I3,[m m],'zeros');
g4 = medfilt2(I4,[m m],'zeros');
%NAFSM处理
gNA1 = uint8(NA(I1,s));
gNA2 = uint8(NA(I2,s));
gNA3 = uint8(NA(I3,s));
gNA4 = uint8(NA(I4,s));
%图像对比
figure(1)
subplot(2,2,1);imshow(f);title('原图')
subplot(2,2,2);imshow(I4);title('椒盐噪声图像')
subplot(2,2,3);imshow(g4);title('普通中值滤波')
subplot(2,2,4);imshow(gNA4);title('NAFSM')

print(1,'-dpng','-r500',[indir '90%.png']);