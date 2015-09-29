function spread
  ithaca_pop = 60000;
  vaccines = 4000;

  ithaca_pop = ithaca_pop/10;
  vaccines = vaccines/10;

  % init_sick = ithaca_pop/50;
  init_sick = 500;

  % Census data for age ranges
  num_juniors   = 0.6*ithaca_pop;
  num_adults    = 0.3*ithaca_pop;
  num_seniors   = 0.1*ithaca_pop;

  % Values to pass to person classdef
  junior_center  = num_juniors/2;
  adult_center   = num_juniors + num_adults/2;
  senior_center  = num_juniors + num_adults + num_seniors/2;

  citizens = Person(0);

  function people = random_sample(age)
    switch age
      case 1
        ppl = round(normrnd(junior_center, num_juniors));
        ppl(ppl < 1) = 1;
        ppl(ppl > ithaca_pop) = ithaca_pop;
        people = ppl;
      case 2
        ppl = round(normrnd(adult_center, num_adults));
        ppl(ppl < 1) = 1;
        ppl(ppl > ithaca_pop) = ithaca_pop;
        people = ppl;
      case 3
        ppl = round(normrnd(senior_center, num_seniors));
        ppl(ppl < 1) = 1;
        ppl(ppl > ithaca_pop) = ithaca_pop;
        people = ppl;
    end
  end

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

  deltas = 2;
  months = 5;
  sick_per_delta = zeros(1 + months*deltas, 4);

  for c = citizens
    if c.is_sick
      sick_per_delta(1, c.age + 1) = sick_per_delta(1, c.age + 1) + 1;
    end
  end

  for d = 1:months*deltas
    if ~mod(d, deltas)
      disp(sprintf('Month: %d',d/deltas));
    end
    vaccinated = 0;
    while vaccinated ~= (vaccines/deltas)
      random_citizen = random_sample(3);
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
          for c = citizens(round(rand(1,citizen.connectivity)*(ithaca_pop -1)) + 1)
            if (~c.is_vaccinated && ~c.was_sick && ~c.is_sick)
              c.become_sick = (c.become_sick || rand < (0.1/deltas));
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

  disp('Plotting');

  f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
  hBar = bar(0:(1/deltas):months, sick_per_delta, 'stacked');
  colormap([0 0 0; 1 0 0; 0 1 0; 1 1 0]);
  legend('Hospitalized', 'Juniors', 'Adults', 'Seniors');
  title(sprintf('Monthly spread of flu, 500 initally infected. Total hospitalizations: %d', sick_per_delta(length(sick_per_delta(:,1)), 1)));
  xlabel('Months');
  ylabel('Infections');
  xlim([0 months]);
  saveas(f, 'Monthly sick', 'png');
end