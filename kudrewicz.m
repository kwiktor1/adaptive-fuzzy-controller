function delta = kudrewicz(A,B,H,d1,d2,puls,beta1,beta2,k1,k2)

L = diag([beta1,beta2]);

A1 = A + B*L*H;

K = diag([k1,k2]);

D = diag([d1,d2]);

I = diag([1,1,1]);

M = [];

for w = puls
    s = j*w;
    G1 = H*(s*I-A1)^(-1)*B;
    W1 = G1 - K^(-1);
    U1 = D*W1;
    max_lambda = max(real(eig(U1+U1')));
    M = [M,max_lambda];
end

delta = -max(M)/2;
