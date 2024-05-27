clear all

% parameter in matrix A
p = [-8,-9,-12,-15];

B = [2,-1;
     0, 1;
     1, 0];

H = [  1,1,0;
     0.5,0,1]; 
   
puls = 0:0.15:10;

beta1 = linspace(0,0.8,3);
beta2 = linspace(0,1,3);

k1 = 0.001:0.15:1.5;
k2 = 0.001:0.15:2.5;

d1 = linspace(.2,1.2,3);
d2 = linspace(.2,1.2,3);

%d1 = 1;
%d2 = 1;

EV = [];
OS = [];

cnt = 1;

for i = 1:length(d1)
    for j = 1:length(d2)
        
        sectors = stability(p,B,H,d1(i),d2(j),puls,beta1,beta2,k1,k2);
        [optsect,optevals] = ...
            evaluations(sectors,p,B,H,d1(i),d2(j),puls,beta1,beta2,k1,k2);
        
        OS = [OS; optsect];
        EV = [EV; d1(i),d2(j),optevals];

        cnt = cnt + 1;
    end
end

plot(EV(:,3),EV(:,4),'*'),shg

d = sqrt((EV(:,3)).^2 + (EV(:,4)).^2);
[~,ix] = min(d);

bestsect = OS(ix,:);
besteval = EV(ix,:);

save('evaluations.mat')
