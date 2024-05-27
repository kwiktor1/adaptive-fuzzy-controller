function [u1,u2,M1x,M2x] = ts22(sigma1,sigma2,M1,M2,Q1,Q2)

% membership degrees
M1x = mid2(sigma1, M1);
M2x = mid2(sigma2, M2);

% number of rules
r1 = length(M1); 

num1 = 0;
den1 = 0;     

if sigma1 < min(M1(1))
    u1 = (Q1(1)/M1(1))*sigma1;
elseif sigma1 > M1(end)
    u1 = (Q1(end)/M1(end))*sigma1;
else
    for i = 1:r1
        num1  = num1 + Q1(i)*M1x(i);
        den1 = den1 + M1x(i);
    end
    u1 = num1/den1;
end

% number of rules
r2 = length(M2); 

num2 = 0;
den2 = 0;     

if sigma2 < min(M2(1))
    u2 = (Q2(1)/M2(1))*sigma2;
elseif sigma2 > M2(end)
    u2 = (Q2(end)/M2(end))*sigma2;
else
    for i = 1:r2
        num2  = num2 + Q2(i)*M2x(i);
        den2 = den2 + M2x(i);
    end
    u2 = num2/den2;
end
