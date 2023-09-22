class VisitorController < ApplicationController
  def index
    return unless params[:balance_to_invest].present?

    @cotizations = CalculatePerformance.new(params[:balance_to_invest]).call
  end
end
