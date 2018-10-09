%% SECTION TITLE
% DESCRIPTIVE TEXT
clear all
clc

%%
problem1Data
Z2=0 ;
A=0 ;
H= 0;
BO= 0;
LS= 0;
P= 0;
Iij= 0;

frog_population_count= 20;
frog_memplex_size= 2;
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
        [Xg, Fg] = frog_leap(period, frog_solution, frog_fitness, sfla_iter_total, num_memplexes, frog_memplex_size, cost_func, max_cost)
        product_ordered(period, :)= Xg;
        if(sum(product_ordered(period,:)./batch_size)<=max_box)
            flag2=0;
        end
        end
        [mcost, cost, shortage, product_remaining, L, back_order, lost_sale,Z2, H, A, BO, LS, P , Z1]= check_cost(product_ordered, product_previously_stocked, h, P, period, m, A, f, Z2, S, D, beta, ranges, prod_cost_in_period, Prices_BPs, BO, LS, H, product_remaining, max_cost);
%         Best(period)=cost(1);
    end
        Best=Best(1:3,1:20);
        Best1=Best1(1:3,1:20);
for u=1:3
    for k=1:length(Best)
    if(Best(u,k)<=mean(mean(Best))&&Best1(u,k)<=mean(mean(Best1)))
        No_pareto(u,k)=1; %this will check for no. pareto solution, right now i am checking with mean of best matrix.
    else No_pareto(u,k)=0;
    end
    end
end
%%Mean Ideal distance
%mean ideal distance is the distance of parato solutions from the mean of
%all solutions i am attaching its reference
%https://books.google.com.pk/books?id=9DY9DwAAQBAJ&pg=PA180&lpg=PA180&dq=mean+ideal+distance&source=bl&ots=6Uhsr3zFuW&sig=92PESLj83Cr7I-7am0_HL83Q22w&hl=en&sa=X&ved=2ahUKEwiBqJyI7_jdAhXGJVAKHfRrBJ44ChDoATACegQICBAB#v=onepage&q=mean%20ideal%20distance&f=false
%code for Mean Ideal Distance
A=find(No_pareto==1);
Cost1_pareto_sol=Best(A); %This matrix will contain the cost of inventory pareto solution
Cost2_pareto_sol=Best1(A); %this matrix will contain the storage space pareto solutions
%for the MID formula, we have to calculate the distance of these pareto
%solutions from the mean solution
MIDx=Cost1_pareto_sol-mean(mean(Best));
MIDy=Cost2_pareto_sol-mean(mean(Best1));
%Ecludian distance formula
MID=sqrt(MIDx.^2+MIDy.^2)/length(No_pareto);
Z1
Z2
disp('optimal products ordered:')
disp(product_ordered)
disp('sum of products in a period')
disp(sum(product_ordered, 2))
averageTime = toc;
disp('Average running time:')
averageTime
[k,l]=size(e);
disp('ER')
er=sum(No_pareto)./(k*l)
disp('NPS')
sum(No_pareto)
% percentage_optimal=Npareto/(k*l)    
% CVR=er/Npareto
div= index_SaW(Best) %this is the DM matric, from reference of DM i have found it. I found this m-file from net
figure(1)
boxplot(Best(3,:)','Notch','off','Labels',{'SFLA'}) %one boxplot for third period
title('Boxplot of Cost')
%%
figure(2)
boxplot(100*div(3,:)','Notch','off','Labels',{'SFLA'}) %diversity boxplot for each period
title('Box plot for DM metric')
%%
figure(3)
boxplot(MID,'Notch','off','Labels',{'SFLA'}) %MID boxplot
title('Boxplot of MID')