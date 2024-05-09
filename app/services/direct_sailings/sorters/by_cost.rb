# frozen_string_literal: true

class DirectSailings::Sorters::ByCost
  def call(leg1, leg2)
    leg1[:cost_in_eur].to_d <=> leg2[:cost_in_eur].to_d
  end
end
