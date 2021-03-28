function logPosterior = log_Posterior(x, y, u, sigma, mask, beta)
%LOG_POSTERIOR Summary of this function goes here
%   Detailed explanation goes here

log_likelihood = zeros(size(x));

x_is_1 = find(x==1);
x_is_2 = find(x==2);
x_is_3 = find(x==3);

log_likelihood(x_is_1) = -1*log(sigma(1)) - ((y(x_is_1)-u(1))/(sigma(1)^2));
log_likelihood(x_is_2) = -1*log(sigma(2)) - ((y(x_is_2)-u(2))/(sigma(2)^2));
log_likelihood(x_is_3) = -1*log(sigma(3)) - ((y(x_is_3)-u(3))/(sigma(3)^2));

% log_likelihood(x_is_1) = 1/(sigma(1)*sqrt(2*pi))+((-(y(x_is_1)-u(1)).^2)/(2*(sigma(1)^2)));
% log_likelihood(x_is_2) = 1/(sigma(2)*sqrt(2*pi))*exp((-(y(x_is_2)-u(1)).^2)/(2*(sigma(2)^2)));
% log_likelihood(x_is_3) = 1/(sigma(3)*sqrt(2*pi))*exp((-(y(x_is_3)-u(1)).^2)/(2*(sigma(3)^2)));

% likelihood_min = min(min(likelihood(x_is_1)));
% likelihood_min = min(min(likelihood(x_is_1)));
% likelihood_min = min(min(likelihood(x_is_1)));

prior = prior_Probabilities(x,x,beta,mask);
log_prior = log(prior);
% posterior = likelihood.*prior;
logPosterior = log_likelihood + log_prior;

% logPosterior = logPosterior./max(max(logPosterior));
% logmax = max(max(logPosterior));
% logmin = min(min(logPosterior));
% logPosterior = log(posterior(logical(mask)));
logPosterior = sum(sum(logPosterior(logical(mask))));

end

