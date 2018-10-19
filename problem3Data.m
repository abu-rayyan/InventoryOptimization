f= 0.08;
h= [10 7 9 6 4 11 5 3 7 8];
S= [12 9 11 10 8 5 10 9 13 12]; %Required storage space per unit of ith product
D= [220	350	214	130	300	250 330 150 230 250
    180	210	260	315	220	170 305 130 340 150% Di,j: Demand of ith product in period j
    320	210	110	205	415	190 190 190 160 350
    150 230 190 165 325 300 200 140 160 350];
m= 10; %total products..m: Number of products
N= 5; % total periods..N: Number of replenishment cycles in the planning horizon
O= [16 	17	19	22	13	21 14 16 15 15
    15  19  22  21  11  14 15 19 12 14% Oi, j represent the minimum quantity of a product that must be ordered in period i so that there is no shortage
    16  13  14  12  16  13 13 18 23 20
    20  17  13  16  16  14 19 16 21 15];
betai= [0.3	0.5	0.6	0.4	0.4	0.6 0.45 0.75 0.3 0.5];
B= [9 4 8 7 6 9 3 5 4 3];
prod_cost_in_period= [7 8 8 8 6 7 6 8 7 5
                      5 6 5 8 7 10 11 6 13 8
                      5 3 7 6 4 8 11 8 7 10
                      8 10 7 4 7 9 11 5 8 10];

Prices_BPs= {
    [14 13 10];
    [14 13 10];
    [14,13,10];
    [18,17 13];
    [18,17,13];
    [18,17,13];
    [18,17,13];
    [21,19];
    [21,19];
    [21,19];
    };

ranges=  {{[0, 35] , [35, 50], [50, inf]};
         {[0, 35] , [35, 50], [50, inf]};
         {[0, 35], [35,50], [50,inf]};
         {[0, 40], [40,70], [70,inf]};
         {[0, 40], [40,70],[70,inf]};
         {[0, 40], [40,70],[70,inf]};
         {[0, 40], [40,70],[70,inf]};
         {[0, 30],[30,inf]};
         {[0, 30],[30,inf]};
         {[0, 30],[30,inf]};
         };
     
     M1= 100;
     max_cost=40000;
     batch_size=[9 4 8 7 6 9 3 5 4 3];
     max_box=10000;
     M2= max_box;
     
     T(1:m-1)=2; % each product takes 2 units of time in each period
     Tj= 2;
     
     LS_cost=    [7 8 8 8 6 7 6 8 7 5;
                 5 6 5 8 7 10 11 6 13 8;
                 5 3 7 6 4 8 11 8 7 10;
                 8 10 7 4 7 9 11 5 8 10];
     BO_cost= [9 5 9 5 9 9 10 8 6 4
                4 9 4 9 7 4 4 5 6 7
                6 5 4 7 8 6 8 9 10 11
                8 11 10 5 8 8 9 6 10 7];
     
