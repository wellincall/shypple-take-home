# frozen_string_literal: true

class SailingsMapper
  def initialize(input_file)
    @input_file = input_file
    @mapping = {}
  end

  def call
    import_origin_ports
    link_destinations_to_origins
    link_costs
    convert_costs_to_eur

    mapping
  end


  private

  attr_reader :input_file, :mapping

  def import_origin_ports
    input_file[:sailings].each do |sailing|
      mapping[sailing[:origin_port]] = []
    end
  end

  def link_destinations_to_origins
    input_file[:sailings].each do |sailing|
      mapping[sailing[:origin_port]].append(
        {
          destination_port: sailing[:destination_port],
          departure_date: sailing[:departure_date],
          arrival_date: sailing[:arrival_date],
          sailing_code: sailing[:sailing_code]
        }
      )
    end
  end

  def link_costs
    mapping.values.each do |legs|
      legs.each do |leg| 
        cost = input_file[:rates].find do |rate|
          rate[:sailing_code] == leg[:sailing_code]
        end
        leg[:rate] = cost[:rate]
        leg[:rate_currency] = cost[:rate_currency]
      end
    end
  end

  def convert_costs_to_eur
    exchange_rates = input_file[:exchange_rates].deep_stringify_keys
    mapping.values.each do |legs|
      legs.each do |leg| 
        if leg[:rate_currency] == "EUR"
          leg[:cost_in_eur] = leg[:rate]
        else
          convertion_rate = exchange_rates[leg[:departure_date]][leg[:rate_currency].downcase].to_d
          leg[:cost_in_eur] = "#{(leg[:rate].to_d / convertion_rate).round(2)}"
        end
      end
    end
  end
end

