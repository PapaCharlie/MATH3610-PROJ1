ithaca_pop = 60000;
vaccines = 4000;

% ithaca_pop = ithaca_pop/10;
% vaccines = vaccines/10;

init_sick = 100;

% Census data for age ranges
num_children  = ithaca_pop/10;
num_teens     = 2*ithaca_pop/5;
num_adults    = 2*ithaca_pop/5;
num_seniors   = ithaca_pop/10;

% Values to pass to person classdef
child   = 1;
teen    = 2;
adult   = 3;
senior  = 4;

citizens = Person(0);

for i = 1:ithaca_pop
  if i <= num_children
    citizens(i) = Person(child);
  elseif i <= (num_children + num_teens)
    citizens(i) = Person(teen);
  elseif i <= (num_children + num_teens + num_adults)
    citizens(i) = Person(adult);
  else
    citizens(i) = Person(senior);
  end
end

for i = citizens
  while length(i.connections) < i.connectivity
    random_citizen = round(rand*(ithaca_pop -1)) + 1;
    if length(citizens(random_citizen)) < citizens(random_citizen).connectivity
      citizens(random_citizen).connections(length(citizens(random_citizen))) = i.findobj;
      i.connections(length(i.connections) + 1) = citizens(random_citizen).findobj;
    end
  end
end

for i = 1:init_sick
  random_citizen = round(rand*(ithaca_pop -1)) + 1;
  citizens(random_citizen).is_sick = true;
end

months = 20;

for d = 1:months
  for citizen = citizens
    citizen.step();
  end

end

num_sick = 0;
num_complications = 0;

for citizen = citizens
  if citizen.is_sick
    num_sick = num_sick + 1;
  end
  if citizen.is_hospitalized
    num_complications = num_complications + 1;
  end
end

num_sick
num_complications