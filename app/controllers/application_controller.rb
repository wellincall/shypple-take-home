class ApplicationController < ActionController::API
  before_action :check_params

  private

  def current_mapping
    @current_mapping ||= ::MapReduceReader.new.call
  end

  def check_params
    return render status: :bad_request unless has_origin_and_destination?
  end

  def has_origin_and_destination?
    params[:origin].present? && params[:destination].present?
  end
end
