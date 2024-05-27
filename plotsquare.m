function plotsquare(square,k1,k2)

% lower right vertex
x1 = k1(square(1));
y1 = k2(square(2));
% lower left vertex
x2 = k1(square(3));
y2 = k2(square(4));
% top left vertex
x3 = k1(square(5));
y3 = k2(square(6));
% upper right vertex
x4 = k1(square(7));
y4 = k2(square(8));
% coordinates of the center of the square
k1c = x2 + (x1 - x2)/2;
k2c = y2 + (y3 - y2)/2;
hold on
rectangle('Position',[x2,y2,x1-x2,y3-y2],'LineStyle','--')
plot(k1c,k2c,'o','Linewidth',1)
hold off
