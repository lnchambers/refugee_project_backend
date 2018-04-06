class Observation

  attr_reader :label, :features

  def initialize(row, label_index)
    if label_index == :none
      @label = :none
    else
      @label = get_label_index(row, label_index)
      row.delete_at(label_index)
    end

    @features = row.collect { |s| s.to_i }
  end

  def get_label_index(row, label_index)
    case row[label_index]
    when "found"
      row[label_index] = 1
    else
      row[label_index] = 0
    end
  end
end
