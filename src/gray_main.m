%% gray_main: function description
function [ima_gray] = gray_main(ima, Height, Width)

% frame = 2381;%要读的帧

gray_rate = 55;

% ima=read(video,frame);%原图象
ima_gray = rgb2gray(ima);
subplot(1,2,1),imshow(ima_gray);

ima_gray_fix = fix(ima_gray / gray_rate);%0-10

gray_column = zeros(fix(255 / gray_rate) + 1,1);
for i=0:fix(255 / gray_rate)
	gray_column(i + 1)=length(find(ima_gray_fix == i));
end

[gray_max, gray_index] = max(gray_column);
gray_ratio = gray_max / (Width * Height);

gray_index = gray_index - 1;

for i=1:Height
	for j=1:Width
		if ima_gray_fix(i,j) == gray_index
			ima_gray(i,j) = 0;%边界线为浅色时
		end
	end
end

subplot(1,2,2),imshow(ima_gray);

