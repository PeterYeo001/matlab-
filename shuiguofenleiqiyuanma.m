clc;
clear all;
img=imread('1.bmp');  
R=img(:,:,1);           %获取彩色图像的r值。
G=img(:,:,2);           %获取彩色图像的g值。
B=img(:,:,3);           %获取彩色图像的b值。
I2=rgb2gray(img);       %将图像灰度化。
figure,imshow(I2),title('灰度图像');
BW=im2bw(I2,0.9);       %将图像二值化。

SE=strel('rectangle',[40 30]);      % 结构定义
J2=imopen(BW,SE);                   % 进行开运算去除噪声和平滑边界
figure,imshow(J2),title('对二值图像进行开运算后的结果图像');
SE=strel('square',3);                % 定义3×3腐蚀结构元素
J=imerode(~J2,SE);                  %对图像进行腐蚀操作。
BW2=(~J2)-J;                         % 检测边缘


%填充了已有的检测的连续形状边界
B = imfill(BW2,'holes');            %对图像填充孔洞。
B = bwmorph(B,'remove');            %获得图像中区域边界。


%将不同的图形进行分别标记，num表示连接的图形对象的个数
[Label,num] = bwlabel(B);           %进行标记。
for i = 1 : num
    Area(i) = 0;
end
Label = imfill(Label,'holes');       %填充打过标记的边界线中间围成的图形区域


%计算各个图像的hsv颜色（色度）

HSV = rgb2hsv(img);                  %转换为HSV颜色模型。

[row,col] = size(Label);             %统计填充后的图形中各块图形所含像素的个数的多少
MeanHue = zeros(1,num);             %初始化
    for i = 1 : num
        Hue = zeros(Area(i),1);     %初始化
        nPoint = 0;                 %初始化
        for j = 1 : row
            for k = 1 : col
                if(Label(j,k) == i)
                    nPoint = nPoint + 1;            %对于是连通区域中的点npoint+1.
                    Hue(nPoint,1) = HSV(j,k,1);     %把hsv的值赋给Hue数组。
                end
            end
        end
        
        Hue(:,i) = sort(Hue(:,1));
        for j = floor(nPoint*0.1) : floor(nPoint*0.9)
            MeanHue(i) = MeanHue(i) + Hue(j,1);     %将hsv(i)的值赋给MeanHue(i)
        end
        MeanHue(i) = MeanHue(i) / (0.8*nPoint);     %计算出平均的色度值
    end

%调用regionprops函数获得各个联通区域的属性值(中心点坐标，外接椭圆的长短轴长度，面积)。
[L,num]=bwlabel(BW2);                               %重新进行区域标记。
stats= regionprops(L, 'ALL');                       %调用regionprops函数。
for i= 1:num
longth(i)=stats(i).MajorAxisLength;                 %获得外接椭圆的长轴长度
width(i)=stats(i).MinorAxisLength;                  %获得外接椭圆的短轴长度
end
%初始化。
R2=0;
G2=0;
B2=0;
x=0;
y=0;
%求出似圆性。
for i=1:num
    r(i)=0;
    g(i)=0;
    b(i)=0;
    yuan(i)=longth(i)/width(i);%长轴长度/短轴长度为似圆性特征。
end

%获得以每个水果重心为中心点的边长为30的正方形内的像素的rgb值
for i=1:num
    for j=(round(stats(i).Centroid(1))-15):(round(stats(i).Centroid(1))+15)
        for k=(round(stats(i).Centroid(2))-15):(round(stats(i).Centroid(2))+15)
            R2=im2double(img(j,k,1));
            G2=im2double(img(j,k,2));
            B2=im2double(img(j,k,3));
            r(i)=r(i)+R2;
            g(i)=g(i)+G2;
            b(i)=b(i)+B2;
        end
    end
    r(i)=r(i)/900;
    g(i)=g(i)/900;
    b(i)=b(i)/900;
end

%求出水果中面积最大值用于判定
for i=1:num
    if(stats(i,1).Area>x)
        x=stats(i,1).Area;
    end
end

%求出水果中hsv的最小值用于判定
y=MeanHue(1);
for i=1:num
    if(y>MeanHue(i))
        y=MeanHue(i);
    end
end



%显示最终分类结果图。
figure,imshow(img);

%梨子分类算法
for i=1:num
    if(MeanHue(i)==y && yuan(i)>1.3 && r(i)>0.7 && g(i)>0.7)
        text(stats(i).Centroid(1),stats(i).Centroid(2),'水果类别：梨子');
    end
end

%苹果分类算法
for i=1:num
    if(r(i)>0.75 && yuan(i)<1.15  && g(i)<0.4 && b(i)<0.3)
         text(stats(i).Centroid(1),stats(i).Centroid(2),'水果类别：苹果');
    end
end

%桃子分类算法
for i=1:num
    if(MeanHue(i)<0.6 && yuan(i)<1.25 && r(i)>0.7 &&b(i)>0.1)
        text(stats(i).Centroid(1),stats(i).Centroid(2),'水果类别：桃子');
    end
end

%香蕉分类算法
for i=1:num
    if(MeanHue(i)<0.2 && yuan(i)>1.7)
         text(stats(i).Centroid(1),stats(i).Centroid(2),'水果类别：香蕉');
    end
end

%菠萝分类算法
for i=1:num
    if(MeanHue(i)<0.3 && yuan(i)>1.4&& r(i)<0.8 )
        text(stats(i).Centroid(1)+30,stats(i).Centroid(2)+30,'水果类别：菠萝');
    end
end

%西瓜分类算法
for i=1:num
    if( stats(i,1).Area==x && yuan(i)<1.25&& r(i)<0.4)
        text(stats(i).Centroid(1),stats(i).Centroid(2),'水果类别：西瓜');
    end
end

