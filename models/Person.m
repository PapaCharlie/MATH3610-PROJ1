classdef Person < handle
  properties
    age
    is_sick = false
    is_vaccinated = false
    is_hospitalized = false % If complications encur, move to hospital, stop infecting other people
    was_sick = false  % Check if citizen has already been sick, assuming one can only get sick of the same strain once
    heal_chance       % Chance to heal after a given day
    comp_chance       % Chance of complications due to sickness
    connectivity      % Number of people exposed to in a given day
    become_sick = false
  end

  methods
    function this = Person(age)
      this.age = age;
      switch age
        case 1
          this.comp_chance = 0.05;
          this.connectivity = 175;
          this.heal_chance = 0.5;
        case 2
          this.comp_chance = 0.05;
          this.connectivity = 200;
          this.heal_chance = 0.4;
        case 3
          this.comp_chance = 0.1;
          this.connectivity = 150;
          this.heal_chance = 0.3;
        case 4
          this.comp_chance = 0.6;
          this.connectivity = 75;
          this.heal_chance = 0.2;
      end
      % this.connectivity = this.connectivity * 2;
      % this.comp_chance = this.comp_chance / 10;
    end
  end
end