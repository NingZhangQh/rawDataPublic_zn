classdef Convex3d < handle
    properties
        C
        cor
        F
    end

    methods(Static)
        function con3 = byV(tcor)
            [tC, tcor] = Con3_updateByV(tcor);
            [tC, tf_P] = Con3_updateFace(tC, tcor);
            con3 = Convex3d(tC, tcor, tf_P);
        end
        function con3 = byBox(p0, p1)
            C = [0,-p0(1), -1, 0, 0
                0, p1(1),  1, 0, 0
                0,-p0(2),  0,-1, 0
                0, p1(2),  0, 1, 0
                0,-p0(3),  0, 0,-1
                0, p1(3),  0, 0, 1];
            cor = p0+[0,0,0;1,0,0;1,1,0;0,1,0;0,0,1;1,0,1;1,1,1;0,1,1].*(p1-p0);
            F = {[4,1,5,8];[2,3,7,6];[1,2,6,5];[3,4,8,7];[4,3,2,1];[5,6,7,8]};
            con3 = Convex3d(C, cor, F);
        end
        
    end
    methods
        % Box [-1]
        function obj = Convex3d(tC, tCor, tF)
            obj.C = tC;
            obj.cor = tCor;
            obj.F = tF;
        end
        function ls = get_lines(obj)
            tf_P = obj.F;  nf = size(tf_P, 1);
            nl = 0;
            for ii = 1:nf
                nl = nl + size(tf_P{ii}, 2);
            end
            nl = nl / 2;
            ls = zeros(nl, 2);
            id = 0;
            for ii = 1: nf
                tps = tf_P{ii};  tn = size(tps,2);
                
                j0 = tn;
                for jj = 1: tn
                    if tps(jj) > tps(j0)
                        id = id + 1;
                        ls(id, :) = [tps(j0), tps(jj)];
                    end
                    % next
                    j0 = jj;
                end
            end
        end

        function fs = get_faceForPatch(obj)
            tf_P = obj.F;   

            nf  = size(tf_P,1);
            fnp = zeros(nf,1);
            for ii =1:nf
                fnp(ii) = size(tf_P{ii},2);
            end
            nc = max(fnp);

            fs = nan(nf,nc);
            for ii =1:nf
                fs(ii,1:fnp(ii)) = tf_P{ii};
            end

        end
        
        function move(obj, dx)
            % 平移            
            obj.cor = obj.cor + dx;
            obj.C(:,2) = obj.C(:,2) + obj.C(:,3:5) * dx'; 
        end

        function amplify(obj, ratio, cen)
            tcor = cen + (obj.cor - cen) .* ratio;
            [tC, tcor] = Con3_updateByV(tcor);
            [tC, tf_P] = Con3_updateFace(tC, tcor);
            obj.C = tC;
            obj.cor = tcor;                                                                                                                                                                           
            obj.F = tf_P;
        end

        function rotate_x(obj, cen, angle)
            theta = angle / 180 * pi;
            R = [1, 0, 0;
                 0, cos(theta), -sin(theta);
                 0, sin(theta), cos(theta)];
            tcor = obj.cor;
            
            tcor = (tcor - cen) * R + cen;
            [tC, tcor] = Con3_updateByV(tcor);
            [tC, tf_P] = Con3_updateFace(tC, tcor);
            obj.C = tC;
            obj.cor = tcor;                                                                                                                                                                           
            obj.F = tf_P;
        end

        function rotate_y(obj, cen, angle)
            theta = angle / 180 * pi;
            R = [cos(theta), 0, sin(theta);
                 0, 1, 0;
                 -sin(theta), 0, cos(theta)];
            tcor = obj.cor;
            
            tcor = (tcor - cen) * R + cen;
            [tC, tcor] = Con3_updateByV(tcor);
            [tC, tf_P] = Con3_updateFace(tC, tcor);
            obj.C = tC;  
            obj.cor = tcor;                                                                                                                                                                           
            obj.F = tf_P;
        end
        
        function rotate_z(obj, cen, angle)
            theta = angle / 180 * pi;
            R = [cos(theta), -sin(theta), 0;
                 sin(theta), cos(theta), 0;
                 0, 0, 1];
            tcor = obj.cor;
            
            tcor = (tcor - cen) * R + cen;
            [tC, tcor] = Con3_updateByV(tcor);
            [tC, tf_P] = Con3_updateFace(tC, tcor);
            obj.C = tC;  
            obj.cor = tcor;                                                                                                                                                                           
            obj.F = tf_P;
        end


        function plot_faces(obj, fig, isText, isHold)
            if nargin ==3
                isHold = false;
            end
            figure(fig);
            if isHold
                hold on;
            else
                clf;
            end


            % matrix form
            fs = obj.get_faceForPatch();
            tcor = obj.cor;

            % plot
            patch('Faces',fs,'Vertices',tcor,'FaceColor','#4DBEEE','FaceAlpha',0.8, "linewidth", 1);
            if isText
                hold on;
                text(tcor(:,1), tcor(:,2), tcor(:,3),...
                    num2str((1:size(tcor,1)).'), 'Color', 'k');
            end

            axis equal; view(-37.5,30);
            xlabel('x');  ylabel('y'); zlabel('z');
        end

        function [vol, cen] = vol_cen(obj)
            % vol: 体积
            % cen: 中心
            tF = obj.F;   tcor = obj.cor;

            x = tcor - tcor(1,:);
            int0 = 0;
            int1 = [0, 0, 0];

            for ii = 1:size(tF,1)
                ps = tF{ii};
                x1 = x(ps(1),:);
                for jj = 1: numel(ps) - 2
                    x2 = x(ps(jj+1),:);
                    x3 = x(ps(jj+2),:);

                    tV = dot(cross(x1, x2), x3) / 6;

                    int0 = int0 + tV;
                    int1 = int1 + (x1+x2+x3) * (tV/4);
                end
            end
            dx = int1 / int0;

            vol = int0;
            cen = dx + tcor(1,:);
        end
        
        function [r, cen] = get_sphere(obj)
            [vel, cen] = obj.vol_cen();
            r = max(vecnorm(obj.cor - cen, 2, 2));
        end
       
        function [pa, pb] = get_box(obj)
            tcor = obj.cor;
            pa = min(tcor);
            pb = max(tcor);
        end

        function get_rblock(obj)
            disp("rblock create vertices ...")

            tcor= obj.cor;
            ncor = size(tcor,1);
            for ii = 1: ncor - 1
                disp("    " + num2str(tcor(ii,:), 3) + " ...")
            end
            disp("    " + num2str(tcor(ncor,:), 3));
        end
    end
end

