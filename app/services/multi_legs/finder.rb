# frozen_string_literal: true

class MultiLegs::Finder
  def initialize(paths:, sailings:, path_finder: DirectSailings::Finder.new(sailings)) 
    @paths = paths
    @sailings = sailings
    @path_finder = path_finder
  end

  def call
    costs = map_costs

    costs[costs.keys.min]
  end

  private

  attr_reader :paths, :sailings, :path_finder

  def map_costs
    paths.reduce({}) do |acc, path|
      cost = 0
      sailings = []
      path.each_cons(2) do |origin, destination|
        response = path_finder.call(origin, destination)
        cost += response[:cost_in_eur].to_d
        response.delete(:cost_in_eur)
        sailings += [response.merge(origin_port: origin)]
      end
      if acc.has_key?(cost)
        acc[cost] = sailings if acc[cost].length > sailings.length
      else
        acc[cost] = sailings
      end
      acc
    end
  end
end
