function [peak, hosps] = spread(age_range, div, p)
  if nargin == 1
    div = 10;
    p = false;
  elseif nargin == 2
    p = false;
  end

  global ithaca_pop;
  global vaccines;
  global init_sick;
  global num_juniors;
  global num_adults;
  global num_seniors;
  global junior_center;
  global adult_center;
  global senior_center;

  ithaca_pop = 60000;
  vaccines = 4000/4; % Vaccines per week

  ithaca_pop = ithaca_pop/div;
  vaccines = vaccines/div;

  init_sick = ithaca_pop/50;

  % Census data for age ranges
  % num_babies    = 0.03*ithaca_pop;
  num_juniors   = 0.6*ithaca_pop;
  num_adults    = 0.3*ithaca_pop;
  num_seniors   = 0.1*ithaca_pop;

  junior_center   = num_juniors/4; % Center the norm closer to babies
  adult_center    = num_juniors + num_adults/2;
  senior_center   = num_juniors + num_adults + num_seniors/2;

  citizens = Person(0);

  for i = 1:ithaca_pop
    if i <= num_juniors
      citizens(i) = Person(1);
    elseif i <= (num_juniors + num_adults)
      citizens(i) = Person(2);
    else
      citizens(i) = Person(3);
    end
  end

  for c = citizens(round(rand(1,init_sick)*(ithaca_pop - 1)) + 1)
    c.is_sick = true;
  end

  deltas = 5;
  weeks = 6; % 3 months
  sick_per_delta = zeros(1 + weeks*deltas, 4);

  for c = citizens
    if c.is_sick
      sick_per_delta(1, c.age + 1) = sick_per_delta(1, c.age + 1) + 1;
    end
  end

  for d = 1:weeks*deltas
    % if ~mod(d, deltas)
    %   disp(sprintf('Week: %d',d/deltas));
    % end
    vaccinated = 0;
    while vaccinated ~= (vaccines/deltas)
      random_citizen = random_vaccine(age_range);
      if ~citizens(random_citizen).is_sick && ~citizens(random_citizen).is_vaccinated
        citizens(random_citizen).is_vaccinated = true;
        vaccinated = vaccinated + 1;
      end
    end
    for citizen = citizens
      if citizen.is_sick
        if (rand < (citizen.heal_chance/deltas))
          citizen.is_sick = false;
          citizen.was_sick = true;
        elseif (rand < (citizen.comp_chance/deltas))
          citizen.is_sick = false;
          citizen.is_hospitalized = true;
        else
          for c = citizens(random_vaccine(citizen.age, citizen.connectivity))
            if (~c.is_vaccinated && ~c.was_sick && ~c.is_sick)
              c.become_sick = (c.become_sick || rand < (0.5/deltas));
            end
          end
        end
      end
    end
    for c = citizens
      if c.become_sick
        c.is_sick = true;
        c.become_sick = false;
      end
    end
    for c = citizens
      if c.is_sick
        sick_per_delta(d+1, c.age + 1) = sick_per_delta(d+1, c.age + 1) + 1;
      elseif c.is_hospitalized
        sick_per_delta(d + 1, 1) = sick_per_delta(d + 1, 1) + 1;
      end
    end
  end

  if p
    f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
    hBar = bar(0:(1/deltas):weeks, sick_per_delta, 'stacked');
    colormap([0 0 0; 1 0 0; 0 1 0; 1 1 0]);
    legend('Hospitalized', 'Juniors', 'Adults', 'Seniors');
    title(sprintf('Weekly spread of flu, 500 initally infected. Total hospitalizations: %d', sick_per_delta(length(sick_per_delta(:,1)), 1)));
    xlabel('Weeks');
    ylabel('Infections');
    xlim([0 weeks]);
    saveas(f, 'Monthly sick', 'png');
  end

  peak = round(max(sum(sick_per_delta'))/ithaca_pop,4)*100;
  hosps = sick_per_delta(size(sick_per_delta,1), 1);
  disp(sprintf('Peak infection rate: %f', peak));
  disp(sprintf('Total hospitalizations: %d', hosps));
end