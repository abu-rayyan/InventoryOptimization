f= 0.08;
h= [9 7 8 8 9 6 6 8];
S= [ 8  11	12	10	11	9 12 9]; %Required storage space per unit of ith product
D= [250	420	170	200	400	350 330 150
    340	180	410	130	270	290 210 240 % Di,j: Demand of ith product in period j
    320	210	110	205	415	190 190 190];
m= 8; %total products..m: Number of products
N= 4; % total periods..N: Number of replenishment cycles in the planning horizon
O= [20	18	20	18	13	13 21 14
    16	21	16	21	17	17 16 16% Oi, j represent the minimum quantity of a product that must be ordered in period i so that there is no shortage
    11	15	12	14	15	16 18 17];
betai= [0.4	0.5	0.5	0.6	0.3	0.4 0.3 0.45];
B= [8 7 9 8 9 6 6 8];
prod_cost_in_period= [8	7	7	7	7	8 6 4
                     6	8	4	8	4	7 7 9
                     3	4	5	6	7	4 4 6];

Prices_BPs= {
    [16 13 11];
    [16 13 11];
    [16,13,11];
    [16,13 11];
    [16,13,11];
    [16,13,11];
    [16,13,11];
    [16,13,11];
    };

ranges=  {{[0, 25] , [25, 60], [60, inf]};
         {[0, 25] , [25, 60], [60, inf]};
         {[0, 25], [25,60], [60,inf]};
         {[0, 25], [25,60], [60,inf]};
         {[0, 25], [25,60],[60,inf]};
         {[0, 25], [25,60],[60,inf]};
         {[0, 25], [25,60],[60,inf]};
         {[0, 25], [25,60],[60,inf]};
         };
     
     M1= 100;
     max_cost=25000;
     batch_size=[8 7 9 8 9 6 6 8];
     max_box=3200;
     
     
     M2= max_box;
     
     T(1:m-1)=2; % each product takes 2 units of time in each period
     Tj= 2;
     
     LS_cost=   [8 7 7 7 7 8 6 4;
                6 8 4 8 4 7 7 9;
                3 4 5 6 7 4 4 6];

     BO_cost=   [9 5 9 5 9 9 10 8;
                 4 9 4 9 7 4 4 5;
                 6 5 4 7 8 6 8 0];