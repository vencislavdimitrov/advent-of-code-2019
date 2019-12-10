input_file = File.read('./8.input').split ''

layers = input_file.each_slice(25 * 6).to_a

def count_digits(arr, digit)
  arr.select { |n| n.to_i == digit }.count
end
l = layers.min { |l1, l2| count_digits(l1, 0) <=> count_digits(l2, 0) }

pp count_digits(l, 1) * count_digits(l, 2)

final_image = '2' * 150

(0..150).each do |i|
  layers.each do |l|
    final_image[i] = l[i] if final_image[i] == '2'
  end
end

final_image.split('').each_slice(25) do |line|
  pp line.map { |c| c == '1' ? '*' : ' ' }.join
end