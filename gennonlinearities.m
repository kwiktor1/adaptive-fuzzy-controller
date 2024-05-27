clear all

tic

load('evaluations')

sigma1min = -1.2;
sigma1max = 1.2;

sigma2min = -0.8;
sigma2max = 0.8;

% generate NL1
x = linspace(sigma1min,sigma1max,7);

a1 = bestsect(1);
a2 = bestsect(2);
b1 = -[x(3)*a1,x(3)*a2]; 
b2 = -[x(2)*a1,x(2)*a2]; 
b3 = -[x(1)*a1,x(1)*a2]; 

cnt = 1;

for i = 1:1:length(b1)
    for j = 1:1:length(b2)
        for k = 1:1:length(b3)
            % design nonlinearity
            NL1{cnt} = idPiecewiseLinear;
            bp = [-b3(k),-b2(j),-b1(i),0,b1(i),b2(j),b3(k)];
            NL1{cnt}.BreakPoints = [x;bp];
            y = evaluate(NL1{cnt},x');
            xx = sigma1min-0.5:.1:sigma1max+0.5;
            yn = evaluatenl(NL1{cnt}.BreakPoints,xx);
            cnt = cnt + 1;
            
            % plot nonlinearity
            subplot(121)
            plot(x,y,'r',xx,yn,'*', 'LineWidth',1.5),grid
            
            % plot boundaries
            y1 = a1*x;
            y2 = a2*x;
            hold on
            line(x,y1,'LineStyle','--')
            line(x,y2,'LineStyle','--')
            hold off
            xlabel('x')
            title('NL1')
            drawnow,shg
            %pause
        end
    end
end

% generate NL2
x = linspace(sigma2min,sigma2max,7);

a1 = bestsect(3);
a2 = bestsect(4);
b1 = -[x(3)*a1,x(3)*a2]; 
b2 = -[x(2)*a1,x(2)*a2]; 
b3 = -[x(1)*a1,x(1)*a2];  

cnt = 1;

for i = 1:1:length(b1)
    for j = 1:1:length(b2)
        for k = 1:1:length(b3)
            % design nonlinearity
            NL2{cnt} = idPiecewiseLinear;
            bp = [-b3(k),-b2(j),-b1(i),0,b1(i),b2(j),b3(k)];
            NL2{cnt}.BreakPoints = [x;bp];
            y = evaluate(NL2{cnt},x');
            xx = sigma2min-0.5:.1:sigma2max+0.5;
            yn = evaluatenl(NL2{cnt}.BreakPoints,xx);
            cnt = cnt + 1;
            
            % plot nonlinearity
            subplot(122)
            plot(x,y,'r',xx,yn,'*', 'LineWidth',1.5),grid
            
            % plot boundaries
            y1 = a1*x;
            y2 = a2*x;
            hold on
            line(x,y1,'LineStyle','--')
            line(x,y2,'LineStyle','--')
            hold off
            xlabel('x')
            title('NL2')
            drawnow,shg
            %pause
        end
    end
end

save('nonlinearities.mat')
