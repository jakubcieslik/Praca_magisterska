x = out.yout{1}.Values.Data;
y = out.yout{2}.Values.Data;
z = out.yout{3}.Values.Data;

plot3(x, y, z)
xlabel('x')
ylabel('y')
zlabel('z')
title('Trajektoria fazowa układu Rösslera')
grid on
