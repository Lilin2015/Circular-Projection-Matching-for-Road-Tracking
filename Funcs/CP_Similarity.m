function S = CP_Similarity(CP_ref,CP_cur,R_T)
%% ��������CP_cur��������¼CP_ref֮����ۺ�������
% CP_ref, [m,n1]����, m����Ϊ����ά��, n1����Ϊ��׼������
% CP_cur, [m,n2]����, m����Ϊ����ά��, n2����Ϊ����������
% S, [n2,1]����, ����CP_cur��������¼CP_ref֮����ۺ�������
    [m,n1] = size(CP_ref);
    [~,n2] = size(CP_cur);
    % D_ref, ������������׼�����ľ���, [n2,n1]����
    D_ref  = sum((repmat(CP_ref,[1,1,n2])-repmat(reshape(CP_cur,[m,1,n2]),[1,n1])).^2,1).^0.5;
    D_ref  = reshape(D_ref,[n1,n2])';
    
    % PD_ref, ��׼������ԭʼ�����ľ���, [1,n1]����
    PD_ref = sum((CP_ref-repmat(CP_ref(:,1),[1,n1])).^2,1).^0.5;
    % RT_ref, ��׼�������Ե���ֵ, [1,n1]����
    RT_ref = R_T./(1+PD_ref);
    
    % S_ref, �������������׼������������, [n2,n1]����
    S_ref = 1-D_ref./repmat(RT_ref,[n2,1]);    S_ref(D_ref>=RT_ref) = 0;
    % S, �ۺ�������, [n2,1]
    S = sum(S_ref./D_ref,2)./sum(1./D_ref,2);
    
    
    S(min(D_ref,[],2)<=0.01)=1;
end

