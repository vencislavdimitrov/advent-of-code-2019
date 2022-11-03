input_file = File.read('./22.input').split "\n"

deck = (0...10_007).to_a
input_file.each do |line|
  tokens = line.split
  if tokens[0] == 'cut'
    deck = deck.slice(tokens.last.to_i..) + deck.slice(...tokens.last.to_i)
  elsif tokens[1] == 'with'
    inc = tokens.last.to_i
    new_deck = deck.clone
    current_pos = 0
    deck.each do |i|
      new_deck[current_pos] = i
      current_pos = (current_pos + inc) % deck.size
    end
    deck = new_deck
  else
    deck.reverse!
  end
end
p deck.find_index(2019)


m = 119315717514047
n = 101741582076661
pos = 2020
a = 1
b = 0
input_file.each do |line|
  tokens = line.split
  if tokens[0] == 'cut'
    arg = tokens.last.to_i
    b = (b - arg) % m
  elsif tokens[1] == 'with'
    arg = tokens.last.to_i
    a = (a * arg) % m
    b = (b * arg) % m
  else
    a = -a % m
    b = (m - 1 - b) % m
  end
end
r = (b * (1 - a).pow(m - 2, m)) % m
p ((pos - r) * a.pow(n * (m - 2), m) + r) % m
