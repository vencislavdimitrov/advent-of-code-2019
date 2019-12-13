input_file = File.read('./13.input').split(',').map(&:strip).map(&:to_i)

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


result = []
input, cursor, res, base = intcode([], input_file.clone, 0, 0)
result << res
while !res.nil?
  input, cursor, res, base = intcode([], input, cursor, base)
  result << res unless res.nil?
end

pp result.each_slice(3).select { |b| b[2] == 2 }.count

plot = Array.new(35){Array.new(25, 0)}
result.each_slice(3) do |t|
  plot[t[0]][t[1]] = t[2]
end

# pp plot.map { |c| c.join('') }

input_file[0] = 2
instruction = 0
input, cursor, res1, base = intcode([instruction], input_file, 0, 0)
input, cursor, res2, base = intcode([instruction], input, cursor, 0)
input, cursor, res3, base = intcode([instruction], input, cursor, 0)
score = 0
paddle = 0
ball = 0
while !res1.nil? || !input.nil?
  input, cursor, res1, base = intcode([instruction], input, cursor, base)
  input, cursor, res2, base = intcode([instruction], input, cursor, base)
  input, cursor, res3, base = intcode([instruction], input, cursor, base)
  paddle = res1 if res3 == 3
  ball = res1 if res3 == 4
  instruction =
    if paddle > ball
      -1
    elsif ball > paddle
      1
    else
      0
    end
  if !res1.nil? && res1 == -1 && res2 == 0
    score = res3
  end
end

pp score