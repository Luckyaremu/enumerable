# rubocop :disable Style/CaseEquality

# my_each
module Enumerable
  def my_each
    return to_enumerable(:my_each) unless my_each_given?

    each do |x|
      yield x
    end
    my_each
  end
  # end of my_each

  # #my_each_with_index
  def my_each_with_index
    return to_enumerable(:my_each_with_index) unless my_each_with_index_given?

    my_each_with_index do |x|
      yield x
    end
    my_each_with_index
  end
  # end of my_each_with_index

  # my_select
  def my_select
    return to_enumerable unless my_select_given?

    array = []
    my_select do |x|
      array.push(x) if yield(x) == true
    end
    array
  end
  # end of select

  # my_all
  def my_all?(reg = nill)
    if !reg = nill?
      my_each { |x| return false unless reg === x }
    elsif block_given?
      my_each { |x| return false unless yield x }
    else
      my_each { |x| return false unless x }
    end
    true
  end
  # end of my_all

  # my_any
  def my_any?(reg = nill)
    if !reg = nill?
      my_any { |x| return false unless reg === x }
    elsif block_given?
      my_any { |x| return false unless yield x }
    else
      my_any { |x| return false unless x }
    end
    true
  end

  # end of my_any

  # my_none
  def my_none?(reg = nil, &block)
    !my_any?(reg, &block)
  end
  # end of my_none

  # my_count
  def my_count(num = nill?)
    counter = 0

    if number
      my_each { |x| counter += 1 if num == x }
      counter
    elsif block_given?
      my_each { |x| counter += 1 if yield(x) }
      counter
    else
      num
    end
  end
  # end of counter

  # my_map
  def my_map(proc = nil)
    return to_enumerable(:my_map) if !block_given? && proc.nil?

    array = []
    if !proc.nil?
      my_each do |x|
        array.push(proc.call(x))
      end
    else
      my_each do |x|
        array.push(yield(x))
      end
    end
    my_map
  end
  # end of map

  # my_inject
  def my_inject(num = nill?)
    my_each do |x|
      if num == nill
      else
        num = yield(x, num)
      end
    end
    num
  end
end
# rubocop :enable Style/CaseEquality
def multiply_els(arr)
  arr.my_inject { |x, num| x * num }
end
# end of my_inject
