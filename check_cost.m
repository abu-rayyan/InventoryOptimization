function [mcost, cost, shortage, product_remaining, L, back_order, lost_sale,Z2, H, A, BO, LS, P , Z1]= check_cost(product_ordered, product_previously_stocked, h, P, period, m, A, f, Z2, S, D, beta, ranges, prod_cost_in_period, Prices_BPs, BO, LS, H, product_remaining, max_cost)
%        try
shortage(period, 1:m)= zeros(1, m);
flag3=1;
while(flag3==1)
for product= 1:m
           if product_ordered(period, product)>=1
            W(period, product)= 1;
        else
            W(period, product)=0;
           end
        Tij= period; %Ti,j: Total time elapsed up to and including the jth replenishment cycle of the ith product
%         T(period, product)= Tij;
        A= A + prod_cost_in_period(period, product)*W(period, product)*exp(-f*Tij);
        
        product_total= product_previously_stocked(product) + product_ordered(period, product);
        Z2= Z2 + product_total*S(product);
        
        product_demand= D(period, product);
        product_diff= product_total - product_demand;
        
        percent_back_order= beta(product);
        
        if product_diff<=0
            product_remaining(period, product)= 0;
            try
            shortage(period, m)= -product_diff;
            catch
                rnf=87
            end
        else
            product_remaining(period, product)= product_diff;
            shortage(period, product)= 0;
        end
        
        if shortage(period, product)>0
            L(period, product)=1;
            Tijdash= 0.5;
        else
            L(period, product)=0;
            Tijdash= 1;
        end 
        
        a= Tij*(1- L(period, product)) + Tijdash * L(period, product);
%         H= H + h(product) * [ ((exp(-f*a) - exp(-f*(Tij-1)))/f) * D(period, product) * ( ((exp(-f*a)*(a+1/f)- exp(-f*(Tij-1))*(Tij-1+1/f)))/(exp(-f*a)-exp(-f*T(period-1, 0)))) - ((product_previously_stocked+product_ordered(period, product))/D(period, product)) - (T(period-1, product)) ) ];
        if period==1
            H= H + h(product) * exp(f);% [ ((exp(-f*a) - exp(-f*(Tij-1)))/f) *  D(period, product) * ( ((exp(-f*a)*(a+1/f)- exp(-f*(Tij-1))*(Tij-1+1/f)))/(exp(-f*a)-exp(-f*0)) - ((product_previously_stocked+product_ordered(period, product))/D(period, product)) - 0) ];
        else
            H= H + h(product) * exp(f);% [ ((exp(-f*a) - exp(-f*(Tij-1)))/f) *  D(period, product) * ( ((exp(-f*a)*(a+1/f)- exp(-f*(Tij-1))*(Tij-1+1/f)))/(exp(-f*a)-exp(-f*Tij-1)) - ((product_previously_stocked+product_ordered(period, product))/D(period, product)) - Tij-1) ];
        end
        back_order(period, product)= percent_back_order * shortage(period, product); % num of products back- ordered
        lost_sale(period, product)= (1-percent_back_order) * shortage(period, product);% num of products of lost- sale
        
        back_order_cost= back_order(period, product) * prod_cost_in_period(period, product);
        lost_sale_cost= lost_sale(period, product) * prod_cost_in_period(period, product);
        
%       Iij= funI(h, Tij, Tijdash, Iij, period, product, f, D, product_previously_stocked, product_ordered(period, product) );
        BO= BO + back_order_cost * exp(f); %  exp(-f*Tij) * beta(product) * Iij; %integral(funI, Tijdash, Tij);
        LS= LS + lost_sale_cost *  exp(f); %exp(-f*Tij) * (1-beta(product)) * Iij; %integral(funI, Tijdash, Tij);
        
%         Ui,j,k: A binary variable; set equal 1 if item i is purchased at
%         price break point k in period j, and 0 otherwise 1
        
        K= length(ranges{product});
        
        for k= 1:K
            range_k= ranges{product}{k};
%             if prod_cost_in_period(period, product)>=range_k(1) && prod_cost_in_period(period, product)<range_k(2)
%                 Uijk= 1;
%             else 
%                 Uijk= 0;
%             end
            
            Pik= Prices_BPs{product}(k);
            P= P + product_ordered(period, product) *Pik * exp(-f*Tij);
        end
   Z1= A + H + BO + LS + P;
   if(Z1<max_cost)
       flag3=0;
   end
end
end
   cost= [Z1; Z2];
   mcost= mean(cost);
   