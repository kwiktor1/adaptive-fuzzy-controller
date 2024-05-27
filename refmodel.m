clear all

tic

load('nonlinearities')

cnt = 1;

indices = [];

figure(1)

for i = 1:size(NL1,2),i
    for j = 1:size(NL2,2),j
        
        % take break-points
        bp1 = NL1{i}.BreakPoints;
        bp2 = NL2{j}.BreakPoints;

        % simulate system
        x0 = [1,0,-0.6];
        out = sim('refmodelsim.slx');

        % extract results
        t = out.tout;
        x = out.x(:,2:4);
        u = out.u(:,2:3);
        sigma1 = out.sigma(:,2);
        sigma2 = out.sigma(:,3);

        subplot(311)
        plot(t,x)
        xlabel('t')
        ylabel('x')
        subplot(312)
        plot(t,u)
        xlabel('t') 
        ylabel('u')
        subplot(313)
        plot(t,sigma1,t,sigma2)
        xlabel('t')
        legend({'sigma1','sigma2'})
        drawnow,shg

        % signal norms
        normx(cnt) = sqrt(trapz(t,sum(x'.^2)));
        normu(cnt) = sqrt(trapz(t,sum(u'.^2)));

        indices = [indices; cnt,i,j];

        cnt = cnt + 1;
   end
end

save('refmodel.mat')

toc