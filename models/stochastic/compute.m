k = zeros(10, 2, 2);

for n = 1:10
  [p,q] = spread(1, 1);
  k(n, 1, 1) = p;
  k(n, 2, 1) = q;
end

for n = 1:10
  [p,q] = spread(1, 1);
  k(n, 1, 2) = p;
  k(n, 2, 2) = q;
end

mean(k(:,:, 1))
mean(k(:,:, 2))