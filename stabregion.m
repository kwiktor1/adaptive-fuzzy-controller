function [R,Ri] = stabregion(A,B,H,d1,d2,puls,beta1,beta2,k1,k2)

R = [];
Ri = [];
for m = 1:length(k1)
    for n = 1:length(k2)
        delta = kudrewicz(A,B,H,d1,d2,puls,beta1,beta2,k1(m),k2(n));
        if delta > 0 
            R = [R; k1(m),k2(n)];
            Ri = [Ri; m,n]; 
       end
    end
end
