# frozen_string_literal: true

class Api::V1::DirectSailingsController < ApplicationController
  def index
    return render status: :bad_request unless has_origin_and_destination?
    
    response = direct_sailing_finder.call(params[:origin], params[:destination])

    return render json: {}, status: :not_found if response.blank?

    json_response = ::LegSerializer.new(response)

    render json: [json_response.serialize], status: :ok
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
end
