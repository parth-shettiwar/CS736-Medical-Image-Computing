function class_mem = class_Memberships(x, y, u, sigma, mask, beta)
%CLASS_MEMBERSHIPS Summary of this function goes here
%   Detailed explanation goes here

likelihood = zeros(size(x,1),size(x,2),3);
prior = zeros(size(x,1),size(x,2),3);
class_mem = zeros(size(x,1),size(x,2),3);

for i=1:3
    likelihood(:,:,i) = (1/(sigma(i)*sqrt(2*pi)))*exp(-((y-u(i)).^2)/(2*(sigma(i)^2))).*mask;
    prior(:,:,i) = prior_Probabilities((ones(size(x)).*i),x,beta,mask);
    likeness = likelihood(:,:,i);
end

class_mem = likelihood.*prior ;

% for i=1:3
%     class_mem(:,:,i) = class_mem(:,:,i).*mask;
% end


scale_normalize = sum(class_mem, 3);
% fprintf("%f \n", min(min(scale_normalize(find(scale_normalize>0)))));
% epsilon = 1e-50;
for i=1:3
    class_mem(:,:,i) = class_mem(:,:,i)./(scale_normalize);
    class = class_mem(:,:,i);
    class_mem_i = class_mem(:,:,i);
    class_mem_i(~logical(mask)) = 0;
    class_mem(:,:,i) = class_mem_i;
end

% class_mem(isnan(class_mem)) = 0;

% for i=1:3
%     den = zeros(size(x));
%     for j=1:3
%         den = den + prior(:,:,j)*(sigma(i)/sigma(j))*exp(((y-u(i)).^2)/(2*(sigma(i)^2)) - ((y-u(j)).^2)/(2*(sigma(j)^2)));
%     end
%     class_mem(:,:,i) = prior(:,:,i)./den ;
% end

end

