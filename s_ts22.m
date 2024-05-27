% =========================================================================
% Funkcja s_ts32.m
% =========================================================================

function [sys,x0,str,ts] = s_ts22(t,x,u,flag,cx1,cx2,beta,betak,XX1,XX2,MFX1,MFX2)

switch flag
    case 0
        [sys,x0,str,ts] = mdlInitializeSizes;               % Initialization
    case 3
        sys = mdlOutputs(t,x,u,cx1,cx2,beta,betak,XX1,XX2,MFX1,MFX2);   % Calculate outputs
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
sizes.NumOutputs = 4;       % u1, u2
sizes.NumInputs = 7;        % x1, x2, epsilon, uczenie
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0 = [];
str = [];
ts = [-1,0];


% =========================================================================
% Funkcja mdlOutputs.
% =========================================================================

function sys = mdlOutputs(t,x,u,cx1,cx2,beta,betak,XX1,XX2,MFX1,MFX2)

sys = train_ts22(u(1),u(2),u(3),u(4),u(5),...
    u(6),...
    u(7),...
    cx1,cx2,beta,betak,XX1,XX2,MFX1,MFX2);


% =========================================================================
% Ucz¹cy siê regulator rozmyty ograniczony w sektorze.
% =========================================================================

function outp = train_ts22(sigma1,sigma2,eps1,eps2,eps3,...
    dx1du1,...
    train,...
    cx1,cx2,beta,betak,XX1,XX2,MFX1,MFX2)

global bp1
global bp2 

global Q1
global Q2

global optsect

global Q10
global Q20

global flg

%u1 = evaluatenl(bp1,sigma1);
%u2 = evaluatenl(bp2,sigma2);

M1 = bp1(1,:);
M2 = bp2(1,:);

[u1,u2,M1x,M2x] = ts22(sigma1,sigma2,M1,M2,Q1,Q2);

outp(1) = u1;
outp(2) = u2;

beta1 = optsect(1);
betak1 = optsect(2);
beta2 = optsect(3);
betak2 = optsect(4);

eps = eps1 + eps2 + eps3;
%w1 = 100*exp(-0.5*((eps/0.3).^2));
%w2 = 500*exp(-0.5*((eps/0.3).^2));

if abs(eps) < 0.03
    w1 = 0.5;
    w2 = 0.8;
else
    w1 = 0.02;
    w2 = 0.04;
end

dx1du1 = 1;

t1 = w1*(dx1du1*eps1 + eps2 + eps3);
t2 = w2*(eps1 + eps2 + eps3); t2 = 0;

%if flg == 1
%    t1 = w1*eps;
%    t2 = 0;
%elseif flg == 2
%    t1 = 0;
%    t2 = -w2*eps;
%end

if train == 1
    for k = 1:length(Q1)
        if k ~= 4
            Q1new = Q1(k) + t1*M1x(k);
            Q2new = Q2(k) + t2*M2x(k);
            % Q1new = Q1(k) + w1*(eps1+eps2+eps3)*M1x(k);
            % Q1new = Q1(k) + w1*(eps1+eps2+eps3)*M1x(k);

            if Q1new/M1(k) < beta1
                Q1(k) = beta1*M1(k);
            elseif Q1new/M1(k) > betak1
                Q1(k) = betak1*M1(k);
            else
                Q1(k) = Q1new;
            end

            if Q2new/M2(k) < beta2
                Q2(k) = beta2*M2(k);
            elseif Q2new/M2(k) > betak2
                Q2(k) = betak2*M2(k);
            else
                Q2(k) = Q2new;
            end
        end
    end
    figure(3)
    subplot(211)
    plot(M1,Q1,M1,Q10,':',[sigma1,sigma1],[-0.5,0.5],'--')
    subplot(212)
    plot(M2,Q2,M2,Q20,':',[sigma2,sigma2],[-0.5,0.5],'--')
    title(['eps = ',num2str(eps)])
    grid,drawnow,shg
end

outp(3) = t1;
outp(4) = t2;

% global FR;
% 
% [mfx1, x1_count, x1_int] = mid2(x1, cx1);
% [mfx2, x2_count, x2_int] = mid2(x2, cx2);
% 
% r=length(cx1); % liczba zbiorów
% 
% % Wyznacz wyjœcie regulatora bior¹c pod uwagê tylko te regu³y, dla których
% % stopieñ spe³nienia jest wiêkszy od 0. 
% num=0;  den=0;     
% for k=(x1_int-x1_count+1):x1_int    % Scan over cx1 indices of mfs that are on
%   for l=(x2_int-x2_count+1):x2_int  % Scan over cx2 indices of mfs that are on
%     wx = mfx1(k)*mfx2(l); 
%     num  = num + FR(k,l)*wx;
% 	den  = den + wx;
%   end
% end
% urozm = num/den;           % wyjœcie regulatora rozmytego
% %ulin = K1*x1 + K2*x2;   % wyjœcie regulatora liniowego
% 
% outp(1) = urozm;
% %wy(1) = ulin;

% sprawdzenie warunku sektora
% sigma2 = h1*x1 + h2*x2;
% 
% if sigma2 ~= 0
%     stosunek2 = urozm/sigma2;
% else
%     stosunek2 = 0;
% end
% outp(2) = sigma2;
% 
% %funkcja_badanie_sektora2(cx1,cx2,FR,9,60)
% 
% if uczenie == 1
%     % Modyfikator (nastêpników) regu³.
%     for k=(x1_int-x1_count+1):x1_int        
%         for l=(x2_int-x2_count+1):x2_int
%             wx = mfx1(k)*mfx2(l);
%             if diagonala==1
%                  % zostaw przek¹tn¹ bez zmian
%                  %if all(k+l ~= [r,r+1,r+2])
%                  if all(k+l ~= [r+1])
%                     FRnew = FR;  
%                     p = (p1 + p2)*wx;
%                     FRnew(k,l) = FR(k,l) + p;
%                    
%                     % nadprzek¹tna D1
%                     if (k+l) == r
%                         FRnew(k+1,l+1) = -FRnew(k,l);
%                     end
%                     % podprzek¹tna D2
%                     if (k+l) == r+2
%                         FRnew(k-1,l-1) = -FRnew(k,l);
%                     end
%                     
%                     if ogran==1
%                         % badamy czy FRnew siê nadaje
%                         czy=czy_w_sektorze_faster(XX1,XX2,MFX1,MFX2,FRnew,h1,h2,beta,betak,0);
%                         if czy == 1
%                              FR = FRnew;
%                         end
%                     else
%                         FR = FRnew;
%                     end
%                 end
%             elseif diagonala==0
%                 p = (p1 + p2)*wx;
%                 FR(k,l) = FR(k,l) + p;  % modyfikacja regu³
%             end
%         end
%     end
% end
