require 'rails_helper'

describe "Results API" do
  it "sends the results of the machine learning" do
    get '/api/v1/results'

    expect(response).to be_success
  end
end
