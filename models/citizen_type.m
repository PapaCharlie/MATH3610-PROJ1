function citizen = citizen_type(n)
  switch n
    case 1
      citizen = child;
    case 2
      citizen = teen;
    case 3
      citizen = adult;
    case 4
      citizen = senior;
  end
end