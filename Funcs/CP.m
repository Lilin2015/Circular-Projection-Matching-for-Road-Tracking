function [CPvec,CPvec3] = CP(I,center,R,Nr)
%% 在图像I上计算以center为中心，R为最大半径，Nr为环数的圆环特征向量
% center, [num,2]矩阵, num为中心数, 按xy坐标系记录圆环中心
% CPvec, [Nr,num]矩阵, num个center的Nr维特征向量
    [M,N,~] = size(I);
    num = size(center,1);
    % 整数化center
    center = round(center);
    x = center(:,1); y = center(:,2);
    x = min(N,max(1,x)); y = min(M,max(1,y));
    
    % Delta_r, 圆环分辨率
    % Ck, 各环采样数
    Delta_r = R/Nr;    Ck = 2*R*(1:Nr)'/Nr;
    maxCk = round(max(Ck));
        
    % r_matrix, 各环半径, [Nr,maxCk]矩阵
    % theta_matrix, 各环各采样点的角度, [Nr,maxCk]矩阵
    r_matrix = repmat(max(Delta_r*(1:Nr),2)',[1,maxCk]);
    theta_matrix = repmat(min(2*pi./Ck,pi/2),[1,maxCk]).*repmat(1:maxCk,[Nr,1]);
    theta_matrix(theta_matrix>2*pi)=NaN;
    % bias_x, bias_y, 各环各采样点的偏移, [Nr,maxCk]矩阵
    bias_x = floor(r_matrix.*cos(theta_matrix));
    bias_y = floor(r_matrix.*sin(theta_matrix));
    % x_matrix, y_matrix, 各环各采样点的坐标, [Nr,maxCk,num]矩阵
    x_matrix = min(N,max(1,repmat(reshape(x,[1,1,num]),[1,maxCk])+repmat(bias_x,[1,1,num])));
    y_matrix = min(M,max(1,repmat(reshape(y,[1,1,num]),[1,maxCk])+repmat(bias_y,[1,1,num])));
    % value_matrix, 各环各采样点的像素取值, [Nr,maxCk,num]矩阵
    value_matrix = reshape(I( sub2ind([M,N],y_matrix(:),x_matrix(:)) ),[Nr,maxCk,num]);
    value_matrix(isnan(repmat(theta_matrix,[1,1,num])))=NaN;
    CPvec = reshape(mean(value_matrix,2,'omitnan'),[Nr,num]);
    
    % CPvec3, 对光照鲁棒的圆环向量
    CPvec1 = CPvec - repmat(mean(CPvec,1),[Nr,1]);
    CPvec2 = CPvec1 - repmat(min(CPvec1,[],1),[Nr,1]) + 0.01;
    CPvec3 = log(CPvec2) - repmat(mean(log(CPvec2),1),[Nr,1]);

end

