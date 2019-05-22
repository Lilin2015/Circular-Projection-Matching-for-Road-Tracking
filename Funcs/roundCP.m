function [CP_round,nextCenter,angles] = roundCP(center,length,I,R,Nr)
%% ������centerΪ���ģ�lengthΪ�뾶����һȦ���ص��Բ������������I,R,NrΪ�������������Ĳ���
    % resolution, Ȧ�����ص����
    resolution = 72;
    % angles, Ȧ�����ص�ĽǶ�
    angles = ((1:1:resolution)/resolution*2*pi)';
    % nextCenter, Ȧ�����ص������
    nextCenter = [center(1) + length*cos(angles), center(2) + length*sin(angles)];
    % CP_round, Ȧ�����ص����������, ÿ�д���һ�����ص���������
    [~,CP_round]=CP(I,nextCenter,R,Nr);
end

