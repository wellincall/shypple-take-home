# frozen_string_literal: true

class DirectSailings::Sorters::ByCost
  def call(leg1, leg2)
    leg1[:cost_in_eur] <=> leg2[:cost_in_eur]
  end
end
