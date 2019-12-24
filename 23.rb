input_file = File.read('./23.input').split(',').map(&:strip).map(&:to_i)

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

cursor = 0
base = 0
comps_params = {}
comps = {}
(0...50).each do |i|
  comps_params[i] = []
  input, cursor, res, base = intcode([i], input_file.clone, 0, 0)
  comps[i] = [input, cursor, base]
end

last = 0
while true
  c = -1
  comps_params.each do |k, v|
    unless v.empty?
      c = k
      break
    end
  end
  if c == -1
    c = last
    last += 1
    last = last % 50
  end
  params = comps_params[c].shift
  params = [-1] if params.nil?
  input, cursor, res1, base = intcode(params, comps[c][0], comps[c][1], comps[c][2])
  input, cursor, res2, base = intcode(params, input, cursor, base)
  input, cursor, res3, base = intcode(params, input, cursor, base)
  comps[c] = [input, cursor, base]

  if res1 == 255
    pp res3
    break
  end

  unless res1.nil?
    comps_params[res1] << [res2, res3]
  end
end


cursor = 0
base = 0
comps_params = {}
comps = {}
(0...50).each do |i|
  comps_params[i] = []
  input, cursor, res, base = intcode([i], input_file.clone, 0, 0)
  comps[i] = [input, cursor, base]
end
last = 0
nat = nil
empty_queue = 0
last_nat = nil
while true
  c = -1
  comps_params.each do |k, v|
    unless v.empty?
      c = k
      empty_queue = 0
      break
    end
  end
  if c == -1
    c = last
    last += 1
    last = last % 50
  end
  params = comps_params[c].shift

  if params.nil?
    empty_queue += 1
    if empty_queue > 50
      if nat && nat[1] == last_nat
        pp last_nat
        break
      end
      params = nat
      last_nat = nat[1]
      c = 0
      last = 0
    else
      params = [-1]
    end
  end

  input, cursor, res1, base = intcode(params, comps[c][0], comps[c][1], comps[c][2])
  input, cursor, res2, base = intcode(params, input, cursor, base)
  input, cursor, res3, base = intcode(params, input, cursor, base)
  comps[c] = [input, cursor, base]

  if res1 == 255
    nat = [res2, res3]
  elsif !res1.nil?
    comps_params[res1] << [res2, res3]
  end
end
