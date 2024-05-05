# frozen_string_literal: true

class LegSerializer
  def intialize(leg)
    @leg = leg
  end

  def serialize
    leg.slice(
      :origin_port, :destination_port, :departure_date,
      :arrival_date, :rate, :rate_currency, :sailing_code
    )
  end

  private

  attr_reader :leg
end
