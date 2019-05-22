function [CPvec,CPvec3] = CP(I,center,R,Nr)
%% ��ͼ��I�ϼ�����centerΪ���ģ�RΪ���뾶��NrΪ������Բ����������
% center, [num,2]����, numΪ������, ��xy����ϵ��¼Բ������
% CPvec, [Nr,num]����, num��center��Nrά��������
    [M,N,~] = size(I);
    num = size(center,1);
    % ������center
    center = round(center);
    x = center(:,1); y = center(:,2);
    x = min(N,max(1,x)); y = min(M,max(1,y));
    
    % Delta_r, Բ���ֱ���
    % Ck, ����������
    Delta_r = R/Nr;    Ck = 2*R*(1:Nr)'/Nr;
    maxCk = round(max(Ck));
        
    % r_matrix, �����뾶, [Nr,maxCk]����
    % theta_matrix, ������������ĽǶ�, [Nr,maxCk]����
    r_matrix = repmat(max(Delta_r*(1:Nr),2)',[1,maxCk]);
    theta_matrix = repmat(min(2*pi./Ck,pi/2),[1,maxCk]).*repmat(1:maxCk,[Nr,1]);
    theta_matrix(theta_matrix>2*pi)=NaN;
    % bias_x, bias_y, �������������ƫ��, [Nr,maxCk]����
    bias_x = floor(r_matrix.*cos(theta_matrix));
    bias_y = floor(r_matrix.*sin(theta_matrix));
    % x_matrix, y_matrix, �����������������, [Nr,maxCk,num]����
    x_matrix = min(N,max(1,repmat(reshape(x,[1,1,num]),[1,maxCk])+repmat(bias_x,[1,1,num])));
    y_matrix = min(M,max(1,repmat(reshape(y,[1,1,num]),[1,maxCk])+repmat(bias_y,[1,1,num])));
    % value_matrix, �����������������ȡֵ, [Nr,maxCk,num]����
    value_matrix = reshape(I( sub2ind([M,N],y_matrix(:),x_matrix(:)) ),[Nr,maxCk,num]);
    value_matrix(isnan(repmat(theta_matrix,[1,1,num])))=NaN;
    CPvec = reshape(mean(value_matrix,2,'omitnan'),[Nr,num]);
    
    % CPvec3, �Թ���³����Բ������
    CPvec1 = CPvec - repmat(mean(CPvec,1),[Nr,1]);
    CPvec2 = CPvec1 - repmat(min(CPvec1,[],1),[Nr,1]) + 0.01;
    CPvec3 = log(CPvec2) - repmat(mean(log(CPvec2),1),[Nr,1]);

end

