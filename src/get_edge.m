frame = 150;%要读的帧

ima=read(video,frame);%原图象

%%%%%%%%%%%%% im=rgb2hsv(ima);%hsv图象

%%%%%%%%%%%%% ima_gray = gray_main(ima, Height, Width);
ima_gray = rgb2gray(ima);
% subplot(1,2,1),imshow(ima_gray);

% for i=1:Height
% 	for j=1:Width
% 		if ima_gray(i,j) > 200 
% 			ima_gray(i,j) = ima_gray(i,j) + 20;
% 			if ima_gray(i,j) > 255
% 				ima_gray(i,j) = 255;
% 			end
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


figure, imshow(ima_edge), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');