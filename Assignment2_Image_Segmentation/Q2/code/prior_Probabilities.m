function p_i = prior_Probabilities(x_i, x, beta, mask)
%PRIOR_PROBABILITIES Summary of this function goes here
%   Detailed explanation goes here

left_mask = circshift(mask,1,2);
right_mask = circshift(mask,-1,2);
top_mask = circshift(mask,1,1);
bottom_mask = circshift(mask,-1,1);

left_Va = (x_i - circshift(x,1,2)).*left_mask;
right_Va = (x_i - circshift(x,1,2)).*right_mask;
top_Va = (x_i - circshift(x,1,2)).*top_mask;
bottom_Va = (x_i - circshift(x,1,2)).*bottom_mask;

left_Va = left_Va ~= 0;
right_Va = right_Va ~= 0;
top_Va = top_Va ~= 0;
bottom_Va = bottom_Va ~= 0;

p_i = exp((left_Va + right_Va + top_Va + bottom_Va).*(-1*beta));

p = zeros(size(x,1),size(x,2),3);

for i=1:3
    x_i = ones(size(x)).*i;
    
    left_Va = (x_i - circshift(x,1,2)).*left_mask;
    right_Va = (x_i - circshift(x,1,2)).*right_mask;
    top_Va = (x_i - circshift(x,1,2)).*top_mask;
    bottom_Va = (x_i - circshift(x,1,2)).*bottom_mask;

    left_Va = left_Va ~= 0;
    right_Va = right_Va ~= 0;
    top_Va = top_Va ~= 0;
    bottom_Va = bottom_Va ~= 0;

    p(:,:,i) = exp((left_Va + right_Va + top_Va + bottom_Va).*(-1*beta));

end

% fprintf("%d",p(0,0,0))
Z = p(:,:,1)+p(:,:,2)+p(:,:,3);

p_i = p_i./Z;

p_i = p_i.*mask;

end

