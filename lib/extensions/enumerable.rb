module Enumerable
  def sum
    inject { |result, element| result + element }
  end

  def mean
    sum / size
  end
end