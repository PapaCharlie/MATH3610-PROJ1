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
child.comp_chance = 0.2;
child.connectivity = 100;
child.heal_chance = 0.3;

teen = struct;
teen.comp_chance = 0.1;
teen.connectivity = 200;
teen.heal_chance = 0.2;

adult = struct;
adult.comp_chance = 0.3;
adult.connectivity = 150;
adult.heal_chance = 0.1;

senior = struct;
senior.comp_chance = 0.7;
senior.connectivity = 100;
senior.heal_chance = 0.05;

sick = zeros(1, ithaca_pop);
vaccinated = zeros(1, ithaca_pop);
healed = zeros(1, ithaca_pop);
hospitalized = zeros(1, ithaca_pop);
% connections = zeros(max([child.connectivity, teen.connectivity, adult.connectivity, senior.connectivity]), ithaca_pop);

for i = 1:ithaca_pop
  if i <= num_children
    connections{i} = zeros(child.connectivity);
  elseif i <= (num_children + num_teens)
    connections{i} = zeros(teen.connectivity);
  elseif i <= (num_children + num_teens + num_adults)
    connections{i} = zeros(adult.connectivity);
  else
    connections{i} = zeros(senior.connectivity);
  end
end

for i = 1:ithaca_pop
  n = 1;
  while n <= length(connections{i})
    random_citizen = round(rand*(ithaca_pop -1)) + 1;
    if ~all(connections{random_citizen})
      connections{random_citizen}(find(connections{random_citizen} == 0, 1)) = i;
      connections{i}(n) = random_citizen;
      n = n + 1;
    end
  end
  if ~mod(i, 100)
    disp(i)
  end
end

%   save 'citizens.mat' citizens;
% else
%   load 'citizens.mat';
% end

% for i = 1:init_sick
%   random_citizen = round(rand*(ithaca_pop -1)) + 1;
%   citizens(random_citizen).is_sick = true;
% end

% months = 10;
% sick_per_month = zeros(months + 1, 4);

% for c = citizens
%   if c.is_sick
%     sick_per_month(1, c.age) = sick_per_month(1, c.age) + 1;
%   end
% end

% for d = 1:months
%   vaccinated = 0;
%   while vaccinated ~= vaccines
%     random_citizen = round(rand*(ithaca_pop -1)) + 1;
%     if ~citizens(random_citizen).is_sick
%       citizens(random_citizen).is_vaccinated = true;
%       vaccinated = vaccinated + 1;
%     end
%   end
%   for citizen = citizens
%     citizen.step();
%   end
%   for c = citizens
%     if c.is_sick
%       sick_per_month(d+1, c.age) = sick_per_month(d+1, c.age) + 1;
%     end
%   end
% end

% f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
% bar(0:months,sick_per_month, 'stacked');
% saveas(f, 'Monthly sick', 'png');