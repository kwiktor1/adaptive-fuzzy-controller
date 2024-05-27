clear all

tic

load('refmodel.mat')
p = 0.8;
I = p*normx + (1-p)*normu;

figure(5)
plot(normx,normu,'*')
hold on
for i = 1:cnt-1
    text(normx+0.001,normu+0.001,num2str(i))
end
hold off
xlabel('Ix')
ylabel('Iu')

% select the nonlinearity pair number
[~,num] = min(I);

s1 = sigma1min:.02:sigma1max;
s2 = sigma2min:.02:sigma2max;
ix = indices(num,2);
y1 = evaluatenl(NL1{ix}.BreakPoints,s1);
jx = indices(num,3);
y2 = evaluatenl(NL2{jx}.BreakPoints,s2);
figure(6)
subplot(211)
plot(s1,y1,'LineWidth',1.2),grid
subplot(212)
plot(s2,y2,'lineWidth',1.2),grid
shg

NL1opt = NL1{ix};
NL2opt = NL2{jx};

save('optrefmodel.mat')

toc