# rubocop: disable Metrics/ModuleLength
module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    array = []
    while i < size
      yield to_a[i]
      array << to_a[i]
      i += 1
    end
    array
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    array = []
    while i < size
      yield to_a[i], i
      array << to_a[i]
      i += 1
    end
    array
  end

  def my_select
    return to_enum unless block_given?

    array = []
    my_each do |x|
      array.push(x) if yield(x) == true
    end
    array
  end

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop: disable Metrics/CyclomaticComplexity

  def my_all?(arg = nil)
    return true if !block_given? && arg.nil? && include?(nil) == false && include?(false) == false
    return false unless block_given? || !arg.nil?

    if block_given?
      my_each { |x| return false if yield(x) == false }
    elsif arg.class == Regexp
      my_each { |x| return false if arg.match(x).nil? }
    elsif arg.class <= Numeric || arg.class <= String
      my_each { |x| return false if x != arg }
    else
      my_each { |x| return false if (x.is_a? arg) == false }
    end
    true
  end

  def my_any?(arg = nil)
    return true if !block_given? && arg.nil? && !include?(nil) && !include?(false)
    return true unless block_given? || !arg.nil?

    if block_given?
      my_each { |x| return true if yield(x) == true }
    elsif arg.class == Regexp
      my_each { |x| return true unless arg.match(x).nil? }
    elsif arg.class <= Numeric || arg.class <= String
      my_each { |x| return true if x == arg }
    else
      my_each { |x| return true if x.class <= arg }
    end
    false
  end

  def my_none?(arg = nil)
    return true if !block_given? && arg.nil? && include?(nil) == false && include?(false) == false
    return false unless block_given? || !arg.nil?

    if block_given?
      my_each { |x| return false if yield(x) == true }
    elsif arg.class == Regexp
      my_each { |x| return false if arg.match(x).nil? }
    elsif arg.class <= Numeric || arg.class <= String
      my_each { |x| return false if x != arg }
    else
      my_each { |x| return false if (x.is_a? arg) == false }
    end
    true
  end

  def my_count(proc = nil)
    arr = self
    i = 0
    if proc
      my_each do |x|
        next unless x == proc

        i += 1
      end
      return i
    end
    if block_given?
      arr.my_each do |x|
        next unless (yield x) == true

        i += 1
      end
      return i
    end
    arr.my_each do
      i += 1
    end
    i
  end

  def my_map(proc = nil)
    ar = self
    new_arr = []
    unless proc.nil?
      each do |x|
        return false unless proc.yield x
      end
      return true
    end
    return to_enum unless block_given? && proc.nil?

    ar.my_each do |j|
      a = yield j
      new_arr.append(a)
    end
    new_arr
  end

  # rubocop: disable Metrics/MethodLength

  def my_inject(cum = nil, arg = nil)
    arr = to_a
    if block_given?
      if cum.nil?
        mat = arr[0]
        arr[1...arr.length].my_each do |x|
          mat = yield(mat, x)
        end
      else
        mat = cum
        arr.my_each do |x|
          mat = yield(mat, x)
        end
      end
    elsif !cum.nil? && !arg.nil?
      mat = cum
      my_each do |x|
        mat = mat.send(arg, x)
      end
    elsif !cum.nil? && arg.nil?
      mat = self[0]
      arr[1...arr.length].my_each do |x|
        mat = mat.send(cum, x)
      end
    end
    mat
  end

  # rubocop: enable Metrics/MethodLength

  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop: enable Metrics/CyclomaticComplexity

  def multiply_els(arr)
    arr.my_inject { |x, num| x * num }
  end
end

# rubocop: enable Metrics/ModuleLength

=begin
p [1,2,3,4,5].my_all?
p [1,2,3,4,5].my_any?
p [1,2,3,4,5].my_none?


arr = [1, 2, 3, 4, 5, 6]
t = [nil, true, '']
p arr.each.class == arr.my_each.class
p t.each_with_index.class == t.my_each_with_index.class
p t.my_select.class == t.my_select.class
p t.count == t.my_count
p t.map.class == t.my_map.class
p arr.inject(:+) == arr.my_inject(:+)
=end
