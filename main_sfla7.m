%% SECTION TITLE
% DESCRIPTIVE TEXT
clear all
clc
close all

for TRIAL= 1: 10
    TRIAL
%%
problem1Data
Z2=0 ;
A=0 ;
H= 0;
BO= 0;
LS= 0;
P= 0;
Iij= 0;

frog_population_count= 10;
frog_memplex_size= 5;
num_memplexes= frog_population_count/frog_memplex_size;
sfla_iter_total= 10; % we ll do it for only single iteration
Best=inf(N-1,frog_population_count+1); %initializing the matrices
Best2=inf(N-1,frog_population_count+1);
e=zeros(N-1,frog_population_count+1);
tic 

    for  period= 1: N-1
        if period==1
            product_remaining= zeros(1, m);
            product_previously_stocked=zeros(1, m);
        else
        end
        
        cost_func= @(x)(check_cost(x, product_previously_stocked, h, P, period, m, A, f, Z2, S, D, beta, ranges, prod_cost_in_period, Prices_BPs, BO, LS, H, [], max_cost));

        % initializing frog population
        for frog_id= 1: frog_population_count
            
            period_quantities= zeros(1, m);
            while sum(period_quantities)~=M1
                period_quantities= randi(100, 1, m);
            end

            frog_solution{frog_id}= period_quantities;
            product_ordered(period, :)= frog_solution{frog_id};
            [mcost, cost]= check_cost(product_ordered, product_previously_stocked, h, P, period, m, A, f, Z2, S, D, beta, ranges, prod_cost_in_period, Prices_BPs, BO, LS, H,[], max_cost);
            saved_costs(frog_id, :)= cost';
            frog_fitness(frog_id)= 1/mcost;
            Best(period,frog_id)=cost(1);
            Best1(period,frog_id)=cost(2);
            if sum(product_ordered(period,:)./batch_size)<=max_box &&frog_id< frog_population_count&& Best(period,frog_id)<max_cost %this will check for optimal solution.
                e(period,frog_id)=0;
            else e(period,frog_id)=1;
            end
        end
        flag2=1;
        while(flag2==1)
        [Xg, Fg, nps, repository_costs, repository_sols] = frog_leap(period, frog_solution, frog_fitness, sfla_iter_total, num_memplexes, frog_memplex_size, cost_func, max_cost);
        product_ordered(period, :)= Xg;
        if(sum(product_ordered(period,:)./batch_size)<=max_box)
            flag2=0;
        end
        end
        [mcost, cost, shortage, product_remaining, L, back_order, lost_sale,Z2, H, A, BO, LS, P , Z1]= check_cost(product_ordered, product_previously_stocked, h, P, period, m, A, f, Z2, S, D, beta, ranges, prod_cost_in_period, Prices_BPs, BO, LS, H, product_remaining, max_cost);
%         Best(period)=cost(1);
    end
   time_taken= toc; 
% 
% Z1
% Z2
% 
% disp('optimal products ordered:')
% disp(product_ordered)
% disp('sum of products in a period')
% disp(sum(product_ordered, 2))

%% Mean Ideal distance
%mean ideal distance is the distance of parato solutions from the mean of
%all solutions i am attaching its reference
%https://books.google.com.pk/books?id=9DY9DwAAQBAJ&pg=PA180&lpg=PA180&dq=mean+ideal+distance&source=bl&ots=6Uhsr3zFuW&sig=92PESLj83Cr7I-7am0_HL83Q22w&hl=en&sa=X&ved=2ahUKEwiBqJyI7_jdAhXGJVAKHfRrBJ44ChDoATACegQICBAB#v=onepage&q=mean%20ideal%20distance&f=false
%code for Mean Ideal Distance
ideal_sol_id= find(mean(repository_costs, 2) == min(mean(repository_costs, 2)));
best_cost= repository_costs(ideal_sol_id, :);
for pareto_sols= 1: size(repository_sols, 1)
    distance(pareto_sols, :)= abs(norm(repository_costs(pareto_sols, :) - best_cost));
end
MID(TRIAL, 1)= mean(distance) ; % smaller value means better convergence according to https://books.google.com.pk/books?id=9DY9DwAAQBAJ&pg=PA180&lpg=PA180&dq=mean+ideal+distance&source=bl&ots=6Uhsr3zFuW&sig=92PESLj83Cr7I-7am0_HL83Q22w&hl=en&sa=X&ved=2ahUKEwiBqJyI7_jdAhXGJVAKHfRrBJ44ChDoATACegQICBAB#v=onepage&q=mean%20ideal%20distance&f=false
disp(['MID:', num2str(MID(TRIAL, 1))])

%% CPU time
cpuTime(TRIAL, 1) = time_taken;
disp(['CPU time:', num2str(cpuTime(TRIAL, 1))])

%% NPS
NPS(TRIAL, 1)= nps;
disp(['NPS:', num2str(NPS(TRIAL, 1))])

%% ER
[k,l]=size(e);
er(TRIAL, 1)=sum(nps)./(k*l);
disp(['ER:', num2str(er(TRIAL, 1))])

%% DM
best_sol= repository_sols(ideal_sol_id, :);
cost_trial(TRIAL, :)= best_cost;
div= index_SaW(repository_sols); %this is the DM matric, from reference of DM i have found it. I found this m-file from net
DM(TRIAL, 1)= 100*mean(mean(div));
disp(['DM:', num2str(DM(TRIAL, 1))])

%% CVR
cvr(TRIAL, 1)= er(TRIAL, 1)/nps;
disp(['CVR:', num2str(cvr(TRIAL, 1))])

end

%% boxplots
figure; boxplot(MID,'Notch','off','Labels',{'SFLA'}); ylabel('MID') %MID boxplot
figure; boxplot(NPS,'Notch','off','Labels',{'SFLA'}) ; ylabel('NPS')
figure; boxplot(er,'Notch','off','Labels',{'SFLA'}) ; ylabel('ER')
figure; boxplot(DM,'Notch','off','Labels',{'SFLA'}) ; ylabel('DM')

%%
disp('Results of the 10 trials are:');
for i=1:10
    RunNo{i, 1}= num2str(i);
end
RunNo{end+1}= 'Ave';
RunNo{end+1}= 'St.dev';

NPS= [NPS; mean(NPS); std(NPS)];
er= [er; mean(er); std(er)];
cpuTime= [cpuTime; mean(cpuTime); std(cpuTime)];
MID= [MID; mean(MID); std(MID)];
DM= [DM; mean(DM); std(DM)];

T = table(RunNo, NPS, er, cpuTime, MID, DM);
disp(T)

% later we will plot them in ascending order of their mean
plot(cost_trial(:, 2), cost_trial(:,1), 'rx')
xlabel('TSS'); ylabel('TIC');

