function [y_prime] = sir_update_04(y,beta,nu,mu,gamma)
s = y(1:4);
i = y(5:8);
gamma(s<=0) = 0;


y_prime = zeros(16,1);
for k = 1:4
    y_prime(k) = -beta(k,:) * i * s(k) - gamma(k);
    y_prime(k+4) = beta(k,:) * i * s(k) - i(k) * (nu + mu(k));
    y_prime(k+8) = nu * i(k) + gamma(k);
    y_prime(k+12) = mu(k) * i(k);
end

