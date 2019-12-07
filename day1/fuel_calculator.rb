module Spaceship
  class FuelCalculator
    def calculate
      fuel = File.open('spacecraft_modules.txt').map(&:to_i).map do |mass|
        # puts
        # puts "mass: #{item}"
        fuel = calculate_fuel_for_mass(mass)
        # puts fuel
        # puts
        fuel
      end.sum
      puts fuel
    end

    def test_calculate(mass)
      puts calculate_fuel_for_mass(mass)
    end

    def calculate_fuel_for_mass(mass)
      fuel = mass / 3 - 2
      sum = fuel
      while fuel >= 0
        fuel = fuel / 3 - 2
        sum += fuel unless fuel < 0
      end
      sum
    end
  end
end

Spaceship::FuelCalculator.new.calculate

