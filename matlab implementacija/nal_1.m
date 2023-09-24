tab = readtable('Kibergrad.csv');

cetrt_1 = tab(tab.x_CETRT_ == 1 , :).Variables;
cetrt_2 = tab(tab.x_CETRT_ == 2 , :).Variables;
cetrt_3 = tab(tab.x_CETRT_ == 3 , :).Variables;
cetrt_4 = tab(tab.x_CETRT_ == 4 , :).Variables;
%podatki urejeni po četrtih
% Iz tabele spremenimo v array

%================================================================
% Slučajnih 100 števil
n=1000;
rand_1 = randi([1, size(cetrt_1, 1)], 1, n);
rand_2 = randi([1, size(cetrt_2, 1)], 1, n);
rand_3 = randi([1, size(cetrt_3, 1)], 1, n);
rand_4 = randi([1, size(cetrt_4, 1)], 1, n);

% slučajnih 100 družin iz vsake četrti, gledamo le DOHODKE (stolpec 4)
sluc_1 = cetrt_1(rand_1, 4);
sluc_2 = cetrt_2(rand_2, 4);
sluc_3 = cetrt_3(rand_3, 4);
sluc_4 = cetrt_4(rand_4, 4);

regije = categorical(["Sever", "Vzhod", "Jug", "Zahod"]);
group = [ones(n, 1); 2 * ones(n, 1); 3 * ones(n, 1); 4 * ones(n, 1)];

figure
boxplot([sluc_1; sluc_2; sluc_3; sluc_4], group)

xticklabels(regije)

xlabel('Cetrti')
ylabel('Dohodek')
title('Dohodki po četrtih na vzorcu 100 družin')
% ===================================================================
% dodatna 4 vzorčenja v Severni četrti
sluc_data = cell(1, 4);

for i = 1:4
    rand_i = randi([1, size(cetrt_1, 1)], 1, n);
    sluc_data{i} = cetrt_1(rand_i, 4);
end

group_2 = [ones(n, 1); 2 * ones(n, 1); 3 * ones(n, 1); 4 * ones(n, 1); 5* ones(n, 1)];

figure
boxplot([ sluc_1; sluc_data{1}; sluc_data{2}; sluc_data{3}; sluc_data{4}], group_2)
xticklabels({'vzorec 1', 'vzorec 2', 'vzorec 3', 'vzorec 4', 'vzorec 5'})

ylabel('Dohodek')
title('Dohodki za 5 vzorcev po 100 družin v severni četrti')

% ===================================================================
% Iščemo pojasnjeno in rezidualno varianco
st_druzin = size(tab, 1);
dohodki_po_cetrtih = {cetrt_1(:, 4), cetrt_2(:, 4), cetrt_3(:, 4), cetrt_4(:, 4)};

razmerja = zeros(1, 4);
for i=1:4
    st_i = size(dohodki_po_cetrtih{i}, 1);
    w_i = st_i / st_druzin;
    razmerja(i) = w_i;
end

% povprečni dohodki po četrtih
povprecni_dohodki_po_cetrtih = zeros(4, 1);
for i = 1:4
    povprecni_dohodki_po_cetrtih(i) = mean(dohodki_po_cetrtih{i});
end

%varianca posamičnih četrti
variance_cetrti = zeros(4, 1);
for i=1:4
   variance_cetrti(i) = var(dohodki_po_cetrtih{i});
end

%rezidualna varianca (varianca znotraj skupin)
res_var = 0;
for i = 1:4
    res_var = res_var + razmerja(i)*variance_cetrti(i);
end

% pojasnjena varianca (varianca med skupinami)
skupno_povprecje = mean(tab(:, 4)).Variables;
poj_var = 0;
for i = 1:4
    poj_var = poj_var + razmerja(i)*(povprecni_dohodki_po_cetrtih(i) - skupno_povprecje)^2;
end

%DODATEN KOMENTAR: Vzorčili smo 100 ljudi, celotna populacija pa je
%cca 40000. Vzorec 100 ljudi ni nujno reprezentativen, ker je pojasnjena
%varianca majhna oziroma je varianca znotraj posamične skupine velika.

