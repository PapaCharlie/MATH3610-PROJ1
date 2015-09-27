ithaca_pop = 60000;
vaccines = 4000;

ithaca_pop = ithaca_pop/10;
vaccines = vaccines/10;

init_sick = ithaca_pop/50;

% Census data for age ranges
num_children  = ithaca_pop/10;
num_teens     = 2*ithaca_pop/5;
num_adults    = 2*ithaca_pop/5;
num_seniors   = ithaca_pop/10;

child = struct;
child.age = 1;
child.comp_chance = 0.2;
child.connectivity = 100;
child.heal_chance = 0.3;

teen = struct;
teen.age = 2;
teen.comp_chance = 0.1;
teen.connectivity = 200;
teen.heal_chance = 0.2;

adult = struct;
adult.age = 3;
adult.comp_chance = 0.3;
adult.connectivity = 150;
adult.heal_chance = 0.1;

senior = struct;
senior.age = 4;
senior.comp_chance = 0.7;
senior.connectivity = 100;
senior.heal_chance = 0.05;

citizens = zeros(1, ithaca_pop);
sick = zeros(1, ithaca_pop);
vaccinated = zeros(1, ithaca_pop);
healed = zeros(1, ithaca_pop);
hospitalized = zeros(1, ithaca_pop);
become_sick = false(1, ithaca_pop);

for i = 1:ithaca_pop
  if i <= num_children
    citizens(i) = 1;
  elseif i <= (num_children + num_teens)
    citizens(i) = 2;
  elseif i <= (num_children + num_teens + num_adults)
    citizens(i) = 3;
  else
    citizens(i) = 4;
  end
end

for i = 1:init_sick
  random_citizen = round(rand*(ithaca_pop -1)) + 1;
  sick(random_citizen) = true;
end

deltas = 10;
months = 10;
sick_per_delta = zeros(1 + months*deltas, 5);

for c = i:ithaca_pop
  if sick(c)
    sick_per_month(1, citizens(c)) = sick_per_month(1, citizens(c)) + 1;
  end
end

disp('starting sim')

for d = 1:months
  % if ~mod(d, deltas)
    disp(sprintf('Month: %d',d/deltas));
  % end
  distributed = 0;
  while vaccinated ~= vaccines
    random_citizen = round(rand*(ithaca_pop -1)) + 1;
    if ~sick(random_citizen)
      vaccinated(random_citizen) = true;
      distributed = distributed + 1;
    end
  end
  for n = 1:ithaca_pop
    t = citizen_type(citizens(n));
    if sick(n)
      if rand < (t.heal_chance/deltas)
        sick(n) = false;
        healed(n) = true;
      elseif rand < (t.comp_chance/deltas)
        sick(n) = false;
        hospitalized(n) = true;
      else
        for c = (round(rand(1, t.connectivity*(ithaca_pop -1))) + 1)
          if ~vaccinated(c) && ~healed(c) && ~sick(c)
            become_sick(c) = become_sick(c) || rand < (1/deltas);
          end
        end
      end
    end
  end
  for c = 1:ithaca_pop
    if become_sick(c)
      % disp('infect')
      sick(c) = true;
      become_sick(c) = false;
    end
  end
  for c = 1:ithaca_pop
    if sick(c)
      sick_per_delta(d+1, age(c)) = sick_per_delta(d+1, age(c)) + 1;
    elseif hospitalized(c)
      sick_per_delta(d+1, 5) = sick_per_delta(d+1, 5) + 1;
    end
  end
end

f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
bar(0:months,sick_per_month, 'stacked');
saveas(f, 'Monthly sick', 'png');