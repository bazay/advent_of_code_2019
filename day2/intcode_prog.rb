require 'pry'

class IntcodeProg
  OPERATIONS = [nil, '+', '*', 'return']
  
  def initialize(noun: nil, verb: nil, starter: nil)
    @instructions = parse_instructions(File.open('input.txt').map(&:itself).join)
    @commands = []
    apply_inputs!(noun, verb) if noun && verb
    apply_starter!(starter) if starter
  end

  def call
    parse_commands!
    @commands.each do |command|
      case command[0]
      when 1, 2
       first_number = lookup_value(command[1])
       second_number = lookup_value(command[2])
       value = first_number.send(OPERATIONS[command[0]], second_number)
       define_value(command[3], value)
      else
        return @instructions[0]
      end
    end
  end

  def test(instructions)
    @instructions = parse_instructions(instructions)
    call
  end

  private

  def parse_instructions(input)
    input.split(',').map(&:to_i)
  end

  def apply_inputs!(noun, verb)
    @instructions[1] = noun
    @instructions[2] = verb
  end

  def apply_starter!(starter)
    @instructions[0] = starter
  end

  def parse_commands!
    @commands = @instructions.each_slice(4) # This will break if we hit 99
  end

  def lookup_value(location)
    @instructions[location]
  end

  def define_value(location, value)
    @instructions[location] = value
  end
end

# Exercise 1
puts IntcodeProg.new(noun: 12, verb: 2).call
# IntcodeProg.new.test("1,1,1,4,99,5,6,0,99")

# Exercise 2
val = nil
(1..99).each do |noun|
  (1..99).each do |verb|
    prog = IntcodeProg.new(noun: noun, verb: verb)
    val = prog.call
    if val == 19690720
      puts "noun: #{noun}, verb: #{verb}"
      exit
    else
      print '.'
    end
  end
end

