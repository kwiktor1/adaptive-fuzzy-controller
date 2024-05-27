clear all

load('optrefmodel.mat')

global Q1
global Q2

global u1old
global u2old

% break points of nonlinearity of the reference model
bp1 = NL1opt.BreakPoints;
bp2 = NL2opt.BreakPoints;

% vertices of fuzzy sets from the reference model
M1 = bp1(1,:);
M2 = bp2(1,:);

% rule consequences from the reference model
Q10 = bp1(2,:);
Q20 = bp2(2,:);

% given sector boundaries
beta1 = optsect(1);
betak1 = optsect(2);
beta2 = optsect(3);
betak2 = optsect(4);

% starting function of the controller as line
% in the middle of sector boundaries
Q1 = M1*(beta1 + (betak1-beta1)/2);
Q2 = M2*(beta2 + (betak2-beta2)/2);

% simulation
tfinal = 5;

t = [];
xm = [];
x = [];
eps = [];
u1_over_sigma1 = [];
u2_over_sigma2 = [];

x0 = [0,1,1];
u1old = 0;
u2old = 0;
out = sim('adaptation_part_cc.slx',tfinal);
t = [t;out.tout];
xm = [xm;out.xm];
x = [x;out.x];
eps = [eps;out.epsilon];
u1_over_sigma1 = [u1_over_sigma1; out.u(:,2)./out.sigma_a(:,2)];
u2_over_sigma2 = [u2_over_sigma2; out.u(:,3)./out.sigma_a(:,3)];

% signal norms
nx1 = sqrt(trapz(out.tout,sum((out.x)'.^2)));
nu1 = sqrt(trapz(out.tout,sum((out.u)'.^2)));

x0 = [1,0,1];
u1old = 0;
u2old = 0;
out = sim('adaptation_part_cc.slx',tfinal);
t = [t;tfinal+out.tout];
xm = [xm;out.xm];
x = [x;out.x];
eps = [eps;out.epsilon];
u1_over_sigma1 = [u1_over_sigma1; out.u(:,2)./out.sigma_a(:,2)];
u2_over_sigma2 = [u2_over_sigma2; out.u(:,3)./out.sigma_a(:,3)];

% signal norms
nx2 = sqrt(trapz(out.tout,sum((out.x)'.^2)));
nu2 = sqrt(trapz(out.tout,sum((out.u)'.^2)));

x0 = [1,1,0];
u1old = 0;
u2old = 0;
out = sim('adaptation_part_cc.slx',tfinal);
t = [t;2*tfinal+out.tout];
xm = [xm;out.xm];
x = [x;out.x];
eps = [eps;out.epsilon];
u1_over_sigma1 = [u1_over_sigma1; out.u(:,2)./out.sigma_a(:,2)];
u2_over_sigma2 = [u2_over_sigma2; out.u(:,3)./out.sigma_a(:,3)];

% signal norms
nx3 = sqrt(trapz(out.tout,sum((out.x)'.^2)));
nu3 = sqrt(trapz(out.tout,sum((out.u)'.^2)));

x0 = [1,-1,1];
u1old = 0;
u2old = 0;
out = sim('adaptation_part_cc.slx',tfinal);
t = [t;3*tfinal+out.tout];
xm = [xm;out.xm];
x = [x;out.x];
eps = [eps;out.epsilon];
u1_over_sigma1 = [u1_over_sigma1; out.u(:,2)./out.sigma_a(:,2)];
u2_over_sigma2 = [u2_over_sigma2; out.u(:,3)./out.sigma_a(:,3)];

% signal norms
nx4 = sqrt(trapz(out.tout,sum((out.x)'.^2)));
nu4 = sqrt(trapz(out.tout,sum((out.u)'.^2)));

figure(1)
subplot(211)
plot(t,x(:,2:4)),shg
xlabel('t')
ylabel('x')
subplot(212)
plot(t,eps(:,2:4)),shg
xlabel('t')
ylabel('eps')

save part2