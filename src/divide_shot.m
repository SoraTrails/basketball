%镜头分割
Threshold = 0.08 * 255;% 蜜汁阈值，其他视频不知道要取怎样的阈值

%镜头分割点的信息放入data文件里
%第一列是视频中的第几帧，第二列是视频中的第几秒，第三列是帧间差
file = fopen('data','w');

tmp1 = read(video,1);
hv1 = rgb2gray(tmp1);
last_frame = 1;
list = zeros(NumberOfFrames,2);
i = 2;
while i < NumberOfFrames
	tmp2 = read(video,i);
	hv2 = rgb2gray(tmp2);
	d = abs(hv1 - hv2);
	point = sum(sum(d)) / (Height * Width);%帧间差

	list(i,1)=i/FrameRate;
	list(i,2)=point;

	if point > Threshold
		if(last_frame ~= i - 1)
			fprintf(file, '%d %f %f\n', i, i/FrameRate, point);
		end
	end
	
	tmp1 = tmp2;
	hv1 = hv2;
	i = i + 1;
end

fclose(file);


%54s