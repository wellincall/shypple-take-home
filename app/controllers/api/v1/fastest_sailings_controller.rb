# frozen_string_literal: true

class Api::V1::FastestSailingsController< ApplicationController
  def index
    paths = path_search.execute(params[:origin], params[:destination])

    return render status: :not_found if paths.blank?

    multilegs_finder = MultiLegs::Finder.new(
      paths: paths, sailings: current_mapping, path_finder: by_arrival_finder
    )
    sailings = multilegs_finder.call

    render json: sailings
  end

  private

  def by_arrival_finder
    @direct_sailing_finder ||= ::DirectSailings::Finder.new(current_mapping, sorter: DirectSailings::Sorters::ByArrivalDate.new)
  end

  def path_search
    @path_search ||= Routes::Search.new(current_mapping)
  end
end
