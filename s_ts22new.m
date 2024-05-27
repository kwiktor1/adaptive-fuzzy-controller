% =========================================================================
% Function s_ts32.m
% =========================================================================

function [sys,x0,str,ts] = ...
    s_ts22new(t,x,u,flag,M1,M2,beta1,betak1,beta2,betak2)

switch flag
    case 0
        [sys,x0,str,ts] = mdlInitializeSizes;               % Initialization
    case 3
        sys = mdlOutputs(t,x,u,M1,M2,beta1,betak1,beta2,betak2);   % Calculate outputs
    case { 1, 2, 4, 9 }
        sys = [];                                           % Unused flags
    otherwise
        error(['Unhandled flag = ',num2str(flag)]);         % Error handling
end;    
 

% =========================================================================
% Funkcja mdlInitializeSizes.
% =========================================================================

function [sys,x0,str,ts] = mdlInitializeSizes

sizes = simsizes;
sizes.NumContStates = 0;
sizes.NumDiscStates = 0;
sizes.NumInputs = 9;        % sigma1, sigma2, eps1, eps2, eps3
                            % dx1, dx2, dx3, learning on/off
sizes.NumOutputs = 2;       % u1, u2
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0 = [];
str = [];
ts = [-1,0];


% =========================================================================
% Function mdlOutputs.
% =========================================================================

function sys = mdlOutputs(t,x,u,M1,M2,beta1,betak1,beta2,betak2)

sys = train_ts22(u(1),u(2),u(3),u(4),u(5),...
    u(6),u(7),u(8),u(9),M1,M2,beta1,betak1,beta2,betak2);


% =========================================================================
% Sector-bounded adaptive fuzzy controller.
% =========================================================================

function outp = train_ts22(sigma1,sigma2,eps1,eps2,eps3,...
    dx1,dx2,dx3,train,M1,M2,beta1,betak1,beta2,betak2)

global Q1
global Q2

global u1old
global u2old

% fuzzy controller outputs and membership degrees
[u1,u2,M1x,M2x] = ts22(sigma1,sigma2,M1,M2,Q1,Q2);

% set the outputs of the Simulink block
outp(1) = u1;
outp(2) = u2;

% control increment
du1 = u1 - u1old;
du2 = u2 - u2old;

u1old = u1;
u2old = u2;

% learning rates
w1 = 0.04;
w2 = 0.04;
w3 = 0.04;

% restriction for derivatives
s = 0.2;

% derivatives
dx1du1 = sat(dx1/du1,-s,s);
dx2du1 = sat(dx2/du1,-s,s);
dx3du1 = sat(dx3/du1,-s,s);
dx1du2 = sat(dx1/du2,-s,s);
dx2du2 = sat(dx2/du2,-s,s);
dx3du2 = sat(dx3/du2,-s,s);

% adaptaion signal
t1 = w1*dx1du1*eps1 + w2*dx2du1*eps2 + w3*dx3du1*eps3;
t2 = w1*dx1du2*eps1 + w2*dx2du2*eps2 + w3*dx3du2*eps3;

if train == 1
    for k = 1:length(Q1)
        % train except the "middle" rule
        if k ~= 4
            % new consequences
            Q1new = Q1(k) + t1*M1x(k);
            Q2new = Q2(k) + t2*M2x(k);
            
            % sector restrictions for Q1
            if Q1new/M1(k) < beta1
                Q1(k) = beta1*M1(k);
            elseif Q1new/M1(k) > betak1
                Q1(k) = betak1*M1(k);
            else
                Q1(k) = Q1new;
            end

            % sector restrictions for Q2
            if Q2new/M2(k) < beta2
                Q2(k) = beta2*M2(k);
            elseif Q2new/M2(k) > betak2
                Q2(k) = betak2*M2(k);
            else
                Q2(k) = Q2new;
            end
        end
    end
end
