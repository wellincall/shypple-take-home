# frozen_string_literal: true

class Api::V1::CheapestSailingsController < ApplicationController
  def index
    paths = path_search.execute(params[:origin], params[:destination])

    return render status: :not_found if paths.blank?

    multilegs_finder = MultiLegs::Finder.new(paths: paths, sailings: current_mapping)
    sailings = multilegs_finder.call

    render json: sailings
  end

  private

  def path_search
    @path_search ||= Routes::Search.new(current_mapping)
  end
end
