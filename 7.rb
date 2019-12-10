input_file = File.read('./7.input').split(',').map(&:strip).map(&:to_i)

def try(parameters, input, cursor)
  result = nil
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
      first_param = first == 1 ? input[cursor+1] : input[input[cursor+1]]
      second_param = second == 1 ? input[cursor+2] : input[input[cursor+2]]
      input[input[cursor+3]] = first_param + second_param
      cursor += 4
    when 2
      first_param = first == 1 ? input[cursor+1] : input[input[cursor+1]]
      second_param = second == 1 ? input[cursor+2] : input[input[cursor+2]]
      input[input[cursor+3]] = first_param * second_param
      cursor += 4
    when 3
      return [input, cursor, result] if parameters.empty?
      if first == 1
        input[cursor+1] = parameters.shift
      else
        input[input[cursor+1]] = parameters.shift
      end
      cursor += 2
    when 4
      first_param = first == 1 ? input[cursor+1] : input[input[cursor+1]]
      result = first_param
      cursor += 2
      return [input, cursor, result]
    when 5
      first_param = first == 1 ? input[cursor+1] : input[input[cursor+1]]
      second_param = second == 1 ? input[cursor+2] : input[input[cursor+2]]
      if first_param != 0
        cursor = second_param
      else
        cursor += 3
      end
    when 6
      first_param = first == 1 ? input[cursor+1] : input[input[cursor+1]]
      second_param = second == 1 ? input[cursor+2] : input[input[cursor+2]]
      if first_param == 0
        cursor = second_param
      else
        cursor += 3
      end
    when 7
      first_param = first == 1 ? input[cursor+1] : input[input[cursor+1]]
      second_param = second == 1 ? input[cursor+2] : input[input[cursor+2]]
      input[input[cursor+3]] = first_param < second_param ? 1 : 0
      cursor += 4
    when 8
      first_param = first == 1 ? input[cursor+1] : input[input[cursor+1]]
      second_param = second == 1 ? input[cursor+2] : input[input[cursor+2]]
      input[input[cursor+3]] = first_param == second_param ? 1 : 0
      cursor += 4
    end
  end
end

m = []
[0, 1, 2, 3, 4].permutation.each do |pm|
  i1, c1, t1 = try [pm[0], 0], input_file.clone, 0
  i2, c2, t2 = try [pm[1], t1], input_file.clone, 0
  i3, c3, t3 = try [pm[2], t2], input_file.clone, 0
  i4, c4, t4 = try [pm[3], t3], input_file.clone, 0
  i5, c5, t5 = try [pm[4], t4], input_file.clone, 0
  m << t5
end

pp m.max


m = []
[5, 6, 7, 8, 9].permutation.each do |pm|
  i1, c1, t1 = try [pm[0], 0], input_file.clone, 0
  i2, c2, t2 = try [pm[1], t1], input_file.clone, 0
  i3, c3, t3 = try [pm[2], t2], input_file.clone, 0
  i4, c4, t4 = try [pm[3], t3], input_file.clone, 0
  i5, c5, t5 = try [pm[4], t4], input_file.clone, 0
  while !t5.nil?
    i1, c1, t1 = try [t5], i1, c1
    i2, c2, t2 = try [t1], i2, c2
    i3, c3, t3 = try [t2], i3, c3
    i4, c4, t4 = try [t3], i4, c4
    i5, c5, t5 = try [t4], i5, c5
    m << t5
  end
end

pp m.select { |a| !a.nil? }.max
