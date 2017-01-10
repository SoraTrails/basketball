%主色提取
rate = 5;
frame = 444;%要读的帧

ima=read(video,frame);%原图象

im=rgb2hsv(ima);%hsv图象
h0=im(:,:,1);
s0=im(:,:,2);
v0=im(:,:,3);

%将h、s、v三个分量的8个区域分别用对应的数字来表示（分布到0-8的整数范围内）
h1=fix(h0*(rate-1));
s1=fix(s0*(rate-1));
v1=fix(v0*(rate-1));

% %将等于8的分量值划分到7区域中
% h1=h1-(h1==rate);
% s1=s1-(s1==rate);
% v1=v1-(v1==rate);

hsv=zeros(rate*rate*rate,1);
temp=h1*rate*rate+s1*rate+v1;

for   i=0:rate*rate*rate-1
    hsv(i+1)=length(find(temp==i));%计算每个区域中的符合颜色分量的像素的个数
end


[maxr, index] = max(hsv);%找到像素个数最多的区域

ratio = maxr / (Height * Width);%主色占比

index = index-1;%%%%%%%%%%%%%%%%%fuckkkkkkkk

h_value = fix(index/(rate*rate)); 
s_value = fix((index - h_value * rate*rate)/rate);
v_value = mod((index - h_value * rate*rate), rate);%获得主色hsv各分量对应区域数

subplot(1,2,1),imshow(ima);

count=0;
for i=1:Height
	for j=1:Width
		if h1(i,j) == h_value
			if s1(i,j) == s_value
				if v1(i,j) == v_value
					ima(i,j,1) = 255;
					ima(i,j,2) = 255;
					ima(i,j,3) = 255;%把主色变为白色
					count = count + 1;
				end
			end
		end
	end
end

% main_im = hsv2rgb(im);
% subplot(3,1,1),bar(hsv);
% subplot(2,1,1),imshow(ima);
subplot(1,2,2),imshow(ima);
