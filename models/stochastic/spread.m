ithaca_pop = 60000;
vaccines = 4000;

ithaca_pop = ithaca_pop/10;
vaccines = vaccines/10;

% init_sick = ithaca_pop/50;
init_sick = 500;

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

for c = citizens(round(rand(1,init_sick)*(ithaca_pop -1)) + 1)
  c.is_sick = true;
end

deltas = 10;
months = 10;
sick_per_delta = zeros(1 + months*deltas, 5);

for c = citizens
  if c.is_sick
    sick_per_delta(1, c.age) = sick_per_delta(1, c.age) + 1;
  end
end

disp('Starting simulation');

for d = 1:months*deltas
  if ~mod(d, deltas)
    disp(sprintf('Month: %d',d/deltas));
  end
  vaccinated = 0;
  while vaccinated ~= (vaccines/deltas)
    random_citizen = round(rand*(ithaca_pop -1)) + 1;
    if ~citizens(random_citizen).is_sick
      citizens(random_citizen).is_vaccinated = true;
      vaccinated = vaccinated + 1;
    end
  end
  for citizen = citizens
    if citizen.is_sick
      if rand < (citizen.heal_chance/deltas)
        citizen.is_sick = false;
        citizen.was_sick = true;
      elseif rand < (citizen.comp_chance/deltas)
        citizen.is_sick = false;
        citizen.is_hospitalized = true;
      else
        for c = citizens(round(rand(1,citizen.connectivity)*(ithaca_pop -1)) + 1)
          % if ~c.is_vaccinated && ~c.was_sick && ~c.is_sick
          c.become_sick = c.become_sick || 1;% rand < (1/deltas);
          % end
        end
      end
    end
  end
  for c = citizens
    if citizen.become_sick
      disp('infect')
      citizen.is_sick = true;
      citizen.become_sick = false;
    end
  end
  for c = citizens
    if c.is_sick
      sick_per_delta(d+1, c.age) = sick_per_delta(d+1, c.age) + 1;
    elseif c.is_hospitalized
      sick_per_delta(d+1, 5) = sick_per_delta(d+1, 5) + 1;
    end
  end
end

disp('Plotting')

f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
bar(0:(1/deltas):months, sick_per_delta, 'stacked');
saveas(f, 'Monthly sick', 'png');