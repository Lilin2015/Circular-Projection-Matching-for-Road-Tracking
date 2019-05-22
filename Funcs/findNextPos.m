function nextPos_flag = findNextPos(pos,PosRecord,CPRecord,dir,I,R,Nr,length,R_T,fan,closeR)
%% 计算以pos为中心的圆环特征向量，及其附近的圆环特征向量，随后从预定方向、范围内选择符合条件的向量
    [M,N] = size(I);
    % 计算周围的圆环特征向量，并计算相似度
    [CP_round,nextPos,angles] = roundCP(pos,length,I,R,Nr);
    S = CP_Similarity(CPRecord,CP_round,R_T);
    % 按预定角度范围筛选满足条件的nextPos
    angles_flag = angles;    S_flag = S;    nextPos_flag = nextPos;
    if isnan(dir), dir=0; fan=360; end % 如没有设定方向，则所有角度均满足条件
    angles_diff = angdiff(angles,dir*ones(size(angles,1),1));
    angles_flag(angles_diff>fan|angles_diff<-fan)=NaN;
    S_flag(isnan(angles_flag))=-1;
    
    % 删除相似度、角度不符合要求的nextPos
    nextPos_flag(S_flag<=0,:)=NaN;
    nextPos_flag(nextPos_flag(:,1)<0|nextPos_flag(:,1)>N,:)=NaN;
    nextPos_flag(nextPos_flag(:,2)<0|nextPos_flag(:,2)>M,:)=NaN;
    % 按相似度排列优先级
    [~,priority] = sort(S_flag,'descend');
    nextPos_flag = nextPos_flag(priority,:);
    nextPos_flag(isnan(nextPos_flag(:,1)),:)=[];
    % 删除和已有路径点过接近的nextPos
    nextNum = size(nextPos_flag,1);
    Pos_Flag = zeros(nextNum,1);
    if isempty(PosRecord), return; end
    PosRecord_amg = PosRecord;
    for i = 1 : nextNum
        num = size(PosRecord_amg,1);
        PosDiff = repmat(nextPos_flag(i,:),[num,1]) - PosRecord_amg;
        PosDist = (PosDiff(:,1).^2+PosDiff(:,2).^2).^0.5;
        Pos_Flag(i) = all(PosDist>closeR);
        if Pos_Flag(i)==1
            PosRecord_amg = cat(1,PosRecord_amg,nextPos_flag(i,:));
        end
    end
    nextPos_flag(~Pos_Flag,:)=[];
    
end

