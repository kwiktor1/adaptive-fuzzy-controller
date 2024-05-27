function [Ixl,Iul,Ixn,Iun] = evals(A,B,H,d1,d2,x0,puls,beta1,beta2,k1,k2)

L = diag([beta1,beta2]);

betamax = max([beta1,beta2]);

A1 = A + B*L*H;

% linear controller
% Ixl = square of the norm x
[l_z21,m_z21] = ss2tf(A1,x0,[1,0,0],0);
[l_z22,m_z22] = ss2tf(A1,x0,[0,1,0],0);
[l_z23,m_z23] = ss2tf(A1,x0,[0,0,1],0);
Ixl = integralI3(l_z21,m_z21) + ...
      integralI3(l_z22,m_z22) + ...
      integralI3(l_z23,m_z23);

% Iul = square of the norm u
[l_z11,m_z11] = ss2tf(A1,x0,H(1,:),0);
[l_z12,m_z12] = ss2tf(A1,x0,H(2,:),0);
Iul = beta1^2*integralI3(l_z11,m_z11) + ...
      beta2^2*integralI3(l_z12,m_z12);
  
% nonlinear controller
K = diag([k1,k2]);

D = diag([d1,d2]);

dmax = max([d1,d2]);

I = [1,0,0; 0,1,0; 0,0,1];

MM = []; MG = []; ML = [];

for w = puls
    s = j*w;
    
    G1 = H*(s*I-A1)^(-1)*B;
    W1 = G1 - K^(-1);
    U1 = D*W1;
    max_lambda = max(real(eig(U1+U1')));
    MM = [MM,max_lambda];

    G2 = (s*I-A1)^(-1)*B;
    max_gamma = max(real(eig(G2'*G2)));
    MG = [MG,max_gamma];

    max_lambda = max(real(eig(G1'*G1)));
    ML = [ML,max_lambda];
end

delta = -max(MM)/2;
if delta <= 0
    error('Stability condition violated')
end

% norms G2 and G1
ng2 = sqrt(max(MG));
ng1 = sqrt(max(ML));

% norms z2 and z1
nz2 = sqrt(Ixl);
nz1 = sqrt(integralI3(l_z11,m_z11) + ...
          integralI3(l_z12,m_z12));

% square of the norm x
Ixn = (nz2 + (ng2*dmax*nz1)/delta)^2;
% square of the norm u
Iun = nz1^2*(dmax/delta + betamax*(1 + (dmax*ng1)/delta))^2;
