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

% if ~(exist('mapping.mat','file') == 2)
%   for i = 1:length(citizens)
%     mapping{i} = ones(1, citizens(i).connectivity);
%     while length(citizens(i).connections) < citizens(i).connectivity
%       random_citizen = round(rand*(ithaca_pop -1)) + 1;
%       if length(citizens(random_citizen)) < citizens(random_citizen).connectivity
%         citizens(random_citizen).connections(length(citizens(random_citizen))) = citizens(i).findobj;
%         citizens(i).connections(length(citizens(i).connections) + 1) = citizens(random_citizen).findobj;
%         mapping{i}(length(citizens(i).connections)) = random_citizen;
%       end
%     end
%   end

%   save 'mapping.mat' mapping;
% else
%   load 'mapping.mat';
%   for i = 1:length(mapping)
%     for n = 1:length(mapping{i})
%       citizens(i).connections(n) = citizens(mapping{i}(n)).findobj;
%     end
%   end
% end

disp('Finished creating network.')

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