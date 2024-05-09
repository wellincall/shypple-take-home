# frozen_string_literal: true

class DirectSailings::Sorters::ByArrivalDate
  def call(leg1, leg2)
    leg1[:arrival_date] <=> leg2[:arrival_date]
  end
end
