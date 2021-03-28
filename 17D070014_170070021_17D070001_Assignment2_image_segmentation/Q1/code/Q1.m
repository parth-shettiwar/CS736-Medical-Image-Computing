function [init_membership,final,bias,res_image,membership,objlist,means] = Q1(img_mri_masked,mask,init_means,ne_mask,q)


obj = 10000;
prev_obj = 0;

trip_img = permute(cat(3,img_mri_masked,img_mri_masked,img_mri_masked),[3,1,2]);
init_dist = (trip_img - init_means).^2;
init_dist(init_dist<=0) = 10000;
dist_mask = permute(cat(3,mask,mask,mask),[3,1,2]);
init_membership = dist_mask.*((init_dist.^(-1/(q-1)))./(repmat(sum(init_dist.^(-1/(q-1))),3,1,1)));
means = init_means.';

bias = ones(size(img_mri_masked));

membership = init_membership;
% init_estimate = reshape((init_means.')*reshape(init_membership,[3,256*256]),[256,256]);
diff = 100;

count = 1;
objlist = zeros(1,100);
while(abs(diff)>1e-4)
    prev_obj = obj;
    for i = 1:3    
       dist(i,:,:) = (img_mri_masked.^2 - 2*means(i)*img_mri_masked.*conv2(ne_mask,bias.*mask,'same') + means(i)^2*conv2(ne_mask,(bias.^2).*mask,'same')).*mask;
    end    

    obj =  sum(sum(sum((membership.^q).*dist)));
    dist(dist<=0) = 10000;
    membership = dist_mask.*((dist.^(-1/(q-1)))./(repmat(sum(dist.^(-1/(q-1))),3,1,1)));
    
    tee = means*(reshape(membership.^(q),[3,256*256]));
    tee = reshape(tee,[256,256]);

    bias_num = conv2(ne_mask,img_mri_masked.*tee,'same');
    bias_deno = conv2(ne_mask,mask.*reshape((means.^(2))*(reshape(membership.^(q),[3,256*256])),[256,256]),'same');
    bias_deno(mask==0) = 1000;
    bias = mask.*(bias_num./(bias_deno));
    
    tee2 = img_mri_masked.*conv2(ne_mask,mask.*bias,'same');
    tee3 = permute(cat(3,tee2,tee2,tee2),[3,1,2]);
    means_num = sum(sum(membership.^(q).*tee3,3),2);
    
    tee4 = conv2(ne_mask,mask.*bias.^2,'same');
    means_deno = sum(sum(membership.^(q).*permute(cat(3,tee4,tee4,tee4),[3,1,2]),3),2);
    means = squeeze(means_num./means_deno).';
    
    diff = obj-prev_obj;
    objlist(count) = obj;
    count = count+1;
    
end

final = reshape(means*reshape(membership,[3,256*256]),[256,256]);
res_image = img_mri_masked - final.*bias;
end