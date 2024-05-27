function y = evaluatenl(b,x)

y = 0;

for i = 1:length(x)
    for j = 1:size(b,2)-1
        xmin = b(1,1);
        xmax = b(1,end);
        x1 = b(1,j);
        y1 = b(2,j);
        x2 = b(1,j+1);
        y2 = b(2,j+1);
        
        if x(i) < xmin
            y(i) = (b(2,1)/xmin)*x(i);
        elseif x(i) >= x1 && x(i) <= x2
            y(i) = ((y2-y1)/(x2-x1))*(x(i)-x1) + y1;
        elseif x(i) > xmax
            y(i) = (b(2,end)/xmax)*x(i);
        end
    end
end