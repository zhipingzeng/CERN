clear all
close all
clc

%% move the point
PixelNumber=360;

brightness=10;

% R2(37,58,1)=3; %main
x=35;
y=20+12; %plus 12 each for different targets
delta_x=36;
delta_y=28; %28
xx=35:delta_x:340;
l_x=length(xx);
yy=14:delta_y:340;
l_y=length(yy);
PointNumber=l_x*l_y;
R=zeros(PixelNumber,PixelNumber,PointNumber);
target_doughnut=zeros(PixelNumber,PixelNumber,PointNumber);
xxx=-1:0.01:1; %pixel size 10nm
PSFX=gaussmf(xxx,[0.05 0]);   %fwhm=223.8nm for 0.095
PSFXY=PSFX'*PSFX; 
T=R;
p=1;
% y2=y+24; %plus or minus 24
y2=y;


for x=35:delta_x:340
    nn=0;
    y_temp=y;
    y=y2;
    y2=y_temp;
    delta_y=28;   %delta_y
    r=8;%半径  中心孔9*20=180 nm
for j=1:l_y
    R(x,y+nn,p)=brightness;
        
%     r=8;%半径  中心孔9*20=180 nm
O=[x y+nn];%圆心
Bkground=zeros(ceil(2*r),ceil(2*r));%画布
dat=1/r;
for i=0:1:2*pi*r
%画图,加一是因为matlab的%数组就从1开始的.如a(1),没有a(0)
Bkground(int32(r*cos(i*dat))+O(1)+1,int32(r*sin(i*dat))+O(2)+1)=1;
end
rr=zeros(17);
[row3, col3] = find( Bkground > 0 );
num3 = size(row3, 1);  
for i = 1:1:num3                %改变标记密度
    rr(row3(i), col3(i)) = 1;     % 非零元素置一
    target_doughnut(row3(i), col3(i),p)=brightness;
end
doughnut=3*conv2(rr,PSFXY);  %生成doughnut

% figure(3),imshow(doughnut,[])
center=30;
rrr=zeros(num3);   %定义rrr大小
% figure,
% imshow(Bkground);
p=p+1;
%     delta_y = delta_y - 1;   % gradual change
    r = r - 0.25;   % gradual change - 0.2
    nn=nn+delta_y;
    
end
end

PointNumber2=PointNumber; %need adjust
Target=zeros(PixelNumber,PixelNumber);
T_doughnut=zeros(PixelNumber,PixelNumber);
for xx=1:PointNumber2
    Target=Target+R(:,:,xx);
    T_doughnut=T_doughnut+target_doughnut(:,:,xx);
end
figure(1)
imshow(Target,[])
figure(2)
imshow(T_doughnut,[])
% imwrite(uint16(Target),'C:\Zhiping Zeng\FUZHOU UNIV 2\FADIM\New simulation\target-doughnut.tif')
imwrite(uint16(T_doughnut),'C:\Zhiping Zeng\福州大学\福州大学\Fuzhou University\Publications\Fluctuation Assisted Difference Image Multiplication-FADIM\RawData-grid-7-新\bSOFI-SRRF-new\target-doughnut.tif')

%%
ZZ=zeros(PixelNumber,PixelNumber);
doughnut_conv=zeros(PixelNumber,PixelNumber);
% xx=-1:0.01:1; %pixel size 10nm
% PSFX=gaussmf(xx,[0.095 0]);   %fwhm=223.8nm for 0.095
% PSFXY=PSFX'*PSFX; 
for i=1:PointNumber2
T(:,:,i)=conv2(R(:,:,i),PSFXY,'same');
ZZ=ZZ+T(:,:,i);
X(:,:,i)=conv2(target_doughnut(:,:,i),PSFXY,'same');
doughnut_conv=doughnut_conv+X(:,:,i);
end
ZZ=imresize(ZZ,200/400);
doughnut_conv=imresize(doughnut_conv,200/400);
figure(3),
imshow(ZZ,[]);
figure(4),
imshow(doughnut_conv,[]);
% imwrite(uint16(ZZ*128),'C:\Zhiping Zeng\FUZHOU UNIV 2\FADIM\New simulation\image-doughnut.tif')
imwrite(uint16(doughnut_conv*128),'C:\Zhiping Zeng\福州大学\福州大学\Fuzhou University\Publications\Fluctuation Assisted Difference Image Multiplication-FADIM\RawData-grid-7-新\bSOFI-SRRF-new\image-doughnut.tif')
