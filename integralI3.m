function I3 = integralI3(c,d)

m = length(c); 
n = length(d);

c0 = c(m); c1 = c(m-1); c2 = c(m-2);
d0 = d(n); d1 = d(n-1); d2 = d(n-2); d3 = d(n-3);

I3 = (d1*c2^2 + d3*(c1^2-2*c0*c2) + d2*d3*c0^2/d0)/(2*d3*(d1*d2-d0*d3));
