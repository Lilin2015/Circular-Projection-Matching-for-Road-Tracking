clear
close all
path(path,strcat(pwd,'\Funcs'));
path(path,strcat(pwd,'\Images'));
%% 参数设置
filename = '2.png';
D = 13;         % 路宽
R = 0.85*D;     % 环形模板的最佳半径上限
Nr = 10;         % 圆环数目
R_T = 1.2;     % 相似性阈值
length = 1.2*R;   % 搜索步长
fan = deg2rad(90);
closeR = R;
%% 读图
I = im2double(imread(filename)); if size(I,3)==3, I = rgb2gray(I); end

figure; imshow(I);
% 点选种子点
while 1== 1
Pos1 = ginput(1);
PosStack = [];
PosRecord = [];
CPRecord = [];
dir = NaN;
hold on; scatter(Pos1(1),Pos1(2),'+','r');
hold on; viscircles(Pos1, R,'Color','r','LineWidth',1);

while 1 == 1
    [~,CPvec] = CP(I,Pos1,R,Nr);
    
    PosRecord = cat(1,PosRecord,Pos1);
    CPRecord = cat(2,CPRecord,CPvec);
    
    
    nextPos = findNextPos(Pos1,PosRecord,CPRecord,dir,I,R,Nr,length,R_T,fan,closeR);
    PosStack = cat(1,[repmat(Pos1,[size(nextPos,1),1]),nextPos],PosStack);
    
    if isempty(PosStack), break; end
    PosD = PosStack(1,:); 
    PosStack(1,:)=[];
    
    Pos1 = PosD(1:2);
    Pos2 = PosD(3:4);
    line([Pos1(1),Pos2(1)],[Pos1(2),Pos2(2)],'color','blue','LineWidth',2);
    
    [dir,~] = cart2pol(Pos2(1)-Pos1(1),Pos2(2)-Pos1(2));
    
    Pos1 = PosD(3:4);
    pause(0.01);
end
end
