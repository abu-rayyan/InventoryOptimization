function [Xg, Fg, nps, repository_costs, repository_sols] = frog_leap(period, frog_solution, frog_fitness, sfla_iter_total, num_memplexes, frog_memplex_size, cost_func, max_cost)
% frog_memplex_size= pop/num_memplexes;
%% frog leap iterations
max_cost1=max_cost;
nps= 0;
repository_costs= [];
repository_sols= [];
for sfla_count= 1: sfla_iter_total
    disp(['sfla iteration: ' , num2str(sfla_count)])
   
    %% % sort all frogs in descending order of fitness
[sorted_fitness, sorted_inds]= sort(frog_fitness, 'descend'); 
sorted_solutions= frog_solution(sorted_inds);

Xg= sorted_solutions{1}; % Assign the first population (frog) as global (best) frog,Xg.

%%  Partition the entire population into m memeplexes such that each contains n frogs. see the below created 3 variables 
% in workspace to get a better idea/ visualization of what a memeplex looks
% like and keep in mind that:
% column==> memplex    % row==> frog
all_memeplex_inds= reshape(sorted_inds, [num_memplexes, frog_memplex_size])';
all_memeplex_sols= reshape(sorted_solutions, [num_memplexes, frog_memplex_size])';
all_memeplex_fitness= reshape(sorted_fitness, [num_memplexes, frog_memplex_size])';

%% for each memeplex find the best frog and the worst frog
for memplex_id= 1: num_memplexes
    disp(['checking memeplex ', num2str(memplex_id), '...'])
    memeplex_sols= all_memeplex_sols(:, memplex_id);
    memeplex_fitness= all_memeplex_fitness(:, memplex_id);
    Xb= memeplex_sols{1}; Fb= memeplex_fitness(1); % memeplex best frog
    Xw= memeplex_sols{end}; Fw= memeplex_fitness(end); % memeplex worst frog
    
    disp('generating new frog...')
    
    %% generate a new frog by manipulating the position of the best frog
    % Create Neighbor
    new_gen_frog= Xb(randperm(length([Xb]))); % shuffling
    product_ordered(period, :)= new_gen_frog;
    new_gen_frog_fitness= 1/cost_func(product_ordered);
    
    %% if new random frog is better than worst frog, replace it in the memeplex
    if new_gen_frog_fitness>Fw
        disp ('new frog is better than the worst frog in this memeplex, so replacing...')
        memeplex_sols{end}= new_gen_frog;
        memeplex_fitness(end)= new_gen_frog_fitness; 
        all_memeplex_sols(:, memplex_id)= memeplex_sols;
        all_memeplex_fitness(:, memplex_id)= memeplex_fitness;
    else % otherwise create a new frog in placea of the worst frog of the memeplex
        [mcost, cost]= cost_func(product_ordered)
        nps= nps+1;
        repository_costs= [repository_costs ; cost'];
        repository_sols= [repository_sols ; Xb];
%         period_quantities= zeros(1, length(Xb));
%             while sum(period_quantities)~=sum(Xb)
%                 period_quantities= randi(100, 1, length(Xb));
%             end
%         memeplex_sols{end}= period_quantities;
%         memeplex_fitness(end)= new_gen_frog_fitness; 
%         all_memeplex_sols(:, memplex_id)= memeplex_sols;
%         all_memeplex_fitness(:, memplex_id)= memeplex_fitness;
    end
end

%% combining all memeplex frogs together (they will be arranged in decending order and sorted into memeplexes in next iteration...and so on)
combined_memeplexes= all_memeplex_sols(:);
combined_fitness= all_memeplex_fitness(:);
frog_fitness= combined_fitness;
frog_solution= combined_memeplexes;

end

[sorted_fitness, sorted_inds]= sort(frog_fitness, 'descend'); 
sorted_solutions= frog_solution(sorted_inds);
Xg= sorted_solutions{1}; % Assign the first population (frog) as global (best) frog,Xg.
Fg= sorted_fitness(1);