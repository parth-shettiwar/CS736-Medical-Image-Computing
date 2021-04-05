function[V,D] = eigen(ztot)
new_ztot = reshape(ztot,[64,300]).';
var = cov(new_ztot);
[V,D] = eig(var);
end