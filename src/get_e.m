
frame = 1;%要读的帧
theta_data = zeros(30,2);
for frame=1:30

	ima=read(video,frame);%原图象

	%%%%%%%%%%%%% im=rgb2hsv(ima);%hsv图象

	%%%%%%%%%%%%% ima_gray = gray_main(ima, Height, Width);
	ima_gray = rgb2gray(ima);


	[ima_edge, threshold] = edge(ima_gray,'canny',[0.2,0.6]);

	[H, theta, rho] = hough(ima_edge);
	P = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));

	lines = houghlines(ima_edge,theta,rho,P,'FillGap',8,'MinLength',20);

	%link
	if isempty(lines)
		fprintf('dont find any lines\n');
		% continue;
	end

	% merge
	new_lines = [];

	for i=1:length(lines)
		if lines(i).theta == -90 && ...
		  (lines(i).point1(2) < Height * up_border || ...
		   lines(i).point1(2) > Height *(1 - down_border))%消除无效横直线
			continue;
		end
		flag = 0;
		for j=1:length(new_lines)
			temp_k = tand(lines(i).theta + 90);
			temp_b1 = lines(i).point1(2) - temp_k * lines(i).point1(1);
			temp_b2 = new_lines(j).point1(2) - temp_k * new_lines(j).point1(1);
			if abs(temp_b2 - temp_b1) < 3 %able to link
				if lines(i).theta ~= 0
					if lines(i).point1(1) < new_lines(j).point1(1)
						new_lines(j).point1 = lines(i).point1;
					end
					if lines(i).point2(1) > new_lines(j).point2(1)
						new_lines(j).point2 = lines(i).point2;
					end
				else
					if lines(i).point1(2) < new_lines(j).point1(2)
						new_lines(j).point1 = lines(i).point1;
					end
					if lines(i).point2(2) > new_lines(j).point2(2)
						new_lines(j).point2 = lines(i).point2;
					end
				end
				flag = 1;
				break;
			end
		end
		if flag == 0 %not able to link
			new_lines = [new_lines, lines(i)];
		end
		i = i + 1;
	end

	if length(new_lines) <= 1
		theta_data(frame,:) = -1;
		continue;
	end
	s_theta = [];
	l_theta = [];
	for i=1:length(new_lines)
		if new_lines(i).theta <= 0
			s_theta = [s_theta, new_lines(i).theta];
		else
			l_theta = [l_theta, new_lines(i).theta];
		end
		
		if isempty(s_theta) || isempty(l_theta)
			theta_data(frame,:) = -1;
			continue;
		end
		
		theta_data(frame,1) = mean(l_theta) - mean(s_theta);
		if abs(mean(s_theta)) > abs(mean(l_theta))%左半场
			theta_data(frame,2) = 1;
		else%右半场
			theta_data(frame,2) = 2;
		end
		
	end
	% frame = frame + 1;
end
% figure, imshow(ima_edge), hold on
% max_len = 0;
% if isempty(new_lines) == 0
	% for k = 1:length(new_lines)
	   % xy = [new_lines(k).point1; new_lines(k).point2];
	   % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

	   % % Plot beginnings and ends of new_lines
	   % plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
	   % plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

	   % % Determine the endpoints of the longest line segment
	   % len = norm(new_lines(k).point1 - new_lines(k).point2);
	   % if ( len > max_len)
	      % max_len = len;
	      % xy_long = xy;
	   % end
	% end
	% % highlight the longest line segment
	% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
% end