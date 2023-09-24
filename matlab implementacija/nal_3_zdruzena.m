tab = readtable('Temp_LJ.csv');

januarske_temp = tab(tab.MESEC == 1, 3).Variables;
julijske_temp = tab(tab.MESEC == 7, 3).Variables;
Y = [januarske_temp;julijske_temp]; %vektor Yskupnih temperatur

n= size(julijske_temp, 1);

v = [zeros(n, 1); ones(n, 1)];
v2 = [(1986:2020)' ; (1986:2020)'];
v3= [zeros(n, 1); (1986:2020)'];
X= [ones(2*n,1) v v2 v3];

% cenilka
B = (X' * X) \ (X' * Y);

% Plotting
figure
plot(1986:2020, januarske_temp, 'o'); 
xlabel('leto');
ylabel('januarske temperature');
title('januarske temperature od 1986 do 2020');
hold on
a_0=B(1);
k_0=B(3);
t = linspace(1986,2020);
plot(t, a_0+k_0*t);
hold off


% cenilka za julijske temp.
figure
plot(1986:2020, julijske_temp, 'o');  
xlabel('leto');
ylabel('julijske temperature');
title('julijske temperature od 1986 do 2020');
hold on
a_1=B(2);
a_jul = a_0+a_1;
k_1=B(4);
k_jul=k_0+k_1;
t = linspace(1986,2020);
plot(t, a_jul+k_jul*t);
hold off

% Zgleda, da julijske temperature naraščajo cca 40% hitreje


%Testiranje hipoteze: H_0: k_1=0, proti H_1: K_1 \neq 0

RSS = norm(Y-X*B)^2;
sigma = sqrt(RSS/(size(X, 1) - numel(B))); %cenilka za sigmo
c = [0; 0; 0; 1];
Stud = (c' * B - 0) / (sigma * sqrt(c' * inv(X' * X) * c)) ;
test_1 = tinv(0.995,size(X, 1) - numel(B));
test_2 = tinv(0.975, size(X, 1) - numel(B)); % 66 prostorskih stopenj

%if |Stud| > test_1  ali |Stud| > test_2 zavrnemo hipotezo
