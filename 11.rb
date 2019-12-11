input_file = File.read('./11.input').split(',').map(&:strip).map(&:to_i)

def intcode(parameters, input, cursor, base)
  while cursor < input.size do
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

def calculate_next(cur_pos, direction, new_dir)
  new_direction =
    if new_dir == 0
      case direction
      when '^' then '<'
      when '<' then 'v'
      when 'v' then '>'
      when '>' then '^'
      end
    else
      case direction
      when '^' then '>'
      when '>' then 'v'
      when 'v' then '<'
      when '<' then '^'
      end
    end

  new_pos =
    case new_direction
    when '^' then [cur_pos[0] - 1, cur_pos[1]]
    when '<' then [cur_pos[0], cur_pos[1] - 1]
    when 'v' then [cur_pos[0] + 1, cur_pos[1]]
    when '>' then [cur_pos[0], cur_pos[1] + 1]
    end

  [new_pos, new_direction]
end

p1 = [[[50, 50], '^']]
colors = Array.new(100){Array.new(100, 0)}
input, cursor, res1, base = intcode([0], input_file, 0, 0)
input, cursor, res2, base = intcode([0], input, cursor, base)
colors[p1.last[0][0]][p1.last[0][1]] = res1
p1 << calculate_next(p1.last[0], p1.last[1], res2)
while !res1.nil?
  input, cursor, res1, base = intcode([colors[p1.last[0][0]][p1.last[0][1]]], input, cursor, base)
  input, cursor, res2, base = intcode([colors[p1.last[0][0]][p1.last[0][1]]], input, cursor, base) unless res1.nil?
  colors[p1.last[0][0]][p1.last[0][1]] = res1
  p1 << calculate_next(p1.last[0], p1.last[1], res2) unless res1.nil?
end
pp p1.map { |p| p[0] }.uniq.count


p2 = [[[0, 0], '^']]
colors = Array.new(6){Array.new(40, 0)}
input, cursor, res1, base = intcode([1], input_file, 0, 0)
input, cursor, res2, base = intcode([1], input, cursor, base)
colors[p2.last[0][0]][p2.last[0][1]] = res1
p2 << calculate_next(p2.last[0], p2.last[1], res2)
while !res1.nil?
  input, cursor, res1, base = intcode([colors[p2.last[0][0]][p2.last[0][1]]], input, cursor, base)
  input, cursor, res2, base = intcode([colors[p2.last[0][0]][p2.last[0][1]]], input, cursor, base) unless res1.nil?
  colors[p2.last[0][0]][p2.last[0][1]] = res1
  p2 << calculate_next(p2.last[0], p2.last[1], res2) unless res1.nil?
end

pp colors.map { |c| c.join('').gsub('0', '.').gsub('1', '#') }