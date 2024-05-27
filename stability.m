function [sectors,Rc,square] = stability(p,B,H,d1,d2,puls,beta1,beta2,k1,k2)

Rl = [];
sectors = [];
cnt = 1;

for m = 1:length(beta1)
    for n = 1:length(beta2)
        disp(['beta1 = ', num2str(beta1(m))])
        disp(['beta2 = ', num2str(beta2(n))])

        for k = 1:length(p)
            
            A = [-4,p(k),-10;
                  1,0,0;
                  0,1,0];
                           
            % Hurwitz 
            L = diag([beta1(m),beta2(n)]);
            A1 = A + B*L*H;

            if all(real(eig(A1))<0)
                % stability region for linear system
                Rl = [Rl; beta1(m),beta2(n)];
               
                % stability region for nonlinear system
                [R{k},Ri{k}] = stabregion(A,B,H,d1,d2,puls,...
                    beta1(m),beta2(n),k1,k2);
            end
        end
        
        % find common region for all p
        Rc = commonregion(Ri);

        % plot common region 
        figure(2)
        subplot(length(beta1),length(beta2),cnt)
        x = k1(Rc(:,1));
        y = k2(Rc(:,2));
        plot(x,y,'bx');
        axis('square')
        axis([0 2.5 0 2.5])
        xlabel('k1')
        ylabel('k2')
        title(['beta1 = ', num2str(beta1(m)), ...
               ', beta2 = ', num2str(beta2(n))])
        shg, drawnow
     
        % find all squares in region
        W = zeros(length(k1),length(k2));
        for i = 1:size(Rc,1)
            W(Rc(i,1),Rc(i,2)) = 1;
        end
        squares = findsquares(W);

        % find the largest squares
        I1 = find(squares(:,9) == max(squares(:,9)));

        % choose these ones, that have the left bottom corner
        % in the origin
        S = squares(I1,:);
        I2 = find(S(:,3)==1 & S(:,4)==1);

        % the first square as the solution
        square = S(I2(1),:);
        
        % plot square
        plotsquare(square,k1,k2);

        % coordinates of the center of the square
        [k1c,k2c] = center(square,k1,k2);

        % sectors
        sectors = [sectors; ...
            beta1(m),beta1(m)+k1c,beta2(n),beta2(n)+k2c];

        % actual sectors
        sects = sectors(cnt,:);
        cnt = cnt + 1;
    end
end
