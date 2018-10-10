function [Iij] = funI(h, Tij, Tijdash, Iij, period, product, f, D, product_previously_stocked, product_ordered )
% load wksp

if period==1
            Iij= Iij + h(product) * [ ((exp(-f*Tijdash) - exp(-f*(Tij-1)))/f) *  D(period, product) * ( ((exp(-f*Tijdash)*(Tijdash+1/f)- exp(-f*(Tij-1))*(Tij-1+1/f)))/(exp(-f*Tijdash)-exp(-f*0)) - ((product_previously_stocked+product_ordered)/D(period, product)) - 0) ];
else
            Iij= Iij + h(product) * [ ((exp(-f*Tijdash) - exp(-f*(Tij-1)))/f) *  D(period, product) * ( ((exp(-f*Tijdash)*(Tijdash+1/f)- exp(-f*(Tij-1))*(Tij-1+1/f)))/(exp(-f*Tijdash)-exp(-f*Tij-1)) - ((product_previously_stocked+product_ordered)/D(period, product)) - Tij-1) ];
end
