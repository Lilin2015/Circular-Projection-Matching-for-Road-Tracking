function [CP_round,nextCenter,angles] = roundCP(center,length,I,R,Nr)
%% 计算以center为中心，length为半径，的一圈像素点的圆环特征向量，I,R,Nr为计算特征向量的参数
    % resolution, 圈上像素点个数
    resolution = 72;
    % angles, 圈上像素点的角度
    angles = ((1:1:resolution)/resolution*2*pi)';
    % nextCenter, 圈上像素点的坐标
    nextCenter = [center(1) + length*cos(angles), center(2) + length*sin(angles)];
    % CP_round, 圈上像素点的特征向量, 每列代表一个像素的特征向量
    [~,CP_round]=CP(I,nextCenter,R,Nr);
end

