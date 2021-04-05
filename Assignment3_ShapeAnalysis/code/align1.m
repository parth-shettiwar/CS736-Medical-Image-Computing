function[z_align] = align1(z1,z2,num)

C1 = sum(z1(1,:).*z2(1,:) + z1(2,:).*z2(2,:))/num;
C2 = sum(z1(2,:).*z2(1,:) - z1(1,:).*z2(2,:))/num;

theta = atan2(C2,C1);

M = [cos(theta), -sin(theta);sin(theta),cos(theta)];
z_align = M*z2  ;
end