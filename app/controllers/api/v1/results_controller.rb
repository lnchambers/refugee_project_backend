class Api::V1::ResultsController < ApplicationController
  def show
    if request_is_authorized?
      render json: ResultsPresenter.new(params).get_results
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
