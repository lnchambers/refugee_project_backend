class ApplicationController < ActionController::API

  def request_is_authorized?
    ENV['CLIENT_ID'] == params[:client_id] && ENV['CLIENT_SECRET'] == params[:client_secret]
  end
  
end
