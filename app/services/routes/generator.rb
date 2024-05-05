# frozen_string_literal: true

class Routes::Generator
  def initialize(sailings)
    @sailings = sailings
  end

  def generate(origin, destination)
    return [] unless sailings.has_key?(origin)
    return [] unless known_destination?(destination)

    generate_paths_between(origin, destination)
  end

  attr_reader :sailings

  def known_destination?(dest)
    all_destinations = sailings.values.flatten

    all_destinations.any? do |destination|
      destination[:destination_port] == dest
    end
  end

  def generate_paths_between(origin, target, parents=[])
    return [] if sailings[origin].blank?

    next_destinations = sailings[origin].map {|l| l[:destination_port]}.uniq
     
  end

  def generate_path_from(node, path)
    return path if sailings[node].blank?
    
    next_destinations = sailings[node].map {|dest| dest[:destination_port]}.uniq
    next_destinations = next_destinations.reject {|nd| path.include?(nd) }
    next_destinations.map do |nd|
      generate_path_from(nd, path +[node])
    end
  end
end
