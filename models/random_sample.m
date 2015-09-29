function people = random_sample(age)
  switch age
    case 1
      ppl = normrnd(child_center, num_children/2);
      ppl(ppl < 1) = 1;
      ppl(ppl > ithaca_pop) = ithaca_pop;
      people = ppl;
    case 2
      ppl = normrnd(teen_center, num_teens/2);
      ppl(ppl < 1) = 1;
      ppl(ppl > ithaca_pop) = ithaca_pop;
      people = ppl;
    case 3
      ppl = normrnd(adult_center, num_adults/2);
      ppl(ppl < 1) = 1;
      ppl(ppl > ithaca_pop) = ithaca_pop;
      people = ppl;
    case 4
      ppl = normrnd(senior_center, num_seniors/2);
      ppl(ppl < 1) = 1;
      ppl(ppl > ithaca_pop) = ithaca_pop;
      people = ppl;
  end
end