%{
plot faces (zhangning 202312)
    tcor: the coordinates
    tf_P: faces
%}
function Con3_plotFace(tcor, tf_P, fid, isText, isHold)

if nargin ==3
    isHold = 0;
end
figure(fid);
if isHold
    hold on;
else
    hold off;
end


% matrix form
nf  = size(tf_P,1);
if iscell(tf_P)
    fnp = zeros(nf,1);
    for ii =1:nf
        fnp(ii) = size(tf_P{ii},2);
    end
    nc = max(fnp);
    
    fs = nan(nf,nc);
    for ii =1:nf
        fs(ii,1:fnp(ii)) = tf_P{ii};
    end
else
    fs = tf_P;
end

% plot
patch('Faces',fs,'Vertices',tcor,'FaceColor','#4DBEEE','FaceAlpha',0.6);
if isText
    hold on;
    text(tcor(:,1), tcor(:,2), tcor(:,3),...
        num2str((1:size(tcor,1)).'), 'Color', 'k');
end

axis equal; view(-37.5,30);
xlabel('x');  ylabel('y'); zlabel('z');
end
