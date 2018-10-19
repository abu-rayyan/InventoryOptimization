function [cost] = both_costs(Q, problem_data_file)
run(problem_data_file)
for period= 1:N-1
        if period==1
            X(period, :)= zeros(1, m);
            I(period, :)= Q(period, :) - D(period, :);
        else
            X(period, :)= I(period-1, :);
            I(period, :)= Q(period, :) + I(period-1, :) - D(period, :);
        end
        
        
        L(period, 1:m)= 0; % initializing
        for prod= 1: m
            shortage(period, prod)= 0;
            if I(period, prod)<0
                shortage(period, prod)= -I(period, prod);
                L(period, prod)= 1;
                I(period, prod)=0;
            end
        end
        
end

%% Z2
Z2= 0;
for period= 1:N-1
    for prod= 1:m
        if period>1
            Z2= Z2 + (Q(period, prod) + I(period-1, prod)) * S(prod);
        else
            Z2= Z2 +  Q(period, prod) * S(prod);
        end
    end
end

%% Z1 = A + H + LS + BO + P

%% total ordering cost A
A=0 ;
for period= 1:N-1
    for prod= 1:m
        Tij= period*Tj;
        A= A + prod_cost_in_period(period, prod) * (Q(period, prod)>=1) * exp(-f*Tij);
    end
end

%% holding cost
H= 0;
for period= 1:N-1
    for prod= 1:m
        Tij= period*Tj;
        Tijm1= (period-1)*Tj;
        if D(period, prod)<=I(period,prod) 
            percent_demand_met= 1;
        else
            percent_demand_met= I(period,prod) / D(period, prod);
        end
        Tj_dash= percent_demand_met*Tj;
        Tij_dash= Tijm1 + Tj*percent_demand_met;
        a= Tj*(1-L(period, prod)) + Tj_dash*L(period, prod);
%         H= H + h(prod) * abs (exp(-f*Tij) * [ (h(prod)/f^2) * [f*(I(period, prod) * a*D(period, prod))*(exp(-f*Tij)-exp(-f*a))-(exp(-f*Tij)*(1-f*Tij) + exp(-f*a)*(1-f*a))] * D(period, prod)]);
%         H= H + h(prod) * [ ( (exp(-f*a)-exp(-f*Tijm1)) / f) * D(period, prod) * [ ((exp(-f*a) * (a+1/f)) * exp(-f*Tijm1) * (Tijm1 + 1/f)/(exp(-f*a) - exp(-f*0))) - ((X(period, prod) + Q(period, prod))/D(period, prod)) - Tijm1] ];
%         if isnan(H) || H==inf || H==-inf
%             hh=9
%         end
        inventory_pos= @(t)((X(period, prod) + Q(period, prod) - D(period, prod) .* (t-Tijm1)) .* exp(-f*t));
        area_covered= (integral(inventory_pos, Tijm1, a));
        if area_covered>=0 % if we dont add this condition then values of tic are on the higher side
        else
%             area_covered= abs(area_covered); % if we take abs of -ve
%             area, tic is ok for problems 1 and 2 but is eplosively high
%             for problem 3
            area_covered=0;
        end
        H= H + h(prod) * area_covered; % abs coz area is always +ve
    end
end

%% BO
BO= 0;
for period= 1:N-1
    for prod= 1:m
        Tij= period*Tj;
        Tijm1= (period-1)*Tj;
        if D(period, prod)<=I(period,prod) 
            percent_demand_met= 1;
        else
            percent_demand_met= I(period,prod) / D(period, prod);
        end
        Tij_dash= Tijm1 + Tj*percent_demand_met;
        inventory_pos= @(t)(X(period, prod) + Q(period, prod) - D(period, prod) * (t-Tijm1));
        BO= BO + BO_cost(period, prod) * exp(-f*Tij) * betai(prod) * abs(integral(inventory_pos, Tij_dash, Tij)); % abs coz area is always +ve
     end
    
end

%% LS
LS= 0;
for period= 1:N-1
    for prod= 1:m
        Tij= period*Tj;
        Tijm1= (period-1)*Tj;
        if D(period, prod)<=I(period,prod) 
            percent_demand_met= 1;
        else
            percent_demand_met= I(period,prod) / D(period, prod);
        end
        Tij_dash= Tijm1 + Tj*percent_demand_met;
        inventory_pos= @(t)(X(period, prod) + Q(period, prod) - D(period, prod) * (t-Tijm1));
        LS= LS + LS_cost(period, prod) * exp(-f*Tij) * (1-betai(prod)) * abs(integral(inventory_pos, Tij_dash, Tij)); % abs coz area is always +ve
    end
end

%% P
P= 0;
for period= 1:N-1
    for prod= 1:m
        Tij= period*Tj;
        K= length(ranges{prod});
        for k= 1:K
            range_k= ranges{prod}{k};
            if Q(period, prod)>=range_k(1) && Q(period, prod)<range_k(2)
                prod_price= Prices_BPs{prod}(k) * exp(-f*Tij);
                break;
            end
        end
            
       P= P + prod_price;
    end
end

Z1 = A + H + LS + BO + P;

cost=[Z1;Z2];