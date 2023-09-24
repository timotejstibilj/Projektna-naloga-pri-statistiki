tab = readtable('ZarkiGama.csv');

razlike_cas = tab.Variables;
n=size(razlike_cas,1);

Q1 = quantile(razlike_cas, 0.25);
Q3 = quantile(razlike_cas, 0.75);
IQR = Q3 - Q1;

%osamelci
L=Q1-1.5*IQR;
U=Q3+1.5*IQR;
osamelci = razlike_cas(razlike_cas < L | razlike_cas > U);
ostali = razlike_cas(razlike_cas >= L & razlike_cas <= U);
%histogram(ostali, robovi_razredov, 'Normalization', 'pdf', 'FaceColor', 'b', 'EdgeColor', 'w');

% širina intervala za razrede frekvenc
sirina = 2.6 * IQR * (n^(-1/3));
% število razredov:
stevilo_razredov = ceil((max(razlike_cas) - min(razlike_cas)) / sirina);
robovi_razredov = linspace(min(razlike_cas), max(razlike_cas), stevilo_razredov + 1);

histogram(razlike_cas, robovi_razredov, 'Normalization', 'pdf', 'FaceColor', 'b', 'EdgeColor', 'w');
xlabel('čas')
ylabel("frekvenca")
xlim([0, max(razlike_cas)]);
hold on; 
fit_result = fitdist(razlike_cas, 'gamma');

% PDF za porazdelitev gama
x = linspace(0, max(razlike_cas), 3935);
pdf_gamma = pdf(fit_result, x);
plot(x, pdf_gamma, 'r', 'LineWidth', 2);
legend('Histogram medprihodnih časov', 'Gama porazdelitev');
hold off

%q-q grafikon
figure
theoretical_quantiles = gaminv((1:n)/(n + 1), 1, 75); % Adjusted for the number of data points
% Create the Q-Q plot
qqplot(theoretical_quantiles, razlike_cas);
xlim([0, max(razlike_cas)]);
ylim([0,max(razlike_cas)])
xlabel("kvantili gama porazdelitve")
ylabel("kvantili empirične porazdelitve")

%==================================0
%b) ocenitev parametra po metodi momentov: 
X_ = sum(razlike_cas) / n; %povprečje
X2_ =  sum(razlike_cas.^2) / n; % povprečje kvadratov

lambda_est = X_ / (X2_ - X_^2); %cenilka za lambdo
a_est = X_^2 / (X2_ - X_^2); % cenilka za a

% ocenitev parametra po metodi največjega verjetja:
% Funkcijo digama, ki je logaritemski odvod funkcije gama v matlabu dobimo
% s \psi(x)

fun = @(a) n * (log(a) - log(X_) - psi(a)) + sum(log(razlike_cas));
a0 = 1;

a_max = fzero(fun, 10);
lambda_max = a_max / X_;

%risanje

%histogram medprihodnih časov
figure
histogram(razlike_cas,robovi_razredov, 'Normalization', 'pdf', 'FaceColor', 'b', 'EdgeColor', 'w');
xlim([0, max(razlike_cas)]);

hold on;

x = linspace(0, max(razlike_cas), 3935); 
pdf_1 = gampdf(x, a_est, 1/lambda_est); % zapis v matlabu za lambdo vzame 1/lambda v primerjavi z našo navado
pdf_2 = gampdf(x, a_max, 1/lambda_max); 

plot(x, pdf_1, 'r', 'LineWidth', 2); 
plot(x, pdf_2, 'g:', 'LineWidth', 2); 

legend('Histogram medprihodnih časov', 'Gama po metodi momentov', 'Gama po metodi največjega verjetja');
xlabel("medprihodni čas")
ylabel("frekvenca")
grid on;

%histogram medprihodnih časov na manjši x osi
figure
histogram(razlike_cas,robovi_razredov, 'Normalization', 'pdf', 'FaceColor', 'b', 'EdgeColor', 'w');
xlim([0, max(ostali)]);

hold on;

x = linspace(0, max(razlike_cas), 3935); 
pdf_1 = gampdf(x, a_est, 1/lambda_est); % zapis v matlabu za lambdo vzame 1/lambda v primerjavi z našo navado
pdf_2 = gampdf(x, a_max, 1/lambda_max); 

plot(x, pdf_1, 'r', 'LineWidth', 2); 
plot(x, pdf_2, 'g:', 'LineWidth', 2); 

legend('Histogram medprihodnih časov brez osamelcev', 'Gama po metodi momentov', 'Gama po metodi največjega verjetja');
xlabel("medprihodni čas")
ylabel("frekvenca")
grid on;
hold off

% logaritemska skala za histogram

%logartiemska x skala
log_min = log10(min(razlike_cas));
log_max = log10(max(razlike_cas));
log_x = logspace(log_min, log_max, stevilo_razredov + 1);

figure
histogram(razlike_cas, log_x, 'Normalization', 'pdf', 'FaceColor', 'b', 'EdgeColor', 'w');
set(gca, 'XScale', 'log'); % Set x-axis to logarithmic scale
xlim([min(razlike_cas), max(razlike_cas)]); 
title('Medprihodni časi na logaritemski lestvici')

xlabel('medprihodni časi')
ylabel('frekvence')
hold on 

pdf_1 = gampdf(log_x, a_est, 1/lambda_est); % zapis v matlabu za lambdo vzame 1/lambda v primerjavi z našo navado
pdf_2 = gampdf(log_x, a_max, 1/lambda_max); 

plot(log_x, pdf_1, 'r', 'LineWidth', 2); 
plot(log_x, pdf_2, 'g:', 'LineWidth', 2);
legend('Histogram medprihodnih časov', 'Gama po metodi momentov', 'Gama po metodi največjega verjetja');
hold off

% eksponentna porazdelitev
figure
fit_result_exp = fitdist(razlike_cas, 'Exponential');

histogram(razlike_cas, robovi_razredov, 'Normalization', 'pdf', 'FaceColor', 'b', 'EdgeColor', 'w');
xlabel('čas')
ylabel("frekvenca")
xlim([0, max(razlike_cas)]);
hold on; 

x = linspace(0, max(razlike_cas), 100000);
pdf_exp = pdf(fit_result_exp, x);
plot(x, pdf_exp, 'r', 'LineWidth', 2);
legend('Histogram medprihodnih časov', 'Eksponentna porazdelitev');

