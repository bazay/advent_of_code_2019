require 'pry'
class CrossedWires
  X_COORD = 0
  Y_COORD = 1
  CHAR = 2
  STEPS = 3
  DISTANCE = 4

  WIRE1 = 0
  WIRE2 = 1

  def call
    @x_small = 0
    @x_large = 0
    @y_small = 0
    @y_large = 0
    @locations = []

    File.open('input.txt').each_with_index do |line, index|
      @locations[index] = [[0, 0, '0', 0]]
      commands = line.split(',')
      commands.each do |command|
        direction = command[0]
        step = command[1..-1].to_i
        track_movement(index, direction, step, commands.last == command)
      end
    end
    sorted_locations = (@locations[X_COORD] & @locations[Y_COORD])
    find_intersections!
    apply_char_distance_step_to_intersections!
    
    # print_matrix
    print_closest_location_distance
    print_closest_intersection_step_count
  end

  private

  def track_movement(line, direction, step, is_last)
    case direction
    when 'U'
      (1..step).each do |item|
        char = item == step && !is_last ? '+' : '|'
        update_current_position(line, 0, 1, char)
      end
    when 'D'
      (1..step).each do |item|
         char = item == step && !is_last ? '+' : '|'
         update_current_position(line, 0, -1, char)
      end
    when 'L'
      (1..step).each do |item|
        char = item == step && !is_last ? '+' : '-'
        update_current_position(line, -1, 0, char)
      end
    when 'R'
      (1..step).each do |item|
        char = item == step && !is_last ? '+' : '-'
        update_current_position(line, 1, 0, char)
      end
    end
  end

  def update_current_position(line, x_change, y_change, char)
    current_position = @locations[line].last.dup
    current_position[X_COORD] += x_change
    current_position[Y_COORD] += y_change
    current_position[CHAR] = char
    current_position[STEPS] = current_position[STEPS] + 1
    @locations[line] << current_position
    update_matrix_dimensions(*current_position[X_COORD..Y_COORD])
  end

  def calculate_distance_from_origin(location)
    x, y = location[X_COORD..Y_COORD]
    x.abs + y.abs
  end

  def update_matrix_dimensions(x, y)
    @x_small = x if x < @x_small
    @x_large = x if x > @x_large
    @y_small = y if y < @y_small
    @y_large = y if y > @y_large
  end

  def find_intersections!
    wire1_locations = @locations[WIRE1].map{|loc| loc.slice(X_COORD..Y_COORD) }
    wire2_locations = @locations[WIRE2].map{|loc| loc.slice(X_COORD..Y_COORD) }
    @intersections = (wire1_locations & wire2_locations).slice(1..-1)
  end

  def apply_char_distance_step_to_intersections!
    @intersections.each do |location|
      location[CHAR] = 'X'
      location[STEPS] = calculate_step_sum_by_location(*location[X_COORD..Y_COORD])
      location[DISTANCE] = calculate_distance_from_origin(location)
    end.sort_by! { |location| location[DISTANCE] }
  end

  def calculate_step_sum_by_location(x, y)
    @locations.map do |wire|
      wire.select do |location|
        location[X_COORD] == x && location[Y_COORD] == y
      end.first[STEPS]
    end.sum
  end

  def construct_matrix!
    @matrix = []
    for i in 0..(@y_large - @y_small) do
      row = []
      for j in 0..(@x_large - @x_small) do
        row << '.'
      end
      @matrix << row
    end
  end

  def map_locations_to_matrix!
    @locations.each do |wire|
      wire.each do |location|
        add_location_to_matrix!(location)
      end
    end
  end

  def map_intersections_to_matrix!
    @intersections.each do |location|
      add_location_to_matrix!(location)
    end
  end

  def add_location_to_matrix!(location)
    @x_offset ||= (0 - @x_small).abs
    @y_offset ||= (0 - @y_small).abs
    x_coord = location[X_COORD] + @x_offset
    y_coord = location[Y_COORD] + @y_offset
    # matrix[y][x]
    @matrix[y_coord][x_coord] = location[CHAR] unless @matrix.dig(y_coord, x_coord).nil?
  end

  def print_matrix
    construct_matrix!
    map_locations_to_matrix!
    map_intersections_to_matrix!

    puts @matrix.reverse.map{|y| y.join }.join("\n")
  end

  def print_closest_location_distance
    closest = @intersections.first
    puts "Closest point is [#{closest[X_COORD]}, #{closest[Y_COORD]}] with distance: #{closest[DISTANCE]}"
  end

  def print_closest_intersection_step_count
    closest = @intersections.sort_by! {|intersection| intersection[STEPS] }.first
    puts "Closest point is [#{closest[X_COORD]}, #{closest[Y_COORD]}] with steps: #{closest[STEPS]}"
  end
end

CrossedWires.new.call
