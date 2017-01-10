data=rand(100,2);
[center,U,obj_fcn] = FCMCluster(data,2);
plot(data(:,1),data(:,2),’o’);
hold on;
index1=find(U(1,:)==max(U));%找出划分为第一类的数据索引
index2=find(U(2,:)==max(U));%找出划分为第二类的数据索引
plot(data(index1,1),data(index1,2),’g*’);
hold on;
plot(data(index2,1),data(index2,2),’r*’);
hold on;
plot([center([1 2],1)],[center([1 2],2)],’*’,’color’,’k’);