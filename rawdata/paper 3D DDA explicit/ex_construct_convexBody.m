clear all; clc
method = 2;

% by 
if method == 0
    % suggested method, by all the vertices
    cor = [-0.5000   -0.5000         0
        -0.5000    0.5000         0
        -0.2000   -0.3000    1.5000
        -0.2000    0.3000    1.5000
        0.2000   -0.3000    1.5000
        0.2000    0.3000    1.5000
        0.5000   -0.5000         0
        0.5000    0.5000         0];
    con = Convex3d.byV(cor);
elseif method == 1
    % generate a box
    con = Convex3d.byBox([0,0,0], [1,1,1]);
elseif method == 2
    % generate a regular polyhedron (4, 6, 8, 12, 20)
    cor = Con3_regularPoly_cor(6);  
    con = Convex3d.byV(cor);
end

% plot to figure 1
con.plot_faces(1,0,0);

% rotate 10 deg, and move
con.rotate_z([0,0,0], 10)
con.move([1,2,3])

% plot to figure 2
con.plot_faces(2,0,0);

% volume and center
[vol, cen] = con.vol_cen();
disp("volume")
disp(vol)
disp("center")
disp(cen)
disp("edges")
disp(con.get_lines())
disp("faces")
disp(con.F)


