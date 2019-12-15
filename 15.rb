input_file = File.read('./15.input').split(',').map(&:strip).map(&:to_i)

def intcode(parameters, input, cursor, base)
  while !input.nil? && cursor < input.size do
    opcode = input[cursor] % 100
    first = ((input[cursor] % 10000) % 1000 ) / 100
    second = (input[cursor] % 10000) / 1000
    third = input[cursor] / 10000
    if input[cursor] == 99
      return nil
    end
    case opcode
    when 1
      first_param = get_parameter input, first, cursor + 1, base
      second_param = get_parameter input, second, cursor + 2, base
      set_parameter input, third, cursor + 3, base, first_param + second_param
      cursor += 4
    when 2
      first_param = get_parameter input, first, cursor + 1, base
      second_param = get_parameter input, second, cursor + 2, base
      set_parameter input, third, cursor + 3, base, first_param * second_param
      cursor += 4
    when 3
      return [input, cursor, nil, base] if parameters.empty?
      case first
      when 0
        input[input[cursor+1]] = parameters.shift
      when 1
        input[cursor+1] = parameters.shift
      when 2
        input[input[cursor+1] + base] = parameters.shift
      end
      cursor += 2
    when 4
      first_param = get_parameter input, first, cursor + 1, base
      cursor += 2
      return [input, cursor, first_param, base]
    when 5
      first_param = get_parameter input, first, cursor + 1, base
      second_param = get_parameter input, second, cursor + 2, base
      if first_param != 0
        cursor = second_param
      else
        cursor += 3
      end
    when 6
      first_param = get_parameter input, first, cursor + 1, base
      second_param = get_parameter input, second, cursor + 2, base
      if first_param == 0
        cursor = second_param
      else
        cursor += 3
      end
    when 7
      first_param = get_parameter input, first, cursor + 1, base
      second_param = get_parameter input, second, cursor + 2, base
      set_parameter input, third, cursor + 3, base, first_param < second_param ? 1 : 0
      cursor += 4
    when 8
      first_param = get_parameter input, first, cursor + 1, base
      second_param = get_parameter input, second, cursor + 2, base
      set_parameter input, third, cursor + 3, base, first_param == second_param ? 1 : 0
      cursor += 4
    when 9
      base += get_parameter input, first, cursor + 1, base
      cursor +=2
    end
  end
end

def get_parameter(input, mode, index, base)
  case mode
  when 0
    input[input[index]] || 0
  when 1
    input[index] || 0
  when 2
    input[input[index] + base] || 0
  end
end

def set_parameter(input, mode, index, base, value)
  case mode
  when 0
    input[input[index]] = value
  when 1
    input[index] = value
  when 2
    input[input[index] + base] = value
  end
end

def calculate_position(cur_pos, direction)
  case direction
  when 1
    [cur_pos[0] - 1, cur_pos[1]]
  when 2
    [cur_pos[0] + 1, cur_pos[1]]
  when 3
    [cur_pos[0], cur_pos[1] - 1]
  when 4
    [cur_pos[0], cur_pos[1] + 1]
  end
end

map = Array.new(50){Array.new(50, '#')}
visited = Array.new(50){Array.new(50, false)}
def calculate_distance(input, cursor, base, move, visited, cur_pos, map)
  return 99999 if visited[cur_pos[0]][cur_pos[1]]
  visited[cur_pos[0]][cur_pos[1]] = true

  input, cursor, res, base = intcode([move], input, cursor, base)

  return 99999 if res == 0

  map[cur_pos[0]][cur_pos[1]] = '.'

  if res == 2
    map[cur_pos[0]][cur_pos[1]] = 'O'
    return 1
  end

  return 1 + [calculate_distance(input.clone, cursor, base, 1, visited.map(&:clone), calculate_position(cur_pos, 1), map),
    calculate_distance(input.clone, cursor, base, 2, visited.map(&:clone), calculate_position(cur_pos, 2), map),
    calculate_distance(input.clone, cursor, base, 3, visited.map(&:clone), calculate_position(cur_pos, 3), map),
    calculate_distance(input.clone, cursor, base, 4, visited.map(&:clone), calculate_position(cur_pos, 4), map)].min
end

pp [calculate_distance(input_file.clone, 0, 0, 1, visited.map(&:clone), [25, 25], map),
    calculate_distance(input_file.clone, 0, 0, 2, visited.map(&:clone), [25, 25], map),
    calculate_distance(input_file.clone, 0, 0, 3, visited.map(&:clone), [25, 25], map),
    calculate_distance(input_file.clone, 0, 0, 4, visited.map(&:clone), [25, 25], map)].min
# pp map.map { |line| line.join '' }

def find_adjacent(map)
  res = []
  (1...map.size-1).each do |i|
    (1...map[i].size-1).each do |j|
      if map[i][j] == '.' && (map[i+1][j] == 'O' || map[i-1][j] == 'O' || map[i][j+1] == 'O' || map[i][j-1] == 'O')
        res << [i, j]
      end
    end
  end
  res
end

minutes = 0
while map.any? {|line| line.include? '.'}
  minutes += 1
  find_adjacent(map).each do |pos|
    map[pos[0]][pos[1]] = 'O'
  end
end

pp minutes