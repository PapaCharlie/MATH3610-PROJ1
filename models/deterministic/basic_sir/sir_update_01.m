function [y_prime] = sir_update_01(y,beta,nu)
s = y(1); 
i = y(2);
y_prime = zeros(3,1);
y_prime(1) = -beta * s * i;
y_prime(2) = beta * s * i - nu * i;
y_prime(3) = nu * i;
end

