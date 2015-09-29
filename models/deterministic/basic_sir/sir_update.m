function [y_prime] = sir_update(y,beta,gamma)
s = y(1); 
i = y(2);
r = y(3);
n = s + i + r;

y_prime = zeros(3,1);
y_prime(1) = -beta * s * i / n;
y_prime(2) = beta * s * i / n - gamma * i;
y_prime(3) = gamma * i;
end

