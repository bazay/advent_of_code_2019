require 'pry'
class SecureContainer
  def initialize(input)
    @input = input
    @lowest, @highest = input.split('-').map(&:to_i)
    @combinations = []
  end

  def call
    (@lowest..@highest).each do |number|
      @combinations << number if is_valid?(number)
    end

    puts "Possible combinations: #{@combinations.count}"
  end

  def test_call
    value = 123789
    @lowest, @highest = [value, value]
    call
  end

  private

  def is_valid?(number)
    contains_two_equal_adjacent_digits?(number) && digits_are_ascending?(number)
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
end

input = "145852-616942"
SecureContainer.new(input).call
# SecureContainer.new(input).test_call
