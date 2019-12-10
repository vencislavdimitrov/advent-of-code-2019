input_file = File.read('./10.input').split.map { |s| s.split '' }

def angles(input, x, y)
  res = []
  (0...input.size).each do |i|
    (0...input[i].size).each do |j|
      if input[i][j] != '.'
        res << [Math.atan2(-(y - j), -(x - i)), i, j]
      end
    end
  end
  res
end

res = []
(0...input_file.size).each do |i|
  (0...input_file[i].size).each do |j|
    if input_file[i][j] != '.'
      res << angles(input_file, i, j).uniq { |a| a[0] }
      # pp "#{res.last}: #{i}, #{j}"
    end
  end
end

pp res.max_by { |r| r.count }.count

x = res.max_by { |r| r.count }.select { |r| r[0] == 0 }.first[1..] # find the coordinates of the station
l = angles(input_file, x[0], x[1])
l.sort! do |a, b|
  if a[0] == b[0]
    ((b[1] - x[1])**2 + (b[2] - x[0])**2) <=> ((a[1] - x[1])**2 + (a[2] - x[0])**2)
  else
    a[0] <=> b[0]
  end
end

l.reverse!
res = l.uniq { |asd| asd[0] }.map { |m| [m[1], m[2]]}
pp res[199][1] * 100 + res[199][0]