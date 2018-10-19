function [Q] =  generate_possible_solution1 (problem_data_file)
run(problem_data_file)
cost= inf;
tot_boxes= inf;

while cost>max_cost && tot_boxes>M2
for period= 1:N-1
            for prod= 1:m
                if period==1
                    box_shortagae= 0;
                else
                    box_shortagae= round(shortage(period-1, prod)/B(prod));
                    if box_shortagae>=M1
                        box_shortagae= M1;
                    end
                end
                period_boxes(period, prod)=  randi([box_shortagae, M1], 1, 1);%10 in place of M1
                period_quantities(period, prod)= B(prod) * period_boxes(period,prod);
                
                if period==1
                    X(period, prod)= 0;
                    I(period, prod)= period_quantities(period, prod) - D(period, prod);
                else
                    X(period, prod)= I(period-1, prod);
                    I(period, prod)= period_quantities(prod) + I(period-1, prod) - D(period, prod);
                 end

                shortage(period, prod)= 0;
                if I(period, prod)<0
                    shortage(period, prod)= -I(period, prod);
                    I(period, prod)=0;
                end

            end
        Q= period_quantities;
end
cost= 0;
for period= 1:N-1
    cost= cost + sum( Q(period, :) .* prod_cost_in_period(period, :) );
end
tot_boxes= sum(sum(period_boxes));

end
