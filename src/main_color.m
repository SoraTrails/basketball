%主色提取
frame = 100;%要读的帧

ima=read(video,frame);%原图象

im=rgb2hsv(ima);%hsv图象
h0=im(:,:,1);
s0=im(:,:,2);
v0=im(:,:,3);

%将h、s、v三个分量的8个区域分别用对应的数字来表示（分布到0-8的整数范围内）
h1=fix(h0*8);
s1=fix(s0*8);
v1=fix(v0*8);

%将等于8的分量值划分到7区域中
h1=h1-(h1==8);
s1=s1-(s1==8);
v1=v1-(v1==8);

hsv=zeros(512,1);
temp=h1*64+s1*8+v1;

for   i=0:511
    hsv(i+1)=length(find(temp==i));%计算每个区域中的符合颜色分量的像素的个数
end


[maxr, index] = max(hsv);%找到像素个数最多的区域

ratio = maxr / (Height * Width);%主色占比

h_value = fix(index/64);
s_value = fix((index - h_value * 64)/8);
v_value = mod((index - h_value * 64), 8);%获得主色hsv各分量对应区域数

count=0;
for i=1:Height
	for j=1:Width
		if h1(i,j) == h_value
			if s1(i,j) == s_value
				if v1(i,j) == v_value
					im(i,j,2) = 0;%把主色变为白色
					count =count + 1;
				end
			end
		end
	end
end

main_im = hsv2rgb(im);
subplot(3,1,1),bar(hsv);
subplot(3,1,2),imshow(ima);
subplot(3,1,3),imshow(main_im);
