clear; clc; close all

%% Problem Definition
problem_data_file= 'problem3Data'; run(problem_data_file)
cost_func=@(Q) both_costs(Q, problem_data_file);

%% MOPSO Parameters
nRep=20;            % Repository Size
frog_memplex_size= 5;
num_memplexes= 20;%frog_population_count/frog_memplex_size;
nPop= frog_memplex_size * num_memplexes; % Population Size
sfla_iter= 5;

for TRIAL = 1:10
    disp(['TRIAL#', num2str(TRIAL)])
    
%% Initialization
frog_mean_fitness= [];
disp('Initializing population')
for i=1:nPop
    pop(i).Position=generate_possible_solution1(problem_data_file);
    pop(i).Cost=cost_func(pop(i).Position);  
    pop(i).meanCost= mean(pop(i).Cost);
    
    frog_solution{i, :}= pop(i).Position;
    frog_mean_fitness(i, :)= 1/pop(i).meanCost;
end

% Determine Domination
pop=DetermineDomination(pop);
% rep=pop(~[pop.IsDominated]);
tic
disp('Applying SFLA')
%%  Main Loop
sfla_iter_total= 10; % we ll do it for only single iteration
nps= 0 ; repository_costs= []; repository_sols= [];
for it=1:sfla_iter
    % sort all frogs in descending order of fitness
    [sorted_fitness, sorted_inds]= sort(frog_mean_fitness, 'descend'); 
    sorted_solutions= frog_solution(sorted_inds);
    all_memeplex_sols= reshape(sorted_solutions, [num_memplexes, frog_memplex_size])';
    all_memeplex_fitness= reshape(sorted_fitness, [num_memplexes, frog_memplex_size])';
    all_memeplex_pop= reshape(pop, [num_memplexes, frog_memplex_size])';

    %% for each memeplex find the best frog and the worst frog
for memplex_id= 1: num_memplexes
    modify_worst_frog
%     modify_best_frog
%     generate_new_sol
end

%% combining all memeplex frogs together (they will be arranged in decending order and sorted into memeplexes in next iteration...and so on)
frog_solution= all_memeplex_sols(:);
frog_mean_fitness= all_memeplex_fitness(:);
pop= all_memeplex_pop(:);

end

[sorted_fitness, sorted_inds]= sort(frog_mean_fitness, 'descend'); 
sorted_solutions= frog_solution(sorted_inds);
pop= pop(sorted_inds);

pop=DetermineDomination(pop);

rep=pop([pop.IsDominated]);
rep_mean= [];
rep_all_costs= [];
for i= 1:length(rep)
    rep_mean= [rep_mean ; rep(i).meanCost];
    rep_all_costs= [rep_all_costs ; (rep(i).Cost)'];
%     plot(rep(i).Cost(2) , rep(i).Cost(1)/10 , 'rx')
%     hold on
end
% xlabel('TSS')
% ylabel('TIC')

ideal_sol_id= find(rep_mean== min(rep_mean));%%%%%MIN
ideal_sol_id1= find(rep_mean== max(rep_mean));
best_rep_cost= rep(ideal_sol_id).Cost;
best_rep_pos= rep(ideal_sol_id).Position;

% mean_rep_cost= 
%%
time_taken= toc; 
%% Mean Ideal distance
%mean ideal distance is the distance of parato solutions from the mean of
%all solutions i am attaching its reference
%https://books.google.com.pk/books?id=9DY9DwAAQBAJ&pg=PA180&lpg=PA180&dq=mean+ideal+distance&source=bl&ots=6Uhsr3zFuW&sig=92PESLj83Cr7I-7am0_HL83Q22w&hl=en&sa=X&ved=2ahUKEwiBqJyI7_jdAhXGJVAKHfRrBJ44ChDoATACegQICBAB#v=onepage&q=mean%20ideal%20distance&f=false
%code for Mean Ideal Distance
% ideal_sol_id= find((repository_costs == min(mean(repository_costs, 2));
% best_cost= repository_costs(ideal_sol_id, :);
mean_sol= [];
for pareto_sols= 1: length(rep)
    z = cat(3,rep(pareto_sols).meanCost,mean_sol);
    mean_sol= mean(z,3);
end

for pareto_sols= 1: length(rep)
%         distance(pareto_sols, :)= sqrt(rep(pareto_sols).Cost(1) .^ 2 +rep(pareto_sols).Cost(2).^ 2);
%         distance(pareto_sols, :)= sqrt(rep(pareto_sols).Cost(1) .^ 2 +rep(pareto_sols).Cost(2).^ 2);
%         distance(pareto_sols, :)= (norm(rep(pareto_sols).Position(:) - zeros(m*(N-1), 1)));
%         distance(pareto_sols, :)= (norm(rep(pareto_sols).Position(:) - rep(ideal_sol_id1).Position(:) ));
        distance(pareto_sols, :)= (norm(rep(pareto_sols).meanCost(:) -mean_sol(:) ));
        
end
MID(TRIAL, 1)= min(distance) ; % smaller value means better convergence according to https://books.google.com.pk/books?id=9DY9DwAAQBAJ&pg=PA180&lpg=PA180&dq=mean+ideal+distance&source=bl&ots=6Uhsr3zFuW&sig=92PESLj83Cr7I-7am0_HL83Q22w&hl=en&sa=X&ved=2ahUKEwiBqJyI7_jdAhXGJVAKHfRrBJ44ChDoATACegQICBAB#v=onepage&q=mean%20ideal%20distance&f=false
disp(['MID:', num2str(MID(TRIAL, 1))])

%% CPU time
cpuTime(TRIAL, 1) = time_taken;
disp(['CPU time:', num2str(cpuTime(TRIAL, 1))])

%% NPS
NPS(TRIAL, 1)= nPop-length(rep);
disp(['NPS:', num2str(NPS(TRIAL, 1))])

%% ER
er(TRIAL, 1)= length(rep)/nPop;
disp(['ER:', num2str(er(TRIAL, 1))])

%% DM
% best_sol= repository_sols(ideal_sol_id, :);
cost_trial(TRIAL, :)= best_rep_cost;
div= index_SaW(rep_all_costs); %this is the DM matric, from reference of DM i have found it. I found this m-file from net
DM(TRIAL, 1)= 100*mean(mean(div));
disp(['DM:', num2str(DM(TRIAL, 1))])

%% CVR
cvr(TRIAL, 1)= er(TRIAL, 1)/length(rep);
disp(['CVR:', num2str(cvr(TRIAL, 1))])
end
save results
%% boxplots
figure; boxplot(MID,'Notch','off','Labels',{'SFLA'}); ylabel('MID') %MID boxplot
figure; boxplot(NPS,'Notch','off','Labels',{'SFLA'}) ; ylabel('NPS')
figure; boxplot(er,'Notch','off','Labels',{'SFLA'}) ; ylabel('ER')
figure; boxplot(DM,'Notch','off','Labels',{'SFLA'}) ; ylabel('DM')

%%
disp('Results of the 10 trials are:');
RunNo= {};
for i=1:TRIAL
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
%     
% % later we will plot them in ascending order of their mean
% plot(mean(:, 2), cost_trial(:,1), 'rx')
% xlabel('TSS'); ylabel('TIC');

mcosts= mean(cost_trial, 2);
[sorted_fitness, sorted_inds]= sort(mcosts);
cost_trial= cost_trial(sorted_inds, :);
plot(cost_trial(:, 2), cost_trial(:,1), 'rx')
xlabel('TSS'); ylabel('TIC');