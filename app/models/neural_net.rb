require_relative 'data_table.rb'
require 'nmatrix'
require 'csv'
require 'optparse'


class NeuralNet

  def initialize
    @hidden_func = 'rect_lin'
    @output_func = 'softmax'
    @eval_or_train = 'eval'
    @number_of_classes = 10
    @input_size = 6
  end

  def load_trained_weights
    @w1 = Marshal.load(File.binread('./public/data/w1.txt')).to_nm
    @w2 = Marshal.load(File.binread('./public/data/w2.txt')).to_nm
  end

  def create_results(format_params)
   load_trained_weights
   params_to_csv(format_params)
   @hidden_nodes = @w1.shape[1]
   data_table = DataTable.new({:file => './public/data/submission.csv' , :label_index => 6})
   CSV.open("./public/data/results.csv", "wb") do |csv|
     csv << ["StatusID", "Status"]
     data_table.observations.each_with_index do |observation,i |
       csv << [(i+1).to_s, forward(observation,{:eval_or_train => 'eval'}) ]
      end
    end
  end

  def params_to_csv(format_params)
    CSV.open('./public/data/submission.csv', 'wb') do |row|
      format_params << " "
      row << format_params
    end
  end

  def forward(observation,opts ={})
    a1 = observation.features.flatten.to_nm([1,@input_size + 1]) / 255.0
    a1[0, @input_size ] = 1.0
    z2 = a1.dot(@w1)
    a2 = activation_function(z2,@hidden_func)
    a2_with_bias = NMatrix.zeroes([1,@hidden_nodes+1])
    a2_with_bias[0,0..@hidden_nodes] = a2
    a2_with_bias[0,@hidden_nodes] = 1.0
    z3 = a2_with_bias.dot(@w2)
    a3 = activation_function(z3,@output_func)
    return a3.each_with_index.max[1]
  end

  def sigmoid(mat)
    NMatrix.ones(mat.shape)/(NMatrix.ones(mat.shape)+(-mat).exp)
  end

  def rect_lin(mat)
    (mat / 10.0).map do |el|
      if el < 0
        0
      else
       el
      end

    end
  end

  def tanh(mat)
    ( (mat).exp - (-mat).exp )/( (mat).exp + (-mat).exp )
  end

  def sine(mat)
    mat.sin
  end

  def softmax(mat)
    mat.map!{|el| Math::exp(el) }
    sum = mat.inject(0){|sum,el| sum = sum + el}
    mat.map{|el| el / sum.to_f}
  end

  def activation_function(mat,func)
    if func == 'sin'
      return  mat.sin
    elsif func == 'sigmoid'
      return sigmoid(mat)
    elsif func == 'tanh'
      return tanh(mat)
    elsif func == 'rect_lin'
      return rect_lin(mat)
    elsif func == 'softmax'
      return softmax(mat)
    end
  end

  def derivative(mat,func)
    if func == 'sin'
      return mat.cos
    elsif func == 'sigmoid'
      return (sigmoid(mat) * (NMatrix.ones(mat.shape) - sigmoid(mat)))
    elsif func == 'tanh'
      return (NMatrix.ones(mat.shape)-tanh(mat)) * (NMatrix.ones(mat.shape) + tanh(mat))
    elsif func == 'rect_lin'
      temp = (mat / 10.0 ).map do |el|
        if el < 0
          0
        else
          1.0 / 10.0
        end
      end

      return temp
    end
  end
end
