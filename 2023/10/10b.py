import argparse
import re


# parse script args
parser = argparse.ArgumentParser(description='Advent of Code 2023: Day 10')
parser.add_argument('filename', help='The file containing the puzzle input')
args = parser.parse_args()

# setup some global maps for relative directions
direction_map = {
    'N': [0, -1], 'E': [1, 0], 'S': [0, 1], 'W': [-1, 0]
}
char_map = {
    '|': [direction_map['N'], direction_map['S']],
    '-': [direction_map['E'], direction_map['W']],
    'L': [direction_map['N'], direction_map['E']],
    'J': [direction_map['N'], direction_map['W']],
    '7': [direction_map['S'], direction_map['W']],
    'F': [direction_map['E'], direction_map['S']],
    'S': [direction_map['N'], direction_map['E'],
          direction_map['S'], direction_map['W']],
    '.': []
}


# parse map data to list of lists
def parse_map(input):
    map_data = []
    for line in input.split('\n'):
        map_data.append(list(line.strip()))
    return map_data


# determine the location of the starting tile
def find_start_location(map_data):
    for y, data in enumerate(map_data):
        if 'S' in data:
            return [data.index('S'), y]


# determine the type of a tile (start)
def determine_tile(location, map_data):
    neighbors = get_neighbors(location, map_data)
    confirmed_directions = []
    for neighbor in neighbors:
        next_neighbors = get_neighbors(neighbor, map_data)
        for next_neighbor in next_neighbors:
            if next_neighbor == location:
                relative_direction = [neighbor[0] - next_neighbor[0],
                                      neighbor[1] - next_neighbor[1]]
                confirmed_directions.append(relative_direction)
    for char, directions in char_map.items():
        if directions == confirmed_directions:
            return char


# calculate the path from a parsed map
def calculate_path(start_location, map_data):
    path_data = [start_location]
    current_location = get_neighbors(start_location, map_data)[0]
    while current_location != start_location:
        path_data.append(current_location)
        neighbors = get_neighbors(current_location, map_data)
        for neighbor in neighbors:
            if neighbor != path_data[-2]:
                current_location = neighbor
                break
    return path_data


# calculate neighbor locations
def get_neighbors(location, map_data):
    char = map_data[location[1]][location[0]]
    neighbors = []
    neighbor_directions = char_map[char]
    for direction in neighbor_directions:
        neighbor = [location[0] + direction[0], location[1] + direction[1]]
        neighbors.append(neighbor)
    return neighbors


# get positions of vertical intersections for a row
def get_raycast_intersections(row_data):
    string = "".join(row_data)
    pattern = r"(F\-*J|L\-*7|\|)"
    positions = []
    for result in re.finditer(pattern, string):
        positions.append(result.start())
    return positions


def get_inside_locations(path_data, map_data):
    # clear useless map characters
    for y, data in enumerate(map_data):
        for x, char in enumerate(data):
            if [x, y] not in path_data:
                map_data[y][x] = " "
    inside_locations = []
    # loop through all locations
    for y, data in enumerate(map_data):
        intersects = get_raycast_intersections(data)
        if not intersects:
            continue
        for x, char in enumerate(data):
            if [x, y] in path_data:
                continue
            intersect_count = len(list(filter(lambda z: (z > x), intersects)))
            if intersect_count % 2:
                map_data[y][x] = "*"
                inside_locations.append([x, y])
    return inside_locations


# process puzzle input file
with open(args.filename) as file:
    input = file.read()

# parse map
map_data = parse_map(input)

# determine start location and replace 'S' with correct tile type
start_location = find_start_location(map_data)
map_data[start_location[1]][start_location[0]] = determine_tile(start_location,
                                                                map_data)

# calculate part 1
path_data = calculate_path(start_location, map_data)
answer = int(len(path_data) / 2)
print("The answer for part 1 is {}".format(answer))

# calculate part 2
inside_locations = get_inside_locations(path_data, map_data)
answer = int(len(inside_locations))
print("The answer for part 2 is {}".format(answer))
