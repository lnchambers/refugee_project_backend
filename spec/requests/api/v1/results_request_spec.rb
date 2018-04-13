require 'rails_helper'

describe "Results API" do
  it "sends the results of the machine learning" do
    get "/api/v1/results?age=12&name=grant-ward&gender=Cis-Female&country_of_origin=madagascar&group_size=3&country_of_seperation=madagascar&client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}"

    expect(response).to be_success
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:status]).to eq("Deceased")
  end

  it "sends the results of the machine learning again" do
    get "/api/v1/results?age=50&name=Richard-Ward&gender=Cis-Male&country_of_origin=iran&group_size=3&country_of_seperation=turkey&client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}"

    expect(response).to be_success
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:status]).to eq("Deceased")
  end

  it "testing different results" do
    get "/api/v1/results?age=25&name=Harry-Potter&gender=Trans-Male&country_of_origin=Yemen&group_size=1&country_of_seperation=Italy&client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}"

    expect(response).to be_success
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:status]).to eq("Deceased")
  end

  it "testing different results again" do
    get "/api/v1/results?age=28&name=Hermione-Granger&gender=Trans-Female&country_of_origin=Barbados&group_size=2&country_of_seperation=Barbados&client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}"

    expect(response).to be_success
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:status]).to eq("Deceased")
  end

  it "will deny an invalid request without id and secret key" do
    lambda {
        get "/api/v1/results?age=50&name=richard-ward&gender=amab&country_of_origin=iran&group_size=3&country_of_seperation=turkey"
      }.should raise_error(ActionController::RoutingError)
  end

  it "will deny an invalid request without id" do
    lambda {
        get "/api/v1/results?age=50&name=richard-ward&gender=amab&country_of_origin=iran&group_size=3&country_of_seperation=turkey&client_secret=#{ENV['CLIENT_SECRET']}"
      }.should raise_error(ActionController::RoutingError)
  end

  it "will deny an invalid request without secret key" do
    lambda {
        get "/api/v1/results?age=50&name=richard-ward&gender=amab&country_of_origin=iran&group_size=3&country_of_seperation=turkey&client_id=#{ENV['CLIENT_ID']}"
      }.should raise_error(ActionController::RoutingError)
  end

  it "should allow a request with missing attributes" do
    get "/api/v1/results?gender=amab&group_size=3&client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}"

    expect(response).to be_success
  end

  it "shouldn't allow a request without attributes" do
    get "/api/v1/results?client_id=#{ENV['CLIENT_ID']}&client_secret=#{ENV['CLIENT_SECRET']}"

    expect(response).to be_success
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed[:message]).to eq("At least one attribute is needed")
  end
end
