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
