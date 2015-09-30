function people = random_vaccine(age, len)
  global ithaca_pop;
  global vaccines;
  global init_sick;
  global num_juniors;
  global num_adults;
  global num_seniors;
  global junior_center;
  global adult_center;
  global senior_center;

  if nargin == 1
    switch age
      case 1
        people = min(ithaca_pop, max(1, round(normrnd(junior_center, num_juniors/4))));
      case 2
        people = min(ithaca_pop, max(1, round(normrnd(adult_center, num_adults))));
      case 3
        people = min(ithaca_pop, max(1, round(normrnd(senior_center, num_seniors/2))));
    end
  else
    switch age
      case 1
        ppl = round(normrnd(junior_center, num_juniors/4, 1, len));
        ppl(ppl < 1) = 1;
        ppl(ppl > ithaca_pop) = ithaca_pop;
        people = ppl;
      case 2
        ppl = round(normrnd(adult_center, num_adults, 1, len));
        ppl(ppl < 1) = 1;
        ppl(ppl > ithaca_pop) = ithaca_pop;
        people = ppl;
      case 3
        ppl = round(normrnd(senior_center, num_seniors/2, 1, len));
        ppl(ppl < 1) = 1;
        ppl(ppl > ithaca_pop) = ithaca_pop;
        people = ppl;
    end
  end
end