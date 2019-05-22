function nextPos_flag = findNextPos(pos,PosRecord,CPRecord,dir,I,R,Nr,length,R_T,fan,closeR)
%% ������posΪ���ĵ�Բ���������������丽����Բ����������������Ԥ�����򡢷�Χ��ѡ���������������
    [M,N] = size(I);
    % ������Χ��Բ���������������������ƶ�
    [CP_round,nextPos,angles] = roundCP(pos,length,I,R,Nr);
    S = CP_Similarity(CPRecord,CP_round,R_T);
    % ��Ԥ���Ƕȷ�Χɸѡ����������nextPos
    angles_flag = angles;    S_flag = S;    nextPos_flag = nextPos;
    if isnan(dir), dir=0; fan=360; end % ��û���趨���������нǶȾ���������
    angles_diff = angdiff(angles,dir*ones(size(angles,1),1));
    angles_flag(angles_diff>fan|angles_diff<-fan)=NaN;
    S_flag(isnan(angles_flag))=-1;
    
    % ɾ�����ƶȡ��ǶȲ�����Ҫ���nextPos
    nextPos_flag(S_flag<=0,:)=NaN;
    nextPos_flag(nextPos_flag(:,1)<0|nextPos_flag(:,1)>N,:)=NaN;
    nextPos_flag(nextPos_flag(:,2)<0|nextPos_flag(:,2)>M,:)=NaN;
    % �����ƶ��������ȼ�
    [~,priority] = sort(S_flag,'descend');
    nextPos_flag = nextPos_flag(priority,:);
    nextPos_flag(isnan(nextPos_flag(:,1)),:)=[];
    % ɾ��������·������ӽ���nextPos
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

