require 'pry'
class SecureContainer
  def initialize(input)
    @input = input
    @lowest, @highest = input.split('-').map(&:to_i)
    @combinations = []
  end

  def call(part2 = false)
    (@lowest..@highest).each do |number|
      @combinations << number if is_valid?(number, part2)
    end

    puts "Possible combinations: #{@combinations.count}"
  end

  def test_call(part2 = false)
    value = 111122
    @lowest, @highest = [value, value]
    call(part2)
  end

  private

  def is_valid?(number, part2)
    validity = [contains_two_equal_adjacent_digits?(number), digits_are_ascending?(number)]
    validity << contains_unique_adjacent_digits?(number) if part2
    validity.all?
  end

  def contains_two_equal_adjacent_digits?(number)
    str_number = number.to_s
    str_number.chars.each_with_index.select { |char, index| str_number[index - 1] == char }.any?
  end

  def digits_are_ascending?(number)
    str_number = number.to_s
    str_number.chars.each_with_index.select do |char, index|
      prev_index = index - 1 > 0 ? index - 1 : 0
      str_number[prev_index].to_i <= char.to_i
    end.count == str_number.chars.count
  end

  def contains_unique_adjacent_digits?(number)
    str_number = number.to_s
    unique_pairs = []
    str_build = ""
    str_number.chars.each_with_index do |char, index|
      if str_build.empty?
        str_build += char
      else
        if str_build[-1] == char
          str_build += char 
          unique_pairs << str_build if index == str_number.chars.length - 1 && str_build.size == 2
        else
          unique_pairs << str_build if str_build.size == 2
          str_build = char
        end
      end
    end
    unique_pairs.any?
  end
end

input = "145852-616942"
puts "{Part 1}"
SecureContainer.new(input).call
# SecureContainer.new(input).test_call

puts "{Part 2}"
SecureContainer.new(input).call(true)
# SecureContainer.new(input).test_call(true)
