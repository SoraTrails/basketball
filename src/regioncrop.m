%%获取第124帧图像的灰度图并进行连通区域分割
clc;
clear;

video_clip_path='F:\basketball\pic\';
% video_path='D://OScourse//basketball2.avi';
% video=VideoReader(video_path);

for startNum=600:605
    startNum2=startNum+1;

Height=1080;
Width=1920;
up_border = 0.13;%上边界所占比例
down_border = 0.13;%下边界所占比例
size=[0, Height * up_border, Width, Height * (1 - (up_border + down_border))];% xmin ymin width height
% Height=video.Height;
% Width=video.Width;

%%获取图像并二值转化
clip_path=strcat(video_clip_path,num2str(startNum),'.png');
clip_path2=strcat(video_clip_path,num2str(startNum2),'.png');

frame=imread(clip_path);
frame2=imread(clip_path2);
PointFrame=imcrop(frame,size);
PointFrame2=imcrop(frame2,size);
grayFrame=rgb2gray(PointFrame);
grayFrame2=rgb2gray(PointFrame2);
grayFrameAdapt=adapthisteq(grayFrame);
grayFrameAdapt2=adapthisteq(grayFrame2);

for i=1:Height * (1 - (up_border+ down_border))
    for j=1:Width
        if(grayFrame(i,j)>150)
            if(grayFrame(i,j)<230)
                grayFrameAdapt(i,j)=0;
                grayFrameAdapt2(i,j)=0;
            else
                grayFrameAdapt(i,j)=0;
                grayFrameAdapt2(i,j)=0;
            end
        else
            grayFrameAdapt(i,j)=255;
            grayFrameAdapt2(i,j)=255;
        end
    end
end
%%imshow(grayFrameAdapt);
figure('Name','2');

T=graythresh(grayFrameAdapt);
T2=graythresh(grayFrameAdapt2);
bw_img=im2bw(grayFrameAdapt,T);
bw_img2=im2bw(grayFrameAdapt2,T2);
img_reg=regionprops(bw_img,'area','BoundingBox');
img_reg2=regionprops(bw_img2,'area','BoundingBox');
areas=[img_reg.Area];
areas=[img_reg2.Area];
rects=cat(1, img_reg.BoundingBox);
rects2=cat(1,img_reg2.BoundingBox);
difgrayFrame= grayFrame2 - grayFrame;%邻帧差
   
%%寻找最大联通区域
%%[~,max_id]=max(areas);
%%max_rect=rects(max_id,:);
%show the largest connected region
%%figure(2);
%%imshow(bw_img);
%%rectangle('position',max_rect,'EdgeColor','r');

[B,L]=bwboundaries(bw_img,'noholes');
[B2,L2]=bwboundaries(bw_img2,'noholes');
img_reg_circle=regionprops(bw_img,'area','Centroid');
%%%imshow(label2rgb(L,@jet,[.5 .5 .5]))
imshow(L);
hold on
%%可以提出球，需要滤噪
for k=1:length(B)
   boundary=B{k};
   plot(boundary(:,2),boundary(:,1),'w','LineWidth',2);
   delta_sq=diff(boundary).^2;
   area=img_reg_circle(k).Area;
   perimeter=sum(sqrt(sum(delta_sq,2)));
   metric=4*3.14*area/perimeter^2;
  %% if metric>0.82
  %%     if metric < 0.83
   %%        if perimeter > 50 and perimeter<51
  %%          rectangle('position',rects(k,:),'EdgeColor','r');
   %%        end
   %%    end
  %% end
  if metric>0.85
      if perimeter>80
           rectangle('position',rects(k,:),'EdgeColor','r');
           p=[1,0,0];
           ct=img_reg_circle(k).Centroid;
           scatter(ct(1),ct(2),20,p,'filled');
           fprintf('中心点%d',img_reg_circle(k).Centroid);
      end
  end
end
end

%%[L,num]=bwlabel(bw_img,8);

%figure('Name','标记后的图'),
%%imshow(grayFrameAdapt);
%for i=1:100
 %   rectangle('position',rects(i,:),'EdgeColor','r');
%end