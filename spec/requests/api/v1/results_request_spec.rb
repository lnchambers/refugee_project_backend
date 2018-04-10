require 'rails_helper'

describe "Results API" do
  it "sends the results of the machine learning" do
    get '/api/v1/results?age=12&gender=afab&country_of_origin=madagascar&group_size=3&country_of_seperation=madagascar'

    expect(response).to be_success
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:status]).to eq("Deceased")
  end

  it "sends the results of the machine learning again" do
    get '/api/v1/results?age=50&gender=amab&country_of_origin=iran&group_size=3&country_of_seperation=turkey'

    expect(response).to be_success
    parsed = JSON.parse(response.body, symbolize_names: true)
    expect(parsed[:status]).to eq("Deceased")
  end
end
