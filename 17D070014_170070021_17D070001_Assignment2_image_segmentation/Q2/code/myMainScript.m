clc;
clear;

load('../data/assignmentSegmentBrainGmmEmMrf.mat');

foreground_pixels = imageData(logical(imageMask));

[L, centers] = kmeans(foreground_pixels,3);
label_Image = zeros(size(imageData));
label_Image(logical(imageMask)) = L;

%Step 1 - Initialize Parameters
x_init = label_Image;
u_init = centers;
sigma_init = zeros(3,1);

for i=1:3
    data = foreground_pixels(L==i);
    u_init(i) = mean(data);
    sigma_init(i) = std(data);
end

%Training for Beta = 0.33 Starts
num_iter = 200;
x = x_init;
y = imageData.*imageMask;
u = u_init;
sigma = sigma_init;
epsilon = 1e-4;
beta = 0.33;

for i=1:num_iter
    
    %Evaluating Log Posterior Value before the ICM update
    logPosterior_beforeICM = log_Posterior(x, y, u, sigma, imageMask, beta);
    fprintf('Log Posterior Value before ICM update %d = %f\n',i,logPosterior_beforeICM);
    
    %Evaluation Class Memberships
    class_mem = class_Memberships(x, y, u, sigma, imageMask, beta);
    [~,M] = max(class_mem,[],3);
    x_update = M.*imageMask;
    
    %Evaluation Log Posterior Value after the ICM update
    logPosterior_afterICM = log_Posterior(x_update, y, u, sigma, imageMask, beta);
    fprintf('Log Posterior Value after ICM update %d = %f\n',i,logPosterior_afterICM);
    
%     Check if the update was significant, else break
    if(abs(logPosterior_afterICM - logPosterior_beforeICM) < epsilon)
        break;
    end
    
    %Updating Means and Covariances for each Class
    for j=1:3
        sum_gamma = sum(sum(class_mem(:,:,j)));
        
        u(j) = sum(sum(class_mem(:,:,j).*y));
        u(j) = u(j)/sum_gamma;
        
        sigma(j) = sqrt(sum(sum((class_mem(:,:,j).*(((y-u(j)).*imageMask).^2))))/sum_gamma);        
    end
    
    %Updating class labels
    x = x_update;
end


% beta = 0.33 was finalized because, following results were observed,
% Log Posterior Value at beta 3.000000e-01 = 55436.839844
% Log Posterior Value at beta 3.100000e-01 = 55272.009027
% Log Posterior Value at beta 3.200000e-01 = 56228.711441
% Log Posterior Value at beta 3.300000e-01 = 56844.583104
% Log Posterior Value at beta 3.400000e-01 = 55907.492185
% Log Posterior Value at beta 3.500000e-01 = 55511.293620
% We can observe that clearly we have a log likelihood maxima at beta=0.33.

%Finalizing Required Images for Beta=0.33
x_beta = x;

x_cm_beta_1 = zeros(size(x));
x_cm_beta_2 = zeros(size(x));
x_cm_beta_3 = zeros(size(x));

x_cm_beta_1(x_beta==1) = imageData(x_beta==1);
x_cm_beta_2(x_beta==2) = imageData(x_beta==2);
x_cm_beta_3(x_beta==3) = imageData(x_beta==3);


%Training for Beta = 0 Starts
num_iter = 200;
x = x_init;
y = imageData.*imageMask;
u = u_init;
sigma = sigma_init;
epsilon = 1e-4;
beta = 0;

for i=1:num_iter
    
    %Evaluating Log Posterior Value before the ICM update
    logPosterior_beforeICM = log_Posterior(x, y, u, sigma, imageMask, beta);
    fprintf('Log Posterior Value before ICM update %d = %f\n',i,logPosterior_beforeICM);
    
    %Evaluation Class Memberships
    class_mem = class_Memberships(x, y, u, sigma, imageMask, beta);
    [~,M] = max(class_mem,[],3);
    x_update = M.*imageMask;
    
    %Evaluation Log Posterior Value after the ICM update
    logPosterior_afterICM = log_Posterior(x_update, y, u, sigma, imageMask, beta);
    fprintf('Log Posterior Value after ICM update %d = %f\n',i,logPosterior_afterICM);
    
%     Check if the update was significant, else break
    if(abs(logPosterior_afterICM - logPosterior_beforeICM) < epsilon)
        break;
    end
    
    %Updating Means and Covariances for each Class
    for j=1:3
        sum_gamma = sum(sum(class_mem(:,:,j)));
        
        u(j) = sum(sum(class_mem(:,:,j).*y));
        u(j) = u(j)/sum_gamma;
        
        sigma(j) = sqrt(sum(sum((class_mem(:,:,j).*(((y-u(j)).*imageMask).^2))))/sum_gamma);        
    end
    
    %Updating class labels
    x = x_update;
end

%Finalizing Required Images for Beta=0
x_beta_zero = x;

x_cm_zero_1 = zeros(size(x));
x_cm_zero_2 = zeros(size(x));
x_cm_zero_3 = zeros(size(x));

x_cm_zero_1(x_beta==1) = imageData(x_beta==1);
x_cm_zero_2(x_beta==2) = imageData(x_beta==2);
x_cm_zero_3(x_beta==3) = imageData(x_beta==3);

pause(0.1);
figure();
imshow(imageData);
title("Corrupted image");

pause(0.1);
figure();
imshow(x_cm_beta_1);
title("Optimal Class-Membership 1 Image Estimate for Beta=0.33 ");

pause(0.1);
figure();
imshow(x_cm_beta_2);
title("Optimal Class-Membership 2 Image Estimate for Beta=0.33 ");

pause(0.1);
figure();
imshow(x_cm_beta_3);
title("Optimal Class-Membership 2 Image Estimate for Beta=0.33 ");

pause(0.1);
figure();
imagesc(x_beta);
title("Optimal Label Image Estimate for Beta=0.33"); 

pause(0.1);
figure();
imshow(x_cm_zero_1);
title("Optimal Class-Membership 1 Image Estimate for Beta=0");

pause(0.1);
figure();
imshow(x_cm_zero_2);
title("Optimal Class-Membership 2 Image Estimate for Beta=0");

pause(0.1);
figure();
imshow(x_cm_zero_3);
title("Optimal Class-Membership 2 Image Estimate for Beta=0");

pause(0.1);
figure();
imagesc(x_beta_zero);
title("Optimal Label Image Estimate for Beta=0"); 