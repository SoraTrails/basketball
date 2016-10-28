%主色提取
%生成文件为main_c

rate = 4;
frame = 1;%要读的帧
hsv=zeros(rate*rate*rate,1);
file = fopen('main_c','w');
last_h_value = 0;
last_s_value = 0;
last_v_value = 0;

while frame < NumberOfFrames
	ima=read(video,frame);%原图象

	im=rgb2hsv(ima);%hsv图象

	%将h、s、v三个分量的8个区域分别用对应的数字来表示（分布到0-8的整数范围内）
	h1=fix(im(:,:,1)*rate);
	s1=fix(im(:,:,2)*rate);
	v1=fix(im(:,:,3)*rate);

	%将等于8的分量值划分到7区域中
	h1=h1-(h1==rate);
	s1=s1-(s1==rate);
	v1=v1-(v1==rate);

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

	% if(ratio < 0.20)
		fprintf(file, 'frame:%d ratio:%f h:%d s:%d v:%d ', frame, ratio,h_value,s_value,v_value);
	% end
	if h_value~=last_h_value ||s_value~=last_s_value||v_value~=last_v_value%主色发生改变
		fprintf(file,'boom!!%d',frame);
	end

	fprintf(file,'\n');

	% last_frame = frame;
	last_h_value = h_value;
	last_s_value = s_value;
	last_v_value = v_value;
	frame = frame + 1;
end
fclose(file);