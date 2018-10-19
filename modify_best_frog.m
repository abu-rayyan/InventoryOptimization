% disp(['checking memeplex ', num2str(memplex_id), '...'])
    memplex_sols= all_memeplex_sols(:, memplex_id);
    memplex_fitness= all_memeplex_fitness(:, memplex_id);
    memplex_pop= all_memeplex_pop(:, memplex_id);
    
    memeplex_best_pop= memplex_pop(1);
    memeplex_worst_pop= memplex_pop(end);
    Xb= memplex_sols{1}; Fb= memplex_fitness(1); % memeplex best frog
    Xw= memplex_sols{end}; Fw= memplex_fitness(end); % memeplex worst frog
    
    %% generate a new frog by manipulating the position of the best frog
    new_gen_frog.Position= Xb(:, randperm(size(Xw, 2))); % shuffling
    new_gen_frog.Cost= cost_func(new_gen_frog.Position);
    new_gen_frog.meanCost= mean(new_gen_frog.Cost);
    new_gen_frog.IsDominated= true; %arbitraray value, will later be corrected
    
    %% if new random frog is better than worst frog, replace it in the memeplex
    if Dominates(new_gen_frog,memeplex_best_pop)
        memplex_pop(1)= new_gen_frog;
        memplex_sols{1}= new_gen_frog.Position;
        memplex_fitness(1)= 1/mean(new_gen_frog.Cost); 
    elseif Dominates(new_gen_frog,memeplex_worst_pop)
        memplex_pop(end)= new_gen_frog;
        memplex_sols{end}= new_gen_frog.Position;
        memplex_fitness(end)= 1/mean(new_gen_frog.Cost); 
    else
        
    end
    all_memeplex_sols(:, memplex_id)= memplex_sols;
    all_memeplex_fitness(:, memplex_id)= memplex_fitness;
    all_memeplex_pop(:, memplex_id)= memplex_pop;