intra = zeros(2);
intra(1,2) = 1; % node 1 in slice t connects to node 2 in slice t

inter = zeros(2);
inter(1,1) = 1; % node 1 in slice t-1 connects to node 1 in slice t

% We can specify the parameters as follows, where for simplicity we assume the observed node is discrete.

Q = 2; % num hidden states
O = 2; % num observable symbols

ns = [Q O];
dnodes = 1:2;
bnet = mk_dbn(intra, inter, ns, 'discrete', dnodes);
for i=1:4
  bnet.CPD{i} = tabular_CPD(bnet, i);
end


% file = fopen('edge_data','w');

% for frame=1:NumberOfFrames
	% ima=read(video,frame);%原图象
	% ima_gray = rgb2gray(ima);

	% [ima_edge, threshold] = edge(ima_gray,'canny',[0.2,0.6]);
	% [H, theta, rho] = hough(ima_edge);
	% P = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
	% lines = houghlines(ima_edge,theta,rho,P,'FillGap',8,'MinLength',20);

	% %link
	% if isempty(lines)
		% fprintf(file, '%d:null\n',frame);
		% continue;
	% end

	% % merge
	% new_lines = [];

	% for i=1:length(lines)
		% if lines(i).theta == -90
			% continue;
		% end
		% flag = 0;
		% for j=1:length(new_lines)
			% temp_k = tand(lines(i).theta + 90);
			% temp_b1 = lines(i).point1(2) - temp_k * lines(i).point1(1);
			% temp_b2 = new_lines(j).point1(2) - temp_k * new_lines(j).point1(1);
			% if abs(temp_b2 - temp_b1) < 3 %able to link
				% if lines(i).theta ~= 0
					% if lines(i).point1(1) < new_lines(j).point1(1)
						% new_lines(j).point1 = lines(i).point1;
					% end
					% if lines(i).point2(1) > new_lines(j).point2(1)
						% new_lines(j).point2 = lines(i).point2;
					% end
				% else
					% if lines(i).point1(2) < new_lines(j).point1(2)
						% new_lines(j).point1 = lines(i).point1;
					% end
					% if lines(i).point2(2) > new_lines(j).point2(2)
						% new_lines(j).point2 = lines(i).point2;
					% end
				% end
				% flag = 1;
				% break;
			% end
		% end
		% if flag == 0 %not able to link
			% new_lines = [new_lines, lines(i)];
		% end
		% i = i + 1;
	% end

	% fprintf(file, '%d:',frame);
	% for s=1:length(new_lines)
		% fprintf(file, '%d    ',new_lines(s).theta);
	% end
	% fprintf(file,'\n');

% end
% fclose(file);