frame = 2350;%要读的帧
ima=read(video,frame);%原图�?
%%%%%%%%%%%%% im=rgb2hsv(ima);%hsv图象

%%%%%%%%%%%%% ima_gray = gray_main(ima, Height, Width);
ima_gray = rgb2gray(ima);
% subplot(1,2,1),imshow(ima_gray);
% h=[0,1,0;1,-4,1;0,1,0];%锐化滤波
% h = fspecial('prewitt');
% temp = conv2(double(ima_gray),h,'same');
% ima_gray=double(ima_gray)-temp;
% for i=1:Height
% 	for j=1:Width
% 		% if ima_gray(i,j) > 200 
% 		% 	ima_gray(i,j) = ima_gray(i,j) + 20;
% 		% 	if ima_gray(i,j) > 255
% 		% 		ima_gray(i,j) = 255;
% 		% 	end
% 		% end
% 		if ima_gray(i,j) > 230
% 			ima_gray(i,j) = 0;
% 		end
% 	end
% end
% subplot(1,2,2),imshow(ima_gray);

[ima_edge, threshold] = edge(ima_gray,'canny',[0.2,0.6]);

%%%%%%%%% ima_edge0 = imclose(ima_edge,strel('disk',2));
%%%%%%%%% imshow(ima_edge);

%%%%%%%%% [B,L,N,A] = bwboundaries(ima_edge,'noholes');

[H, theta, rho] = hough(ima_edge);
P = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
%%%%%% imshow(H,[],'XData',theta,'YData',rho,...
%%%%%%             'InitialMagnification','fit');
%%%%%% xlabel('\theta'), ylabel('\rho');
%%%%%% axis on, axis normal, hold on;

lines = houghlines(ima_edge,theta,rho,P,'FillGap',8,'MinLength',20);


% figure, imshow(ima_edge), hold on
% max_len = 0;
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

%    % Determine the endpoints of the longest line segment
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
% end
% % highlight the longest line segment
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

%link
if isempty(lines)
	fprintf('dont find any lines\n');
	% continue;
end

% merge
new_lines = [];
i=1;
for i=1:length(lines)
	if (lines(i).theta == -90 || lines(i).theta == 89 || lines(i).theta == -89) && ...
		  (lines(i).point1(2) < Height * up_border || ...
		   lines(i).point1(2) > Height *(1 - down_border))%消除无效横直线
		   continue;
	end
	flag = 0;
	j = 1;
	while j <= length(new_lines)
		if new_lines(j).theta == lines(i).theta
			temp_k = tand(lines(i).theta + 90);
			temp_b1 = lines(i).point1(2) - temp_k * lines(i).point1(1);
			temp_b0 = lines(i).point2(2) - temp_k * lines(i).point2(1);
			temp_b2 = new_lines(j).point1(2) - temp_k * new_lines(j).point1(1);
			if abs(temp_b2 - temp_b1) < 1 && abs(temp_b2 - temp_b0) < 1 %able to link
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
		j = j + 1;
	end
	if flag == 0 %not able to link
		new_lines = [new_lines, lines(i)];
	end
	% i = i + 1;
end

%show origin
% figure, imshow(ima_edge), hold on
% max_len = 0;
% if isempty(lines) == 0
	% for k = 1:length(lines)
	   % xy = [lines(k).point1; lines(k).point2];
	   % plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

	   % % Plot beginnings and ends of lines
	   % plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
	   % plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

	   % % Determine the endpoints of the longest line segment
	   % len = norm(lines(k).point1 - lines(k).point2);
	   % if ( len > max_len)
	      % max_len = len;
	      % xy_long = xy;
	   % end
	% end
	% % highlight the longest line segment
	% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
% end

%show mine
figure, imshow(ima_edge), hold on
max_len = 0;
if isempty(new_lines) == 0
	for k = 1:length(new_lines)
	   xy = [new_lines(k).point1; new_lines(k).point2];
	   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

	   % Plot beginnings and ends of new_lines
	   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
	   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

	   % Determine the endpoints of the longest line segment
	   len = norm(new_lines(k).point1 - new_lines(k).point2);
	   if ( len > max_len)
	      max_len = len;
	      xy_long = xy;
	   end
	end
	% highlight the longest line segment
	plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
end