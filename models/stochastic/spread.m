function [peak, hosps, sick_per_delta] = spread(age_range, div, p)
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

  init_sick = ithaca_pop/20;

  % Census data for age ranges
  num_juniors   = 0.6*ithaca_pop;
  num_adults    = 0.3*ithaca_pop;
  num_seniors   = 0.1*ithaca_pop;

  junior_center   = num_juniors/2;
  adult_center    = num_juniors + num_adults/2;
  senior_center   = num_juniors + num_adults + num_seniors/2;

  heal_chance = 0.8;

  age = zeros(1, ithaca_pop);
  sick = zeros(1, ithaca_pop);
  hospitalized = zeros(1, ithaca_pop);
  vaccinated = zeros(1, ithaca_pop);

  function conn = connectivity(age)
    switch age
      case 1
        conn = 1000/div;
      case 2
        conn = 30/div;
      case 3
        conn = 10/div;
    end
  end

  function comp = comp_chance(age)
    switch age
      case 1
        comp = 0.05;
      case 2
        comp = 0.2;
      case 3
        comp = 0.75;
    end
  end

  for i = 1:ithaca_pop
    if i <= num_juniors
      age(i) = 1;
    elseif i <= (num_juniors + num_adults)
      age(i) = 2;
    else
      age(i) = 3;
    end
  end

  deltas = 5;
  weeks = 6; % 3 months
  sick_per_delta = zeros(1 + weeks*deltas, 4);

  for c = round(rand(1,init_sick)*(ithaca_pop - 1)) + 1
    sick(c) = true;
    sick_per_delta(1, age(c) + 1) = sick_per_delta(1, age(c) + 1) + 1;
  end

  n = 1;
  for w = 1:weeks
    disp(sprintf('Week: %d', w));
    for d = 1:deltas
      vax = 0;
      peep = 1;
      switch age_range
        case 1
          while vax ~= (vaccines/deltas)
            if ~vaccinated(peep)
              vaccinated(peep) = true;
              vax = vax + 1;
            end
            peep = peep + 1;
            if peep == ithaca_pop
              break
            end
          end
        case 3
          while vax ~= (vaccines/deltas)
            if ~vaccinated(ithaca_pop - peep + 1)
              vaccinated(ithaca_pop - peep + 1) = true;
              vax = vax + 1;
            end
            peep = peep + 1;
            if peep == ithaca_pop
              break
            end
          end
      end
      % become_sick =
      for c = 1:ithaca_pop
        if sick(c)
          if (rand < (heal_chance/deltas))
            sick(c) = false;
            vaccinated(c) = true;
          elseif (rand < (comp_chance(age(c))/deltas))
            sick(c) = false;
            hospitalized(c) = true;
          else
            for r = random_vaccine(age(c), connectivity(age(c)))
              if (~vaccinated(r) && ~sick(r))
                sick(r) = (sick(r) || rand < (0.8/deltas));
              end
            end
          end
        end
      end
      n = n+1;
      stats = zeros(1, 4);
      for c = 1:ithaca_pop
        if sick(c)
          stats(age(c) + 1) = stats(age(c) + 1) + 1;
        elseif hospitalized(c)
          stats(1) = stats(1) + 1;
        end
      end
      sick_per_delta(n,:) = stats;
    end
    % for c = 1:ithaca_pop
    %   if c.become_sick
    %     c.is_sick = true;
    %   end
    % end
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
  disp(sprintf('Peak infection rate: %.2f', peak));
  disp(sprintf('Total hospitalizations: %d', hosps));
end