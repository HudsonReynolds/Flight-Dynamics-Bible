for i = 1:20000
    [T(i), a(i), P(i), rho(i)] = atmosisa(i);
    h(i) = i;
end

h = h';
a = a';
rho = rho';
P = P';

data = [a, rho, P];

writematrix(data, 'AtmosphereModel.csv')