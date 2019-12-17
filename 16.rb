input_file = File.read('./16.input')

test1 = '12345678'
test2 = '80871224585914546619083218645595'
test3 = '19617804207202209144916044189917'
test4 = '69317163492948606335995924319873'
test5 = '03036732577212944063491565474664'

signal = input_file
100.times do
  digits = signal.chars.map(&:to_i)
  signal = ''
  (0...digits.size).each do |i|
    res = 0
    multipliers = [0, 1, 0, -1].each_slice(1).map { |s| s * (i+1) }.inject(&:+)
    multipliers = multipliers * (digits.size / multipliers.size + 1)
    (0...digits.size).each do |j|
      res += digits[j] * multipliers[j + 1]
    end
    signal += (res.abs % 10).to_s
  end
end

pp signal[0..7]

signal = input_file * 10000
offset = signal[0..6].to_i
signal = signal[offset..].chars.map(&:to_i)
100.times do
  (0..(signal.size - 2)).reverse_each do |i|
    signal[i] = (signal[i] + signal[i + 1]) % 10
  end
end

p signal[0..7].join ''