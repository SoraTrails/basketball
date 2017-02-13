%main
%generate observe array
%states : 
%		  mid
%		  front
%		  front_feature
%		  feature
%		  
%observe: main_color 2
%		  main_area 3 = 6
%
%1 : true,small
%2 : true,mid
%3 : true,large
%4 : false,small
%5 : false,mid
%6 : false,large
%
size = 7000;
fid=fopen('main_c','r');  
temp = [];
seq = zeros(size/5,1);
j=1;
for i=1:size
    text = fgetl(fid);
	if mod(i,5) ~= 0
		continue;
	end
    a=sscanf(text,'frame:%d ratio:%lf h:%d s:%d v:%d');%frame:1 ratio:0.304685 h:0 s:1 v:3
	% temp = [temp,a];
	c=2;
    d=3;
    if a(2) < 0.2164
        c=1;
    elseif a(2) > 0.2861
        c=3;
    end
    if a(3) == 0 && a(4) == 1 && a(5) == 3
        d=0;
    end
    seq(j) = c + d; 
	j = j+1;
end

ob = zeros(100,1);
for i=1:100
	text = fgetl(fid);
    a=sscanf(text,'frame:%d ratio:%lf h:%d s:%d v:%d');%frame:1 ratio:0.304685 h:0 s:1 v:3
	c=2;
    d=3;
    if a(2) < 0.2164
        c=1;
    elseif a(2) > 0.2861
        c=3;
    end
    if a(3) == 0 && a(4) == 1 && a(5) == 3
        d=0;
    end
    ob(i) = c + d; 
end
fclose(fid);

TRGUESS = [0.8,0.1,0.05,0.05;...
		   0.05,0.8,0.1,0.05;...
		   0.05,0.05,0.8,0.1;...
		   0.1,0.05,0.05,0.8];

EMITGUESS = [0.02,0.18,0.8,0,0,0;...
			 0.1,0.8,0.1,0,0,0;...
			 0.8,0.18,0.02,0,0,0;...
			 0,0,0,0.33,0.33,0.34];

[ESTTR,ESTEMIT] = hmmtrain(seq,TRGUESS,EMITGUESS);

state = hmmviterbi(ob,ESTTR,ESTEMIT,...
				   'Statenames',{'mid';'front';'front_feature';'feature'});

