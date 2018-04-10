require_relative 'data_table.rb'
require 'nmatrix'
require 'csv'
require 'optparse'
require 'pry'


class NeuralNet

  def initialize
    @hidden_func = 'rect_lin'
    @output_func = 'softmax'
    @eval_or_train = 'eval'
    @number_of_classes = 10
    @input_size = 784
  end

  def load_trained_weights
    @w1 = Marshal.load(File.binread('./public/data/w1.txt')).to_nm
    @w2 = Marshal.load(File.binread('./public/data/w2.txt')).to_nm
  end

  def create_results(format_params)
   load_trained_weights
   params_to_csv(format_params)
   @hidden_nodes = @w1.shape[1]
   data_table = DataTable.new({:file => './data/submission.csv' , :label_index => 6})
   CSV.open("./data/results.csv", "wb") do |csv|
     csv << ["StatusID", "Label"]
     data_table.observations.each_with_index do |observation,i |
       csv << [(i+1).to_s, forward(observation,{:eval_or_train => 'eval'}) ]
      end
    end
  end

  def params_to_csv(format_params)
    CSV.open('./data/submission.csv', 'wb') do |row|
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
    if opts[:eval_or_train] == 'train'
      backprop(a1,a2_with_bias,z2,z3,a3,observation.label)
    elsif opts[:eval_or_train] == 'eval'
      return a3.each_with_index.max[1]
    end
  end

  def backprop(a1,a2_with_bias,z2,z3,a3,label)
    y = NMatrix.zeroes([1,10])
    y[0,label] = 1.0

    d3 = -(y - a3)
    @error_history <<  d3.transpose.abs.sum[0]
    @classification_history <<  (a3.each_with_index.max[1] == label ? 1.0 : 0.0)
    d2 =  @w2.dot( d3.transpose )[0..(@hidden_nodes-1)] * derivative(z2.transpose,@hidden_func)
    grad1 = d2.dot(a1)
    grad2 = d3.transpose.dot(a2_with_bias)

    @w1 = @w1 - grad1.transpose * @alpha  * 0.1
    @w2 = @w2 - grad2.transpose * @alpha
  end

  def train
    puts "Entered Training"
    i = 0
    start_time = Time.now
    initialize_new_weights

    loop do
      forward(@dt.sample,{:eval_or_train => 'train'})

      ave_error_history = running_average(1000,@error_history)
      ave_error_history_5000 = running_average(5000,@error_history)
      ave_classification_history = running_average(1000,@classification_history)
      ave_classification_history_5000 = running_average(5000,@classification_history)
      ratio = (ave_classification_history  / ave_classification_history_5000)

      puts "Running Average Error (1000)          => #{ave_error_history}"
      puts "Running Average Error (5000)          => #{ave_error_history_5000}"
      puts "Running Average Classification (1000) => #{ave_classification_history} "
      puts "Running Average Classification (5000) => #{ave_classification_history_5000}"
      puts "Classification Running Average Ratio  => #{ratio}"

      puts "Iteration = #{i}"
      puts "---"

      if ratio < 1.0 and i > 60000
        finish_time = Time.now
        puts File.open('./data/w1.txt','w'){|f| f << Marshal.dump(@w1.to_a)}
        puts File.open('./data/w2.txt','w'){|f| f << Marshal.dump(@w2.to_a)}
        puts "Total training time was: #{(finish_time - start_time).round(0)} sec"
        break
      end

    i += 1
    end
  end

  def running_average(scale,ary)
    ary.last(scale).inject{ |sum, el| sum + el}.to_f / [scale,ary.size].min
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
