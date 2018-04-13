class ResultsPresenter < ApplicationController

  def initialize(params)
    @age = params[:age].to_i unless params[:age].nil?
    @name = params[:name]
    @gender = params[:gender]
    @country_of_origin = params[:country_of_origin]
    @group_size = params[:group_size].to_i unless params[:group_size].nil?
    @country_of_seperation = params[:country_of_seperation]
  end

  def get_results
    return { message: "At least one attribute is needed" } if attributes_empty?
    NeuralNet.new.create_results(format_params)
    format_results
  end

  private

    attr_reader :age, :name, :gender, :country_of_origin, :group_size, :country_of_seperation

    def params_to_array
      [age, name, gender, country_of_origin, group_size, country_of_seperation]
    end

    def sanitized_params
      params_to_array.map do |attribute|
        sum_of_attribute(attribute) if attribute.class == String
      end
    end

    def format_params
      sanitized_params.map do |attribute|
        attribute ? attribute : " "
      end
    end

    def format_results
      CSV.open('./public/data/results.csv') do |row|
        row.shift
        shifted_row = row.shift
        if shifted_row[1] == "0"
          clean_disk
          return {status: "Deceased"}
        elsif shifted_row[1] == "2"
          clean_disk
          return {status: "Cannot locate"}
        else
          clean_disk
          return {status: "Located"}
        end
      end
    end

    def clean_disk
      FileUtils.rm('./public/data/results.csv')
      FileUtils.rm('./public/data/submission.csv')
    end

    def attributes_empty?
      format_params.uniq.count == 1 && format_params.uniq[0] == " "
    end

    def sum_of_attribute(attribute)
      attribute.chars.sum do |letter|
        letter.ord
      end
    end
end
