require 'rails_helper'

describe "Results API" do
  it "sends the results of the machine learning" do
    get "/api/v1/results?age=12&gender=afab&country_of_origin=madagascar&group_size=3&country_of_seperation=madagascar&client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}"

    expect(response).to be_success
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:status]).to eq("Deceased")
  end

  it "sends the results of the machine learning again" do
    get "/api/v1/results?age=50&gender=amab&country_of_origin=iran&group_size=3&country_of_seperation=turkey&client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}"

    expect(response).to be_success
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:status]).to eq("Deceased")
  end

  it "will deny an invalid request without id and secret key" do
    lambda {
        get "/api/v1/results?age=50&gender=amab&country_of_origin=iran&group_size=3&country_of_seperation=turkey"
      }.should raise_error(ActionController::RoutingError)
  end

  it "will deny an invalid request without id" do
    lambda {
        get "/api/v1/results?age=50&gender=amab&country_of_origin=iran&group_size=3&country_of_seperation=turkey&client_secret=#{ENV['CLIENT_SECRET']}"
      }.should raise_error(ActionController::RoutingError)
  end

  it "will deny an invalid request without secret key" do
    lambda {
        get "/api/v1/results?age=50&gender=amab&country_of_origin=iran&group_size=3&country_of_seperation=turkey&client_id=#{ENV['CLIENT_ID']}"
      }.should raise_error(ActionController::RoutingError)
  end
end
