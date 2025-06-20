clear all; clc
dbstop if error

% a block
a0 = 0.5; b0 = 0.5;
a1 = 0.2; b1 = 0.3;
h = 1.5;
rbot = [-a0, -b0; a0, -b0; a0, b0; -a0, b0];
rtop = [-a1, -b1; a1, -b1; a1, b1; -a1, b1];
rtop(:,3) = h;
rbot(:,3) = 0;
con = Convex3d.byV([rtop; rbot]);
con.plot_faces(1,0,0)

% get 
[vol, cen, I_m, eigs_m, eigV] = Con3_get_vol_cen_I(con.cor, con.F);

% optimal mathmatical nodes
M = [-1,  1,  1
    1, -1,  1
    1,  1, -1] * 4;
as = sqrt(M * eigs_m);
cor_tet = [1, 1, 1;
          1, -1, -1;
        -1, -1, 1;
        -1, 1, -1]/sqrt(8);
math_x = (cor_tet .* as') * eigV' + cen;

% set correct orders
if det(eigV) < 0
    math_x = math_x([2,1,3,4],:);
end

% disp
disp("vertices")
disp(con.cor)
disp("faces")
disp(con.F)
disp("mathematical nodes")
disp(math_x)



