function S = CP_Similarity(CP_ref,CP_cur,R_T)
%% 计算特征CP_cur到特征记录CP_ref之间的综合相似性
% CP_ref, [m,n1]矩阵, m方向为特征维度, n1方向为基准特征数
% CP_cur, [m,n2]矩阵, m方向为特征维度, n2方向为待测特征数
% S, [n2,1]矩阵, 特征CP_cur到特征记录CP_ref之间的综合相似性
    [m,n1] = size(CP_ref);
    [~,n2] = size(CP_cur);
    % D_ref, 待测特征到基准特征的距离, [n2,n1]矩阵
    D_ref  = sum((repmat(CP_ref,[1,1,n2])-repmat(reshape(CP_cur,[m,1,n2]),[1,n1])).^2,1).^0.5;
    D_ref  = reshape(D_ref,[n1,n2])';
    
    % PD_ref, 基准特征到原始特征的距离, [1,n1]矩阵
    PD_ref = sum((CP_ref-repmat(CP_ref(:,1),[1,n1])).^2,1).^0.5;
    % RT_ref, 基准特征各自的阈值, [1,n1]矩阵
    RT_ref = R_T./(1+PD_ref);
    
    % S_ref, 待测特征与各基准特征的相似性, [n2,n1]矩阵
    S_ref = 1-D_ref./repmat(RT_ref,[n2,1]);    S_ref(D_ref>=RT_ref) = 0;
    % S, 综合相似性, [n2,1]
    S = sum(S_ref./D_ref,2)./sum(1./D_ref,2);
    
    
    S(min(D_ref,[],2)<=0.01)=1;
end

