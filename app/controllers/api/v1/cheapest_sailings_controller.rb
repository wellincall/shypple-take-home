# frozen_string_literal: true

class Api::V1::CheapestSailingsController < ApplicationController
  def index
    return render status: :bad_request unless has_origin_and_destination?

    paths = path_builder.generate(params[:origin], params[:destination])

    return render status: :not_found if paths.blank?

    multilegs_finder = MultiLegs::Finder.new(paths: paths, sailings: current_mapping)
    sailings = multilegs_finder.call

    render json: sailings
  end

  private

  def has_origin_and_destination?
    params[:origin].present? && params[:destination].present?
  end

  def current_mapping
    @current_mapping ||= ::MapReduceReader.new.call
  end

  def direct_sailing_finder
    @direct_sailing_finder ||= ::DirectSailings::Finder.new(current_mapping)
  end

  def path_builder
    @path_builder ||= Routes::Generator.new(current_mapping)
  end
end
