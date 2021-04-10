function[V,D] = eigen(ztot)
new_ztot = reshape(ztot,[112,40]).';
var = cov(new_ztot);
[V,D] = eig(var);
end