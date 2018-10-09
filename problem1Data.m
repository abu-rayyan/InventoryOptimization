f= 0.08;
h= [9 7 8 8 10 7];
S= [ 8  11	12	10	11	9 ]; %Required storage space per unit of ith product
D= [250	420	170	200	400	350
    340	180	410	130	270	290  % Di,j: Demand of ith product in period j
    320	210	110	205	415	190];
m= 6; %total products..m: Number of products
N= 4; % total periods..N: Number of replenishment cycles in the planning horizon
O= [20	18	20	18	13	13
    16	21	16	21	17	17 % Oi, j represent the minimum quantity of a product that must be ordered in period i so that there is no shortage
    11	15	12	14	15	16];
beta= [0.4	0.5	0.5	0.6	0.3	0.4];
prod_cost_in_period= [8	7	7	7	7	8
                     6	8	4	8	4	7
                     3	4	5	6	7	4];

Prices_BPs= {
    [12 11 9];
    [12 11 9];
    [10, 8];
    [10, 8];
    [10, 8];
    [13, 11];
    };

ranges=  {{[0, 20] , [20, 50], [50, inf]};
         {[0, 20] , [20, 50], [50, inf]};
         {[0, 40], [40, inf]};
         {[0, 40], [40, inf]};
         {[0, 40], [40, inf]};
         {[0, 60], [60, inf]};
         };
     
     M1= 100;
     max_cost=24000;
     batch_size=[8 7 9 8 9 6];
     max_box=3200;