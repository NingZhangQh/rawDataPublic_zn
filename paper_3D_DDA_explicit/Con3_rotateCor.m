function cor = Con3_rotateCor(cor, cen, theta, u)
if norm(theta) == 0
    return
end

if nargin == 3
    tnorm = norm(theta);
    u = theta / tnorm; % 单位旋转轴
else
    tnorm = theta;
end

K = [0, -u(3), u(2);
     u(3), 0, -u(1);
     -u(2), u(1), 0];

R = eye(3) + sin(tnorm) * K + (1 - cos(tnorm)) * (K^2);
cor = (cor - cen) * R'  + cen;
end