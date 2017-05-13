% dbn_test
intra = zeros(4);
intra(1,2) = 1;
intra(1,3) = 1;
intra(3,2) = 1;
intra(3,4) = 1;
 
inter = zeros(4);
inter(1,1) = 1; 
inter(2,1) = 1; 
inter(2,3) = 1; 
inter(3,3) = 1; 

node_size = [2,2,4,6];

dnodes = 1:4;
onodes = [4]; 

eclass1 = 1:4;
eclass2 = [5 6 7 4];
eclass = [eclass1 eclass2];

bnet = mk_dbn(intra, inter, node_size, 'discrete', dnodes, 'observed', onodes,...
				'eclass1',eclass1, 'eclass2', eclass2);

% 1：非投篮 2：投篮
bnet.CPD{1} = tabular_CPD(bnet, 1, [0,1]);
% 1: 关闭 2：打开
bnet.CPD{2} = tabular_CPD(bnet, 2, [ ]);%'adjustable',0); 2*4*2
% 1: 中场 2：前场 3：前场特写 4：特写
bnet.CPD{3} = tabular_CPD(bnet, 3); 
% 1：
bnet.CPD{4} = tabular_CPD(bnet, 4);

bnet.CPD{5} = tabular_CPD(bnet, 5);

bnet.CPD{6} = tabular_CPD(bnet, 6);

bnet.CPD{7} = tabular_CPD(bnet, 7);

