# frozen_string_literal: true

class Routes::Search
  def initialize(sailings)
    @sailings = sailings
  end

  def execute(origin, destination)
    return [] unless sailings.has_key?(origin)
    return [] unless known_destination?(destination)

    search_paths_between(origin, destination)
  end

  private

  attr_reader :sailings

  def known_destination?(destination)
    all_destinations = sailings.values.flatten

    all_destinations.any? do |leg|
      leg[:destination_port] == destination
    end
  end

  def search_paths_between(origin, target)
    paths = generate_paths_from_node(origin)
    paths.reject { |path| path.last != target }
  end

  def generate_paths_from_node(node, path=[])
    current_path = path + [node]
    return [current_path] if sailings[node].blank?

    paths = [path + [node]]
    
    next_destinations = sailings[node].map {|dest| dest[:destination_port]}.uniq
    available_destinations = next_destinations.reject {|nd| path.include?(nd) }
    available_destinations.each do |nd|
      paths += generate_paths_from_node(nd, current_path)
    end
    paths
  end
end
