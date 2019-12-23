input_file = File.read('./21.input').split(',').map(&:strip).map(&:to_i)

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

instructions = [
  "NOT B J",
  "NOT C T",
  "OR T J",
  "AND D J",
  "NOT A T",
  "OR T J",
  "WALK",
].map { |i| (i + "\n").chars.map(&:ord) }

res = 0
input = input_file.clone
cursor = 0
base = 0
instructions.each do |i|
  input, cursor, res, base = intcode(i, input, cursor, base)
  buffer = ''
  while !res.nil?
    input, cursor, res, base = intcode([], input, cursor, base)
    if buffer.count("\n") > 0
      pp buffer
      buffer = ''
    end
    buffer += res.chr if !res.nil? && res < 128
    if res && res > 128
      pp res
    end
  end
end


instructions = [
  "NOT I T",
  "NOT T J",
  "OR F J",
  "AND E J",
  "OR H J",
  "AND D J",
  "NOT A T",
  "NOT T T",
  "AND B T",
  "AND C T",
  "NOT T T",
  "AND T J",
  "RUN"
].map { |i| (i + "\n").chars.map(&:ord) }

res = 0
input = input_file.clone
cursor = 0
base = 0
instructions.each do |i|
  input, cursor, res, base = intcode(i, input, cursor, base)
  buffer = ''
  while !res.nil?
    input, cursor, res, base = intcode([], input, cursor, base)
    if buffer.count("\n") > 0
      pp buffer
      buffer = ''
    end
    buffer += res.chr if !res.nil? && res < 128
    if res && res > 128
      pp res
    end
  end
end
