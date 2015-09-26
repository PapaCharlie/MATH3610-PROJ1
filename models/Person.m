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
    connections = Person.empty(0) % People connected to (sizeof(connections) == connectivity)
  end

  methods
    function this = Person(age)
      this.age = age;
      switch age
        case 1
          this.comp_chance = 0.2;
          this.connectivity = 100;
          this.heal_chance = 0.3;
        case 2
          this.comp_chance = 0.1;
          this.connectivity = 200;
          this.heal_chance = 0.2;
        case 3
          this.comp_chance = 0.3;
          this.connectivity = 150;
          this.heal_chance = 0.1;
        case 4
          this.comp_chance = 0.7;
          this.connectivity = 100;
          this.heal_chance = 0.05;
      end
    end

    function step(self)
      if self.is_sick
        if rand < self.heal_chance
          self.is_sick = false;
          self.was_sick = true;
        elseif rand < self.comp_chance
          self.is_hospitalized = true;
        else
          for citizen = self.connections
            if and(~citizen.is_vaccinated, and(~citizen.was_sick, ~citizen.is_sick))
              citizen.is_sick = rand < 0.25; % randomly infect connection
            end
          end
        end
      end
    end

  end
end