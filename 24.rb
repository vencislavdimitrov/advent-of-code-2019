input_file = File.read('./24.input').split("\n")
# input_file = ['....#', '#..#.', '#..##', '..#..', '#....']

def count_bugs(state, i, j)
  [[i + 1, j], [i - 1, j], [i, j + 1], [i, j - 1]].count do |n1, n2|
    (0...state.size).to_a.include?(n1) && (0...state[n1].size).to_a.include?(n2) && state[n1][n2] == '#'
  end
end

def iter(state)
  new_state = state.map(&:clone)

  (0...state.size).each do |i|
    (0...state[i].size).each do |j|
      bugs = count_bugs(state, i, j)
      new_state[i][j] =
        if state[i][j] == '#' && bugs != 1
          '.'
        elsif state[i][j] == '.' && [1, 2].include?(bugs)
          '#'
        else
          state[i][j]
        end
    end
  end
  new_state
end

def print(state)
  state.each do |line|
    puts line
  end
  puts ''
end

states = [input_file]
loop do
  new_state = iter states.last
  if states.map(&:join).include? new_state.join
    states << new_state
    break
  end

  states << new_state
end

p states.last.join.gsub('#', '1').gsub('.', '0').reverse.to_i(2)


layers = Array.new 405, ['.....', '.....', '.....', '.....', '.....']
input_file[2][2] = '?'
layers[202] = input_file

def count_bugs_layer(layers, i, j, current_layer)
  neighbours = []
  if i == 2 && j == 1
    neighbours << layers[current_layer][i][j - 1]
    neighbours << layers[current_layer][i + 1][j]
    neighbours << layers[current_layer][i - 1][j]
    neighbours << layers[current_layer + 1][0][0]
    neighbours << layers[current_layer + 1][1][0]
    neighbours << layers[current_layer + 1][2][0]
    neighbours << layers[current_layer + 1][3][0]
    neighbours << layers[current_layer + 1][4][0]
  elsif i == 2 && j == 3
    neighbours << layers[current_layer][i][j + 1]
    neighbours << layers[current_layer][i + 1][j]
    neighbours << layers[current_layer][i - 1][j]
    neighbours << layers[current_layer + 1][0][4]
    neighbours << layers[current_layer + 1][1][4]
    neighbours << layers[current_layer + 1][2][4]
    neighbours << layers[current_layer + 1][3][4]
    neighbours << layers[current_layer + 1][4][4]
  elsif i == 1 && j == 2
    neighbours << layers[current_layer][i][j - 1]
    neighbours << layers[current_layer][i][j + 1]
    neighbours << layers[current_layer][i - 1][j]
    neighbours << layers[current_layer + 1][0][0]
    neighbours << layers[current_layer + 1][0][1]
    neighbours << layers[current_layer + 1][0][2]
    neighbours << layers[current_layer + 1][0][3]
    neighbours << layers[current_layer + 1][0][4]
  elsif i == 3 && j == 2
    neighbours << layers[current_layer][i][j - 1]
    neighbours << layers[current_layer][i][j + 1]
    neighbours << layers[current_layer][i + 1][j]
    neighbours << layers[current_layer + 1][4][0]
    neighbours << layers[current_layer + 1][4][1]
    neighbours << layers[current_layer + 1][4][2]
    neighbours << layers[current_layer + 1][4][3]
    neighbours << layers[current_layer + 1][4][4]
  elsif i == 0
    neighbours << layers[current_layer][i][j - 1] if j > 0
    neighbours << layers[current_layer][i][j + 1] if j < 4
    neighbours << layers[current_layer][i + 1][j]
    neighbours << layers[current_layer - 1][1][2]
    neighbours << layers[current_layer - 1][2][1] if j == 0
    neighbours << layers[current_layer - 1][2][3] if j == 4
  elsif i == 4
    neighbours << layers[current_layer][i][j - 1] if j > 0
    neighbours << layers[current_layer][i][j + 1] if j < 4
    neighbours << layers[current_layer][i - 1][j]
    neighbours << layers[current_layer - 1][3][2]
    neighbours << layers[current_layer - 1][2][1] if j == 0
    neighbours << layers[current_layer - 1][2][3] if j == 4
  elsif j == 0
    neighbours << layers[current_layer][i - 1][j] if i > 0
    neighbours << layers[current_layer][i + 1][j] if i < 4
    neighbours << layers[current_layer][i][j + 1]
    neighbours << layers[current_layer - 1][2][1]
    neighbours << layers[current_layer - 1][1][2] if i == 0
    neighbours << layers[current_layer - 1][3][2] if i == 4
  elsif j == 4
    neighbours << layers[current_layer][i - 1][j] if i > 0
    neighbours << layers[current_layer][i + 1][j] if i < 4
    neighbours << layers[current_layer][i][j - 1]
    neighbours << layers[current_layer - 1][2][3]
    neighbours << layers[current_layer - 1][1][2] if i == 0
    neighbours << layers[current_layer - 1][3][2] if i == 4
  else
    neighbours << layers[current_layer][i - 1][j]
    neighbours << layers[current_layer][i + 1][j]
    neighbours << layers[current_layer][i][j - 1]
    neighbours << layers[current_layer][i][j + 1]
  end
  neighbours.count { _1 == '#' }
end

200.times do
  new_layers = layers.map { _1.map(&:clone) }

  (1...layers.size - 1).each do |layer_id|
    layer = new_layers[layer_id]
    (0...layer.size).each do |i|
      (0...layer[i].size).each do |j|
        next if i == 2 && j == 2

        bugs = count_bugs_layer(layers, i, j, layer_id)
        new_layers[layer_id][i][j] =
          if layers[layer_id][i][j] == '#' && bugs != 1
            '.'
          elsif layers[layer_id][i][j] == '.' && [1, 2].include?(bugs)
            '#'
          else
            layers[layer_id][i][j]
          end
      end
    end
  end
  layers = new_layers
end

p layers.map { _1.join.count('#') }.sum
