% intra = zeros(2);
% intra(1,2) = 1; % node 1 in slice t connects to node 2 in slice t

% inter = zeros(2);
% inter(1,1) = 1; % node 1 in slice t-1 connects to node 1 in slice t

% % We can specify the parameters as follows, where for simplicity we assume the observed node is discrete.

% Q = 2; % num hidden states
% O = 2; % num observable symbols

% ns = [Q O];
% dnodes = 1:2;
% bnet = mk_dbn(intra, inter, ns, 'discrete', dnodes);
% for i=1:4
  % bnet.CPD{i} = tabular_CPD(bnet, i);
% end

%%%%%%%%%%%%%%%%%%%%%%%%HMM
% trans=[0,1;1,0];
% emis =[1/6,1/6,1/6,1/6,1/6,1/6;
       % 1/10,1/10,1/10,1/10,1/10,1/2];
% % [seq,states] = hmmgenerate(100,trans,emis)
% [seq,states] = hmmgenerate(100,trans,emis,...
    % 'Symbols',{'one','two','three','four','five','six'},...
    % 'Statenames',{'fair';'loaded'});
% % [estimateTR,estimateE] = hmmestimate(seq,states,...
% %     'Symbols',{'one','two','three','four','five','six'},...
% %     'Statenames',{'fair';'loaded'});
% count = 0;
% for i=1:100
   % if strcmp(seq{i},'two')
       % count = count + 1;
   % end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%
size = 7573;
fid=fopen('main_c','r');  

seq = zeros(size,1);
for i=1:size
    text = fgetl(fid);
    a=sscanf(text,'frame:%d ratio:%f h:%d s:%d v:%d');%frame:1 ratio:0.304685 h:0 s:1 v:3
	
    seq(i) = a(2); 
end
fclose(fid);

seq = sort(seq);

up = seq(fix(size/3));

down = seq(fix(size*2/3));




