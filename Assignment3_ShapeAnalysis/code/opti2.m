function[z_mean,ztot] = opti2(data)

ztot = data.pointSets;
num = data.numOfPoints;
numset = data.numOfPointSets;
z_mean = ztot(:,:,1);
z_mean = z_mean - (sum(z_mean,2)/num);
z_mean = z_mean/norm(z_mean);

ztemp = ztot;
for i = 1:25
    for j = 1:300
        ztemp(:,:,j) = align2(z_mean,ztot(:,:,j),num);
    end
    z_mean = sum(ztemp,3)/numset;
    z_mean = z_mean/norm(z_mean);
    ztot = ztemp;
    
end

end
