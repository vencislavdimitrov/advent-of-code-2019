moons = File.readlines('./12.input').map { |line| line.match(/<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/)}.map { |e| e[1..].map(&:to_i) }
# moons = '<x=-1, y=0, z=2>|<x=2, y=-10, z=-7>|<x=4, y=-8, z=8>|<x=3, y=5, z=-1>'.split('|').map { |line| line.match(/<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/)}.map { |e| e[1..].map(&:to_i) }
# moons = '<x=-8, y=-10, z=0>|<x=5, y=5, z=10>|<x=2, y=-7, z=3>|<x=9, y=-8, z=-3>'.split('|').map { |line| line.match(/<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/)}.map { |e| e[1..].map(&:to_i) }

velocity = [
  [0, 0, 0],
  [0, 0, 0],
  [0, 0, 0],
  [0, 0, 0],
]

start_moons = moons.map(&:clone)
start_velocity = velocity.map(&:clone)

def calculate_gravity(moons, velocity)
  (0...moons.size-1).each do |m1|
    ((m1+1)...moons.size).each do |m2|
      (0..2).each do |i|
        if moons[m1][i] < moons[m2][i]
          velocity[m1][i] += 1
          velocity[m2][i] -= 1
        elsif moons[m1][i] > moons[m2][i]
          velocity[m1][i] -= 1
          velocity[m2][i] += 1
        end
      end
    end
  end
end

def calculate_position(moons, velocity)
  (0...moons.size).each do |i|
    (0..2).each do |j|
      moons[i][j] += velocity[i][j]
    end
  end
end

def total_energy(moons, velocity)
  total = 0
  (0...moons.size).each do |i|
    total += moons[i].map(&:abs).inject(&:+) * velocity[i].map(&:abs).inject(&:+)
  end
  total
end


def print(moons, velocity)
  (0...moons.size).each do |i|
    pp "pos=<x=#{moons[i][0]}, y=#{moons[i][1]}, z= #{moons[i][2]}>, vel=<x=#{velocity[i][0]}, y=#{velocity[i][1]}, z=#{velocity[i][2]}>"
  end
  pp '------'
end

1000.times do |i|
  calculate_gravity moons, velocity
  calculate_position moons, velocity
end
pp total_energy moons, velocity

moons = start_moons.map(&:clone)
velocity = start_velocity.map(&:clone)
f = [nil, nil, nil]
1000000.times do |i|
  calculate_gravity moons, velocity
  calculate_position moons, velocity

  (0..2).each do |j|
    if moons.map { |e| e[j] } == start_moons.map { |e| e[j] } && velocity.map { |e| e[j] } == start_velocity.map { |e| e[j] }
      f[j] = i+1 if f[j].nil?
      break if f.size == 3
    end
  end
end
pp f.reduce(1, :lcm)