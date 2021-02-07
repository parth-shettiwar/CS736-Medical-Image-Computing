
function[Pred, objective_list] =Q1(Noisy,alpha,gamma,model) 
% Z = load("/home/adminpc/Documents/Sem8/MIC/Assignments/assignmentImageDenoising/data/assignmentImageDenoisingPhantom.mat");
% Noisy = Z.imageNoisy;
Pred = Noisy;
update = 10;
% model = 2;
count  = 0 ;
% alpha = 0.91;
lr = .1;
% gamma = 0.007;
prev_obj = 1e10;
past_Pred = Pred;
objective_list = zeros(300);
i = 1;
while(i<=300)
    
    if(model==1)
        prior = 2*(Pred - circshift(Pred,-1,1) + Pred - circshift(Pred,1,1) + Pred - circshift(Pred,-1,2) + Pred - circshift(Pred,1,2));
        objective = sum(sum((Pred - circshift(Pred,-1,1)).^2 + (Pred - circshift(Pred,1,1)).^2 + (Pred - circshift(Pred,-1,2)).^2 + (Pred - circshift(Pred,1,2)).^2));
    end   
    
    if(model==2)
%         dd = sign(Pred - circshift(Pred,1,1));
        flag1 = (abs((Pred - circshift(Pred,-1,1)))>gamma) ;
        flag2 = (abs((Pred - circshift(Pred,1,1)))>gamma) ;
        flag3 = (abs((Pred - circshift(Pred,-1,2)))>gamma) ;
        flag4 = (abs((Pred - circshift(Pred,1,2)))>gamma) ;
%         disp((Pred - circshift(Pred,-1,1)));
        prior = (1-flag1).*(Pred - circshift(Pred,-1,1)) + flag1.*sign(Pred - circshift(Pred,-1,1)).*gamma;
        prior = prior + (1-flag2).*(Pred - circshift(Pred,1,1)) + flag2.*sign(Pred - circshift(Pred,1,1)).*gamma;
        prior = prior + (1-flag3).*(Pred - circshift(Pred,-1,2)) + flag3.*sign(Pred - circshift(Pred,-1,2)).*gamma;
        prior = prior + (1-flag4).*(Pred - circshift(Pred,1,2)) + flag4.*sign(Pred - circshift(Pred,1,2)).*gamma;
        objective = 0.5*((1-flag1).*abs(Pred - circshift(Pred,-1,1)).^2 + (1-flag2).*abs(Pred - circshift(Pred,1,1)).^2 + (1-flag3).*abs(Pred - circshift(Pred,-1,2)).^2+ (1-flag4).*abs(Pred - circshift(Pred,1,2)).^2 );
        objective = objective + flag1.*gamma*(abs(Pred - circshift(Pred,-1,1))) + flag2.*gamma*(abs(Pred - circshift(Pred,1,1))) + flag3.*gamma*(abs(Pred - circshift(Pred,-1,2))) + flag4.*gamma*(abs(Pred - circshift(Pred,1,2))) - 2*gamma^2;    
        objective = sum(sum(objective));
    end    
    if(model==3)
        prior = gamma.*(Pred - circshift(Pred,-1,1))./(gamma +abs(Pred - circshift(Pred,-1,1)));
        prior = prior + (gamma.*(Pred - circshift(Pred,1,1))./(gamma +abs(Pred - circshift(Pred,1,1))));
        prior = prior + (gamma.*(Pred - circshift(Pred,-1,2))./(gamma +abs(Pred - circshift(Pred,-1,2))));
        prior = prior + (gamma.*(Pred - circshift(Pred,1,2))./(gamma +abs(Pred - circshift(Pred,1,2))));
        objective = gamma*(abs(Pred - circshift(Pred,-1,1))+abs(Pred - circshift(Pred,1,1))+abs(Pred - circshift(Pred,-1,2))+ abs(Pred - circshift(Pred,1,2)));
        objective = objective - gamma^2*log((1+abs(Pred - circshift(Pred,-1,1))/gamma)*(1+abs(Pred - circshift(Pred,1,1))/gamma)*(1+abs(Pred - circshift(Pred,-1,2))/gamma)*(1+abs(Pred - circshift(Pred,1,2))/gamma));
        objective = sum(sum(objective));
    end    
    likelihood = 2*(Pred-Noisy);
    
    update = alpha*prior + (1-alpha)*likelihood;
    objective =  alpha*objective + (1-alpha)*sum(sum(likelihood));
    if(objective<=prev_obj)
        prev_obj = objective;
        past_Pred = Pred;
        Pred = Pred- lr*update;
        past_update = update;
        lr = lr + 0.005*lr;
        objective_list(i) = objective;
        
        i = i + 1;
        
        
    else
        lr = lr - 0.005*lr;
        Pred = past_Pred - past_update*lr;
    end    
    
    
    
    count = count + 1;
    
    
    
end    

end
