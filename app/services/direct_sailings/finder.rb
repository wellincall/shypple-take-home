# frozen_string_literal: true

class DirectSailings::Finder
  def initialize(sailings, sorter: DirectSailings::Sorters::ByCost.new)
    @sailings = sailings
    @sorter = sorter
  end

  def call(origin, destination)
    return {} unless sailings.has_key?(origin)
    return {} unless has_direct_connection?(origin, destination)

    direct_connections = sailings[origin].select do |leg|
      leg[:destination_port] == destination
    end

    connections_by_cost = direct_connections.sort do |leg1, leg2|
      sorter.call(leg1, leg2)
    end

    connections_by_cost[0].merge(origin_port: origin)
  end

  private

  attr_reader :sailings, :sorter

  def has_direct_connection?(origin, destination)
    sailings[origin].any? do |leg|
      leg[:destination_port] == destination
    end
  end
end
