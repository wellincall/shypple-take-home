# frozen_string_literal: true

class Api::V1::DirectSailingsController < ApplicationController
  def index
    response = direct_sailing_finder.call(params[:origin], params[:destination])

    return render json: {}, status: :not_found if response.blank?

    json_response = ::LegSerializer.new(response)

    render json: [json_response.serialize], status: :ok
  end

  private

  def direct_sailing_finder
    @direct_sailing_finder ||= ::DirectSailings::Finder.new(current_mapping)
  end
end
