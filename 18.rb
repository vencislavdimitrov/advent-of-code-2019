input_file = File.read('18.input')

@maze = input_file.split("\n")

def parse_maze
  @start = {}
  @key_pos = {}
  @maze.each_with_index do |line, y|
    line.each_char.with_index do |tile, x|
      if tile == '@'
        @start["@#{@start.count}"] = [x, y]
      elsif tile =~ /\A[[:lower:]]\z/
        @key_pos[tile] = [x, y]
      end
    end
  end

  @key_to_key = {}
  @key_pos.merge(@start).each do |key, key_pos|
    queue = [[*key_pos, []]]
    distance = { key_pos => 0 }
    keys = []
    until queue.empty?
      from_x, from_y, needed_keys = queue.shift
      [[0, -1], [0, 1], [-1, 0], [1, 0]].each do |delta_x, delta_y|
        x = from_x + delta_x
        y = from_y + delta_y
        tile = @maze[y][x]
        next if tile == '#'
        next if distance.key?([x, y])

        distance[[x, y]] = distance[[from_x, from_y]] + 1
        keys << [tile, needed_keys, distance[[x, y]]] if tile =~ /\A[[:lower:]]\z/

        new_key_needed = tile.match?(/\A[[:alpha:]]\z/) ? [tile.downcase] : []
        queue << [x, y, needed_keys + new_key_needed]
      end
    end
    @key_to_key[key] = keys
  end
end

def reachable_keys(pos, unlocked = [])
  keys = []
  pos.each_with_index do |from_key, robot|
    @key_to_key[from_key].each do |key, needed_keys, distance|
      next if unlocked.include?(key)
      next unless (needed_keys - unlocked).empty?

      keys << [robot, key, distance]
    end
  end
  keys
end

def min_steps(pos, unlocked = [])
  cache_key = [pos.sort.join, unlocked.sort.join]
  return @cache[cache_key] if @cache[cache_key]

  keys = reachable_keys(pos, unlocked)
  @cache[cache_key] =
    if keys.empty?
      0
    else
      steps = []
      keys.each do |robot, key, distance|
        orig = pos[robot]
        pos[robot] = key
        steps << distance + min_steps(pos, unlocked + [key])
        pos[robot] = orig
      end
      steps.min
    end
  @cache[cache_key]
end

parse_maze
@cache = {}
pp min_steps(@start.keys)

sx, sy = @start.values.first
@maze[sy - 1][sx - 1..sx + 1] = '@#@'
@maze[sy + 1][sx - 1..sx + 1] = '@#@'
@maze[sy][sx - 1..sx + 1] = '###'

parse_maze
@cache = {}
pp min_steps(@start.keys)
