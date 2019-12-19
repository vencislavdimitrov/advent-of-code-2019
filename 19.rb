input_file = File.read('./19.input').split(',').map(&:strip).map(&:to_i)

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

def in_beam?(input_file, x, y)
  input, cursor, res, base = intcode([x, y], input_file.clone, 0, 0)
  res == 1
end
map = Array.new(50){Array.new(50, '.')}
res = 0
input = input_file.clone
(0...map.size).each do |i|
  (0...map[i].size).each do |j|
    if in_beam? input_file, i, j
      map[i][j] = '#'
    end
  end
end

pp map.reduce(0) { |res, el| res += el.count('#') }

x = y = 0

while !in_beam?(input_file, x + 99, y)
  y += 1
  if !in_beam?(input_file, x, y + 99)
    x += 1
  end
end

pp x * 10000 + y