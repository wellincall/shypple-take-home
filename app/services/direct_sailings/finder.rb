# frozen_string_literal: true

class DirectSailings::Finder
  def initialize(sailings)
    @sailings = sailings
  end

  def call(origin, destination)
    return {} unless sailings.has_key?(origin)
    return {} unless has_direct_connection?(origin, destination)

    direct_connections = sailings[origin].select do |leg|
      leg[:destination_port] == destination
    end

    connections_by_cost = direct_connections.sort do |leg1, leg2|
      leg1[:cost_in_eur].to_d <=> leg2[:cost_in_eur].to_d
    end

    connections_by_cost[0].merge(origin_port: origin)
  end

  private

  attr_reader :sailings

  def has_direct_connection?(origin, destination)
    sailings[origin].any? do |leg|
      leg[:destination_port] == destination
    end
  end
end
