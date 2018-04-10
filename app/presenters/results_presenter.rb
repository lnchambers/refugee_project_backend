class ResultsPresenter

  def initialize(params)
    @age = params[:age]
    @name = params[:name]
    @gender = params[:gender]
    @country_of_origin = params[:country_of_origin]
    @group_size = params[:group_size]
    @country_of_seperation = params[:country_of_seperation]
  end

  def get_results
    NeuralNet.new.create_results(format_params)
    CSV.open('./data/results.csv') do |row|
      row.shift
      shifted_row = row.shift
      if shifted_row[1] == "0"
        return {status: "Deceased"}
      elsif shifted_row[1] == "2"
        return {status: "Cannot locate"}
      else
        return {status: "Located"}
      end
    end
  end

  private

    attr_reader :age, :name, :gender, :country_of_origin, :group_size, :country_of_seperation

    def params_to_array
      [age, name, gender, country_of_origin, group_size, country_of_seperation]
    end

    def format_params
      params_to_array.map do |attribute|
        attribute ? attribute : " "
      end
    end

end
