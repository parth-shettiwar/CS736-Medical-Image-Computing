function[z_align] = align2(z1,z2,num)
X1 = sum(z1(1,:),2)/num;
Y1 = sum(z1(2,:),2)/num;

X2 = sum(z2(1,:),2)/num;
Y2 = sum(z2(2,:),2)/num;

Z = (sum(z2(1,:).^2,2) + sum(z2(2,:).^2,2))/num;

C1 = sum(z1(1,:).*z2(1,:) + z1(2,:).*z2(2,:))/num;
C2 = sum(z1(2,:).*z2(1,:) - z1(1,:).*z2(2,:))/num;

mat = [X2,-Y2,1,0;Y2,X2,0,1;Z,0,X2,Y2;0,Z,-Y2,X2];
RHS = [X1;Y1;C1;C2];
final = inv(mat)*RHS;
a = final(1);
b = final(2);
s = sqrt(a.^2 + b.^2);
theta = atan2(b,a);
t1 = final(3);
t2 = final(4);
T = [t1;t2];
M = [cos(theta), -sin(theta);sin(theta),cos(theta)];
z_align = s*M*z2 + T ;
end