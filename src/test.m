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
% size = 7573;
% fid=fopen('main_c','r');  

% seq = zeros(size,1);
% for i=1:size
    % text = fgetl(fid);
    % a=sscanf(text,'frame:%d ratio:%f h:%d s:%d v:%d');%frame:1 ratio:0.304685 h:0 s:1 v:3
	
    % seq(i) = a(2); 
% end
% fclose(fid);

% seq = sort(seq);

% up = seq(fix(size/3));

% down = seq(fix(size*2/3));

N = 4;							%节点个数
discrete_nodes = 1:N;			%1到N的等差数列，表示？？
node_sizes = 2*ones(1,N);		%各个节点的取值个数（取离散的False和True值，故取值个数为2）
								%用1表示False，2表示True
dag = zeros(N,N);				%用邻接矩阵表示贝叶斯网络，1表示有边，0表示无边
C = 1; S = 2; R = 3; W = 4;		%四个节点
dag(C,[R S]) = 1;				%生成贝叶斯网络的结构
dag(R,W) = 1;
dag(S,W) = 1;
bnet = mk_bnet(dag,node_sizes,'names', {'Cloudy','Sprinkler','Rain','WetGrass'},'discrete',1:4); %生成贝叶斯网络

%定义贝叶斯网络的条件概率分布表
%对于C，定义顺序为False True；对于R、S，定义顺序为（R:C R，S:C S）FF FT TF TT；对于W,定义顺序为（R S W）FFF FFT FTF FTT TFF TFT TTF TTT
bnet.CPD{C} = tabular_CPD(bnet, C, [0.5 0.5]);
bnet.CPD{R} = tabular_CPD(bnet, R, [0.8 0.2 0.2 0.8]);
bnet.CPD{S} = tabular_CPD(bnet, S, [0.5 0.9 0.5 0.1]);

p = zeros(2,2,2);
p(1,1,:) = [1 0];
p(1,2,:) = [0.1 0.9];
p(2,1,:) = [0.1 0.9];
p(2,2,:) = [0.01 0.99];
bnet.CPD{W} = tabular_CPD(bnet, W, p);
%至此贝叶斯网络结构及参数定义完毕

%推理：
evidence = cell(1,N);
engine = jtree_inf_engine(bnet);

%计算P(S=True|W=True)
evidence{W} = 2;
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, S);
p = marg.T(2);
fprintf('P(S=True|W=True)=%f\n',p);

%计算P(S=True|W=True,R=True)
evidence{R} = 2;
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, S);
p = marg.T(2);
fprintf('P(S=True|W=True,R=True)=%f\n',p);

%计算S，R，W的联合分布概率
evidence = cell(1,N);
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, [S R W]);
p = marg.T



