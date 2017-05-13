%dfa

% clc;
% clear;

% for i=1:NumberOfFrames
	% imwrite(read(video,i),char(sprintf('F:\\basketball\\pic\\%d.png',i)),'jpg');
% end

pic_path = 'F:\basketball\pic\';

ima_type = 0;
%0：初始 1: 中场 2：前场 3：前场特写 4：特写

main_color = 0;
%1:主色，0:非主色

location = 1;
%1: 中场 2：前场 3：前场特写 4：特写

i=1
while i <= NumberOfFrames
	% ima_front= imread(strcat(pic_path,num2str(i-1),'.png'));
	% ima= imread(strcat(pic_path,num2str(i),'.png'));

	% [main_color,location] = type(ima);

	if(ima_type == 0 || ima_type == 4) % 初始&特写
		ima = imread(strcat(pic_path,num2str(i),'.png'));
		[main_color,location] = type(ima);
		
		if(main_color == 0)
			ima_type == 4;
		else
			ima_type = location;
		end
		
		i = i + 1;
		continue;
	elseif(ima_type == 1)
		% ima = imread(strcat(pic_path,num2str(i),'.png'));
		% [main_color,location] = type(ima);
		
		% if(main_color == 0)
			% ima_type == 4;
			% sprintf('from zhong to te %d',i);
		% else
			% ima_type = location;
		% end
	
	
	

	
	
	
end











