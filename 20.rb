input_file = File.readlines('./20.input')

def find_portals(maze)
  portals = {}
  (0..(maze.size - 2)).each do |i|
    (0..(maze[i].size - 2)).each do |j|
      next unless ('A'..'Z').include?(maze[i][j]) && ('A'..'Z').include?(maze[i][j + 1])

      level = [0, maze[i].size - 2, maze[i].size - 3].include?(j) ? 1 : -1
      if maze[i][j + 2] == '.'
        (portals["#{maze[i][j]}#{maze[i][j + 1]}"] ||= []) << [j + 2, i, level]
      else
        (portals["#{maze[i][j]}#{maze[i][j + 1]}"] ||= []) << [j - 1, i, level]
      end
    end
  end
  portals
end

portals = find_portals(input_file)
find_portals(input_file.map(&:chars).transpose.map(&:join)).each do |portal, points|
  portals[portal] ||= []
  portals[portal] += points.map { |y, x, level_delta| [x, y, level_delta] }
end
start = portals.delete('AA').first[0..1]
goal = portals.delete('ZZ').first[0..1]

portals_map = {}
portals.values.each do |points|
  a, b = points
  portals_map[a[0..1]] = b
  portals_map[b[0..1]] = a
end

paths = {}
([start] + portals_map.keys).each do |portal|
  portal_x, portal_y = portal
  queue = [portal]
  distance = { portal => 0 }
  portal_paths = {}
  until queue.empty?
    from = queue.shift
    from_x, from_y, level = from
    [[0, -1], [0, 1], [-1, 0], [1, 0]].each do |delta_x, delta_y|
      x = from_x + delta_x
      y = from_y + delta_y
      next if input_file[y][x] != '.'

      to = [x, y]
      next if distance.key?(to)

      distance[to] = distance[from] + 1
      if to == goal
        portal_paths[goal] = distance[to]
      elsif portals_map.key?(to)
        p_x, p_y, p_delta = portals_map[to]
        portal_paths[[p_x, p_y]] = [distance[to] + 1, p_delta]
      else
        queue << to
      end
    end
  end
  paths[portal] = portal_paths
end

def path(paths, start, goal, recursive)
  queue = [[start, 0]]
  distance = { queue.first => 0 }
  until queue.empty?
    from = queue.shift
    from_point, from_level = from
    return distance[from] + paths[from_point][goal] if paths[from_point].key?(goal) && from_level == 0

    paths[from_point].each do |point, data|
      next if point == goal

      dist, level = data
      to_level = recursive ? from_level + level : 0
      next if to_level < 0

      to = [point, to_level]
      next if distance.key?(to)

      distance[to] = distance[from] + dist
      queue << to
    end
  end
end

p path(paths, start, goal, false)

p path(paths, start, goal, true)
