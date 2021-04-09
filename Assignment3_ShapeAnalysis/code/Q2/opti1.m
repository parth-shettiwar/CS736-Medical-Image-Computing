function[z_mean,ztot] = opti1(data)

ztot = data.shapes;
num = 56;
numset = 40;
z_mean = ztot(:,:,1);
z_mean = z_mean - sum(z_mean,2)/num;
z_mean = z_mean/norm(z_mean);

ztot = ztot - sum(ztot,2)/num;
ztot = reshape(ztot,[112,40]);
temp1 = vecnorm(ztot,2,1);
temp2 = repelem(temp1,112,1);

ztot = reshape(ztot./temp2,[2,56,40]);

ztemp = ztot;
for i = 1:25
    for j = 1:40
        ztemp(:,:,j) = align1(z_mean,ztot(:,:,j),num);
    end
    z_mean = sum(ztemp,3)/numset;
    z_mean = z_mean/norm(z_mean);
    ztot = ztemp;
    te3 = reshape(ztot,[112,40]);
end
end