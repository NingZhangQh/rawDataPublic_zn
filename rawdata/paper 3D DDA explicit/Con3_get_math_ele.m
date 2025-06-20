function [vol, cen, math_x, math_v, math_a] = ...
    Con3_get_math_ele(tcor, tF, v0, o0, isLump, fid, testCondition)
if nargin < 7
    testCondition = 0;
end
[vol, cen, I_m, eigs_m, eigV] = Con3_get_vol_cen_I(tcor, tF);

M = [-1,  1,  1
    1, -1,  1
    1,  1, -1] * 4;

if isLump
    rs = sqrt(M * eigs_m);
else
    disp("协调质量存疑，无所谓了，反正都可用")
    rs = sqrt(M * (eigs_m / 5)); 
end


if testCondition == 1
    rs = rs / 2;
   
elseif testCondition == 2 || testCondition == 3
    
    rave = mean(vecnorm(tcor - cen, 2, 2));
    eigs_m = [1;1;1] * rave * rave;
    % eigs_m = mean(eigs_m) * [1;1;1]; 
    rs = sqrt(M * eigs_m);
    
else
    
end
math_x = (Con3_regularPoly_cor(4) .* rs') * eigV' + cen;
if det(eigV) < 0
    math_x = math_x([2,1,3,4],:);
end

math_v = zeros(4, 3);
math_a = zeros(4, 3);
for ii = 1:4
    dx = math_x(ii,:) - cen;
    math_v(ii,:) = cross(o0, dx);
    math_a(ii,:) = cross(o0, math_v(ii,:));
end
math_v = math_v + v0;

if fid > 0
    figure(fid); clf;
    ls = [2	  3
        1	2
        1	4
        3	4
        1	3
        2	4];
      
    plot3_lines(math_x, ls, 2);
    %scatter3(math_x(:, 1), math_x(:, 2), math_x(:, 3));
    Con3_plotFace(tcor, tF, fid, 1, 1);
end
end
