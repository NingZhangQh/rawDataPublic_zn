function [vol, cen, I_m, eigs_m, eigV, int2] = Con3_get_vol_cen_I(tcor, tF)
% vol: volume
% cen: center
% I_m: moment of ineria tensor / m
% eigs: principal values
% eigV: principal direction

isNeed2 = nargout > 2;
% hammer int(2)
a = 0.585410196624969;   b = 0.138196601125011;
poss = [a, b, b, b
    b, a, b, b
    b, b, a, b
    b, b, b, a];
ws = [0.25;0.25;0.25;0.25];

x = tcor - tcor(1,:);
int0 = 0;
int1 = [0, 0, 0];
int2 = [0, 0, 0, 0, 0, 0];

for ii = 1:size(tF,1)
    if iscell(tF)
        ps = tF{ii};
    else
        ps = tF(ii,:);
    end
    x1 = x(ps(1),:);
    for jj = 1: numel(ps) - 2
        x2 = x(ps(jj+1),:);
        x3 = x(ps(jj+2),:);

        tV = dot(cross(x1, x2), x3) / 6;

        int0 = int0 + tV;
        int1 = int1 + (x1+x2+x3) * (tV/4);
        if isNeed2
            for kk = 1:numel(ws)
                tx = poss(kk, 2) * x1 + poss(kk, 3) * x2 + poss(kk, 4) * x3;
                int2 = int2 + (ws(kk) * tV) * ...
                    [tx(1) * tx(1), tx(2) * tx(2), tx(3) * tx(3), tx(1) * tx(2), tx(2) * tx(3), tx(3) * tx(1)];
            end
        end
    end

end
dx = int1 / int0;
vol = int0;
cen = dx + tcor(1,:);

if isNeed2
    int2(1:3) = int2(1:3) - 2 * int1 .* dx + dx .* dx * int0;
    int2(4) = int2(4) - int1(1) * dx(2) - int1(2) * dx(1) + int0 * dx(1) * dx(2);
    int2(5) = int2(5) - int1(2) * dx(3) - int1(3) * dx(2) + int0 * dx(2) * dx(3);
    int2(6) = int2(6) - int1(3) * dx(1) - int1(1) * dx(3) + int0 * dx(3) * dx(1);
    
    I_m = [int2(2) + int2(3), -int2(4), -int2(6)
        -int2(4), int2(3) + int2(1), -int2(5)
        -int2(6), -int2(5), int2(1) + int2(2)] / vol;
    [eigV, D] = eig(I_m);
    
    eigs_m = diag(D);
end
end