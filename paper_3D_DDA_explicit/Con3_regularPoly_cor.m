function v = Con3_regularPoly_cor(nf)

if nf == 4
    v =  [1, 1, 1;
          1, -1, -1;
        -1, -1, 1;
        -1, 1, -1]/sqrt(8);
elseif nf == 6
    v = [1, 1, 1;
        1, 1, -1;
        1, -1, 1;
        1, -1, -1;
        -1, 1, 1;
        -1, 1, -1;
        -1, -1, 1;
        -1, -1, -1]/2;
elseif nf == 8
    v = [0, 0, 1;
        1, 0, 0;
        0, 1, 0;
        -1, 0, 0;
        0, -1, 0;
        0, 0, -1]/sqrt(2);
elseif nf == 12
    phi = (1 + sqrt(5)) / 2;
    v = [...
        1, 1, 1;
        1, 1, -1;
        1, -1, 1;
        1, -1, -1;
        -1, 1, 1;
        -1, 1, -1;
        -1, -1, 1;
        -1, -1, -1;
        0, phi, 1/phi;
        0, phi, -1/phi;
        0, -phi, 1/phi;
        0, -phi, -1/phi;
        1/phi, 0, phi;
        1/phi, 0, -phi;
        -1/phi, 0, phi;
        -1/phi, 0, -phi;

        
        phi, 1/phi, 0;
        phi, -1/phi, 0;
        -phi, 1/phi, 0;
        -phi, -1/phi, 0]/2;
elseif nf == 20
    phi = (1 + sqrt(5)) / 2;
    v= [0, 1, phi;
        0, -1, phi;
        0, 1, -phi;
        0, -1, -phi;
        1, phi, 0;
        -1, phi, 0;
        1, -phi, 0;
        -1, -phi, 0;
        phi, 0, 1;
        -phi, 0, 1;
        phi, 0, -1;
        -phi, 0, -1
        ] / sqrt(1 + phi^2);
end
end
