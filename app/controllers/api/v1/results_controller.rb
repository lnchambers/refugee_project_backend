class Api::V1::ResultsController < ApplicationController
  def show
    render json: ResultsPresenter.new(params).get_results
  end
end
